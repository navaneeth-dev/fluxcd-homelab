import * as talos from "@pulumi/talos";
import * as pulumi from "@pulumi/pulumi";
import * as flux from "@pulumi/flux";
import * as k8s from "@pulumi/kubernetes";

const CONTROLPLANE_IP = "192.168.2.131";
const WORKER_IPS = ["192.168.2.138"];
const CLUSTERNAME = "homelab-cluster";

const CONFIG_PATCH = `machine:
    install:
        disk: /dev/sda
        image: factory.talos.dev/installer/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515:v1.10.5
        wipe: false
cluster:
    network:
        cni:
            name: none
    proxy:
        disabled: true
`;

const cfg = new pulumi.Config();

const secrets = new talos.MachineSecrets("this", {});

const controlplaneMachineConfig = secrets.machineSecrets.apply(machineSecrets =>
    talos.getMachineConfiguration({
        clusterName: CLUSTERNAME,
        machineType: "controlplane",
        clusterEndpoint: `https://${CONTROLPLANE_IP}:6443`,
        machineSecrets,
    })
);
const workerMachineConfig = secrets.machineSecrets.apply(machineSecrets =>
    talos.getMachineConfiguration({
        clusterName: CLUSTERNAME,
        machineType: "worker",
        clusterEndpoint: `https://${CONTROLPLANE_IP}:6443`,
        machineSecrets,
    })
);

const talosClientConfig = secrets.clientConfiguration.apply(clientConfiguration =>
    talos.getClientConfiguration({
        clusterName: CLUSTERNAME,
        clientConfiguration,
        nodes: [CONTROLPLANE_IP],
        endpoints: [CONTROLPLANE_IP],
    })
);

const workerApplyConfig = new talos.MachineConfigurationApply("worker", {
        clientConfiguration: talosClientConfig.clientConfiguration,
        machineConfigurationInput: workerMachineConfig.machineConfiguration,
        node: WORKER_IPS[0],
        configPatches: [CONFIG_PATCH],
});
const controlplaneApplyConfig = new talos.MachineConfigurationApply("this", {
        clientConfiguration: talosClientConfig.clientConfiguration,
        machineConfigurationInput: controlplaneMachineConfig.machineConfiguration,
        node: CONTROLPLANE_IP,
        configPatches: [CONFIG_PATCH],
});

const bootstrap = new talos.MachineBootstrap("this", {
    node: CONTROLPLANE_IP,
    clientConfiguration: talosClientConfig.clientConfiguration,
}, { dependsOn: [controlplaneApplyConfig, workerApplyConfig] });

export const kubeconfig = new talos.ClusterKubeconfig("this", {
    node: CONTROLPLANE_IP,
    clientConfiguration: talosClientConfig.clientConfiguration,
}, { dependsOn: [bootstrap] });

// export const healthCheck = talosClientConfig.clientConfiguration.apply(clientConfiguration =>
//     talos.getClusterHealth({
//         endpoints: [CONTROLPLANE_IP],
//         controlPlaneNodes: [CONTROLPLANE_IP],
//         workerNodes: WORKER_IPS,
//         clientConfiguration,
//     })
// );

const provider = new k8s.Provider("talos", {
    kubeconfig: kubeconfig.kubeconfigRaw,
});

const cilium = new k8s.helm.v3.Chart("cilium", {
    chart: "cilium",
    version: "1.15.6",
    namespace: "kube-system",
    fetchOpts: {
        repo: "https://helm.cilium.io/",
    },
    values: {
        ipam: {
            mode: "kubernetes",
        },
        kubeProxyReplacement: false,
        securityContext: {
            capabilities: {
                ciliumAgent: [
                    "CHOWN",
                    "KILL",
                    "NET_ADMIN",
                    "NET_RAW",
                    "IPC_LOCK",
                    "SYS_ADMIN",
                    "SYS_RESOURCE",
                    "DAC_OVERRIDE",
                    "FOWNER",
                    "SETGID",
                    "SETUID",
                ],
                cleanCiliumState: [
                    "NET_ADMIN",
                    "SYS_ADMIN",
                    "SYS_RESOURCE",
                ],
            },
        },
        cgroup: {
            autoMount: {
                enabled: false,
            },
            hostRoot: "/sys/fs/cgroup",
        },
        k8sServiceHost: "localhost",
        k8sServicePort: 7445,
    }
}, { dependsOn: [ bootstrap ], provider });

const fluxProvider = new flux.Provider("fluxProvider", {
    kubernetes: kubeconfig.clientConfiguration,
    git: {
        url: pulumi.interpolate`https://github.com/navaneeth-dev/fluxcd-homelab.git`,
        http: {
            username: "git",
            password: cfg.requireSecret("githubToken"),
        },
    },
});

const fluxBootstrap = new flux.BootstrapGit("this", {
    path: "k8s/clusters/staging",
}, {
    dependsOn: [cilium],
});

export const kubeconfigRaw = kubeconfig.kubeconfigRaw;
export const talosConfig = talosClientConfig.talosConfig;

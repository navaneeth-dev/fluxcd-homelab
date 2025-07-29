import * as talos from "@pulumi/talos";
import * as pulumi from "@pulumi/pulumi";

const CONTROLPLANE_IP = "192.168.2.131";
const WORKER_IPS = ["192.168.2.138"];
const CLUSTERNAME = "homelab-cluster";

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
        clientConfiguration: clientConfiguration,
        nodes: [CONTROLPLANE_IP, ...WORKER_IPS],
    }).then(r => r.clientConfiguration)
);

const workerApplyConfig = pulumi.all([talosClientConfig, workerMachineConfig]).apply(([clientConfiguration, machineConfiguration]) =>
    new talos.MachineConfigurationApply("worker", {
        clientConfiguration: clientConfiguration,
        machineConfigurationInput: machineConfiguration.machineConfiguration,
        node: WORKER_IPS[0],
        configPatches: [`machine:
    install:
        disk: /dev/sda
        image: factory.talos.dev/installer/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515:v1.10.5
        wipe: false
`
        ],
    })
);
const applyConfig = pulumi.all([talosClientConfig, controlplaneMachineConfig]).apply(([clientConfiguration, machineConfiguration]) =>
    new talos.MachineConfigurationApply("this", {
        clientConfiguration: clientConfiguration,
        machineConfigurationInput: machineConfiguration.machineConfiguration,
        node: CONTROLPLANE_IP,
        configPatches: [`machine:
    install:
        disk: /dev/sda
        image: factory.talos.dev/installer/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515:v1.10.5
        wipe: false
`
        ],
    })
);

const bootstrap = new talos.MachineBootstrap("this", {
    node: CONTROLPLANE_IP,
    clientConfiguration: talosClientConfig,
}, { dependsOn: [applyConfig, workerApplyConfig] });

const kubeconfig = new talos.ClusterKubeconfig("this", {
    node: CONTROLPLANE_IP,
    clientConfiguration: talosClientConfig,
}, { dependsOn: [bootstrap] });

export const kubeconfigRaw = kubeconfig.kubeconfigRaw;

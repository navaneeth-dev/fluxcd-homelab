import * as talos from "@pulumi/talos";
import * as k8s from "@pulumi/kubernetes";

const CONTROLPLANE_IP = "192.168.2.131";

const secrets = new talos.MachineSecrets("this", {});

// Generate machine configuration for controlplane
const machineConfig = talos.getMachineConfiguration({
    clusterName: "homelab-cluster",
    machineType: "controlplane",
    clusterEndpoint: "https://cluster.local:6443",
    machineSecrets: secrets.machineSecrets,
});

// Get Talos client configuration
const clientConfig = talos.getClientConfiguration({
    clusterName: "rizexor-cluster",
    clientConfiguration: secrets.clientConfiguration,
    nodes: [CONTROLPLANE_IP],
});

// Apply the configuration to the node
const configApply = new talos.MachineConfigurationApply("this", {
    clientConfiguration: secrets.clientConfiguration,
    machineConfigurationInput: machineConfig.then(m => m.machineConfiguration),
    node: CONTROLPLANE_IP,
    // configPatches: [
    //     JSON.stringify({
    //         machine: {
    //             install: {
    //                 disk: "/dev/sdd",
    //             },
    //         },
    //     }),
    // ],
});

// Bootstrap the cluster
const bootstrap = new talos.MachineBootstrap("this", {
    node: CONTROLPLANE_IP,
    clientConfiguration: secrets.clientConfiguration,
}, { dependsOn: [configApply] });

// const appLabels = { app: "nginx" };
// const deployment = new k8s.apps.v1.Deployment("nginx", {
//     spec: {
//         selector: { matchLabels: appLabels },
//         replicas: 1,
//         template: {
//             metadata: { labels: appLabels },
//             spec: { containers: [{ name: "nginx", image: "nginx" }] }
//         }
//     }
// });
// export const name = deployment.metadata.name;

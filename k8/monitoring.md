## Nvidia Grafana monitoring
Label the GPU nodes.
'''console
kubectl label nodes <gpu-node-name> hardware-type=NVIDIAGPU
'''
Ensure that the label has been applied.
´´´console
kubectl get nodes --show-labels
´´´

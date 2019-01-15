## Nvidia Grafana monitoring

Label the GPU nodes.
```console
kubectl label nodes <gpu-node-name> hardware-type=NVIDIAGPU
```


Ensure that the label has been applied.
```console
kubectl get nodes --show-labels
```

Check the status of the pods. It may take a few minutes for the components to initalize and start running.
```console
kubectl get pods -n monitoring
```

Forward the port for Grafana.
```console
kubectl -n monitoring port-forward $(kubectl get pods -n monitoring -lapp=kube-prometheus-grafana -ojsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}') 3000 &
```

Open a browser window and type http://localhost:3000

To view a saple pod GPU metrics in Grafana, create a docker secret to authenticate against nvcr.io and run the resnet sample provided in the examples directory.
```console
kubectl create secret docker-registry nvcr.dgxkey --docker-server=nvcr.io --docker-username='$oauthtoken' --docker-password=<NGC API Key> --docker-email=<email>
kubectl create -f /etc/kubeadm/examples/resnet.yml
```

# Dashbord,Kubernetes cludster web-based UI
https://github.com/kubernetes/dashboard/wiki/Creating-sample-user
Deploy the dashbord
```console
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml

kubectl get pods -n kube-system
```
To access Dashboard from your local workstation you must create a secure channel to your Kubernetes cluster. Start the k8 proxy
```console
kubectl proxy
```

LogIn token
```console
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
```

Now access Dashboard at:
http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/















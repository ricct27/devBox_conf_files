( https://kubernetes.io/docs/reference/kubectl/cheatsheet/ )
```console

```
## Create, Expose and Scale
1. Create a deployment
```console
kubectl run http --image=katacoda/docker-http-server:latest --replicas=1
kubectl get deployments
kubectl describe deployment http
```
2. Expose externaly with IP:port : should point in one of the nodes
```console
kubectl expose deployment http --external-ip="172.17.0.15" --port=8000 --target-port=80
kubectl get services
curl http://172.17.0.15:8000
```
  2.1 Expose directly
```console
  kubectl run httpexposed --image=katacoda/docker-http-server:latest --replicas=1 --port=80 --hostport=8001
```

3. Scale
```console
kubectl scale --replicas=3 deployment http
kubectl get pods
kubeclt describe svc http
curl http://172.17.0.15:8000   # check the differen IDs for the load balancing
```

## Deploy, Scale using YAML
1. Create a deployment
```console
kubectl create -f deployment.yaml
kubectl get doployment
kubectl describe deployment <dep-name>
```
2. Create a Service (svc)
```console
kubectl create -f service.yaml
kubectl get svc
kubeclt describe svc webapp1-svc
curl node:30080
```
3. Scale. Modify the YAML file based on the requirement
```console
kubectl apply -f deployment.yaml
kubectl get deployment
kubectl get pods
curl host:30080
```







## Launch a single instance:
```console
kubectl run nginx --image=nginx:1.10.0
```
## Expose nginx
```console
kubectl expose deployment nginx --port 80 --type LoadBalancer
```

## Get commands with basic output
```console
kubectl get services                          # List all services in the namespace
kubectl get pods --all-namespaces             # List all pods in all namespaces
kubectl get pods -o wide                      # List all pods in the namespace, with more details
kubectl get deployment my-dep                 # List a particular deployment
kubectl get pods --include-uninitialized      # List all pods in the namespace, including uninitialized ones
kubectl get pods -n kube-system               # List all k8 system pods
```

## Describe commands with verbose output
```console
kubectl describe nodes my-node
kubectl describe pods my-pod
```

## Get all running pods in the namespace
```console
kubectl get pods --field-selector=status.phase=Running
```


## Scaling resources
```console
kubectl scale --replicas=3 rs/foo                                 # Scale a replicaset named 'foo' to 3
kubectl scale --replicas=3 -f foo.yaml                            # Scale a resource specified in "foo.yaml" to 3
kubectl scale --current-replicas=2 --replicas=3 deployment/mysql  # If the deployment named mysql's current size is 2, scale mysql to 3
kubectl scale --replicas=5 rc/foo rc/bar rc/baz                   # Scale multiple replication controllers
```

## Deleting Resources
```console
kubectl delete -f ./pod.json                                              # Delete a pod using the type and name specified in pod.json
kubectl delete pod,service baz foo                                        # Delete pods and services with same names "baz" and "foo"
kubectl delete pods,services -l name=myLabel                              # Delete pods and services with label name=myLabel
kubectl delete pods,services -l name=myLabel --include-uninitialized      # Delete pods and services, including uninitialized ones, with label name=myLabel
kubectl -n my-ns delete po,svc --all 
```

## Interacting with running Pods
```console
kubectl logs my-pod                                 # dump pod logs (stdout)
kubectl logs my-pod --previous                      # dump pod logs (stdout) for a previous instantiation of a container
kubectl logs my-pod -c my-container                 # dump pod container logs (stdout, multi-container case)
kubectl logs my-pod -c my-container --previous      # dump pod container logs (stdout, multi-container case) for a previous instantiation of a container
kubectl logs -f my-pod                              # stream pod logs (stdout)
kubectl logs -f my-pod -c my-container              # stream pod container logs (stdout, multi-container case)
kubectl run -i --tty busybox --image=busybox -- sh  # Run pod as interactive shell
kubectl attach my-pod -i                            # Attach to Running Container
kubectl port-forward my-pod 5000:6000               # Listen on port 5000 on the local machine and forward to port 6000 on my-pod
kubectl exec my-pod -- ls /                         # Run command in existing pod (1 container case)
kubectl exec my-pod -c my-container -- ls /         # Run command in existing pod (multi-container case)
kubectl top pod POD_NAME --containers               # Show metrics for a given pod and its containers
```

## Interacting with Nodes and Cluster
```console
kubectl cordon my-node                                                # Mark my-node as unschedulable
kubectl drain my-node                                                 # Drain my-node in preparation for maintenance
kubectl uncordon my-node                                              # Mark my-node as schedulable
kubectl top node my-node                                              # Show metrics for a given node
kubectl cluster-info                                                  # Display addresses of the master and services
kubectl cluster-info dump                                             # Dump current cluster state to stdout
kubectl cluster-info dump --output-directory=/path/to/cluster-state   # Dump current cluster state to /path/to/cluster-state
```
























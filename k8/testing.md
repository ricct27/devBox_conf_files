## Create a Pod
```console
kubectl create -f pods/monolith.yaml
```

## Examine a Pod
```console
kubectl get pods

kubectl describe pods <pod_name>
```
## set up port-forwarding
```console
kubectl port-forward monolith 10080:80
```

## in a new shell . we comunicate with containers throught the localhost inside the pod.
```console
curl http://127.0.0.1:10080

curl http://127.0.0.1:10080/secure
```

## View logs
```console
kubectl logs <pod_name>

kubectl logs -f <p-name>  # real time logs
```
## Running commands
```console
kubectl exec monolith --stdin --tty -c monolith /bin/sh   # interactive shell in this case
```
MHC Application checking and Health Checks. Checks if the app inside the container works correctly.
Kubelet is responsible if the pod is Healthy, restart and checking loop

## How is the readiness probe performed? 
https://classroom.udacity.com/courses/ud615/lessons/7824962412/concepts/81991020710923
Check the file healthy-<pod-name>.yalm  

## How often is the readiness checked:
```console
kubectl describe pods healthy-<pod-name> | grep Readiness
```

## Liveness
```console
kubectl describe pods healthy-<pod-name> | grep Liveness
```

## Secrets and ConfigMaps
```console












## Services
https://classroom.udacity.com/courses/ud615/lessons/7824962412/concepts/81883227220923

###### Servicess are ersistent Endpoints for Pods:
 - Use labels to select pods
 - Internal or External IPs
 
Services are persistent Endpoints for Pods. Instead of relying on a Pod Ip andress which can change during the time, 
kubernetes provides Services as stable end-points for the pods. The pods that the Service exposes are based on a 
set of labels. There are three different type of services and each of them offer a different level of access to the 
set of pods.
 - Cluster Ip: internal only
 - Node port: offers each node an external IP tha's accessible
 - Load balancer: adds a load balancer from the cloud provider that fource trafic from the service to the nodes
   within it.

Exposing a Pod externaly using a service.
Get the Service details
```console
kubectl get svc <service-name>
```

Get pods based on the labels
```console
kubectl get pods -l "app=<pod-label>,app=<second-pod-label>"
```

Add different labels to a Pod
```console
kubectl label pods <pod-name> "<pod-label>"
```

## Deployments 
Deployments are a declarative way to say what goes where

## Config File


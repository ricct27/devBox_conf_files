# Namespaces
Kubernetes supports multiple virtual clusters backed by the same physical cluster. These virtual clusters are called namespaces.
Namespaces are intended for use in environments with many users spread across multiple teams, or projects. For clusters with a few to tens of users, you should not need to create or think about namespaces at all. Start using namespaces when you need the features they provide. 
Namespaces are a way to divide cluster resources between multiple users (via resource quota).

It is not necessary to use multiple namespaces just to separate slightly different resources, such as different versions of the same software: use labels to distinguish resources within the same namespace.

# Pods
 A pod is a collection of containers that makes up a particular application, for example Redis.

# Services
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

# Deployments 
Deployments are a declarative way to say what goes where
The *run* command creates a deployment based on the parameters specified, such as the image or replicas. Kubectl *run* is similar to docker *run* but at a cluster level.
The format of the command is 
```console
kubectl run <name of deployment> <properties>
kubectl get deployments
kubeclt describe deployments <dep-name>
```
With the deployment created, we can use kubectl to create a service which exposes the Pods on a particular port.
```console
kubectl expose deployment http --external-ip="172.17.0.36" --port=8000 --target-port=80
curl http://172.17.0.36:8000
```



## Deploing an app 
https://www.katacoda.com/courses/kubernetes/guestbook

The first stage of launching the application is to start the App Master. A Kubernetes service deployment has, at least, two parts:
  - replication controller 
  - service

The replication controller defines how many instances should be running, the Docker Image to use, and a name to identify the service. Additional options can be utilized for configuration and discovery. Use the editor above to view the YAML definition.
If app were to go down, the replication controller would restart it on an active node.


1. Create the Master Replication Controller
 The replication controller defines:
   - how many instances should be running
   - the Docker Image to use
   - a name to identify the service. 

   Additional options can be utilized for configuration and discovery. If the app were to go down, the replication controller would restart it on an active node.

```console
kubectl create -f redis-master-controller.yaml
kubectl get rc
kubectl get pods
```

2. Create the Master Service (Internal Load Balancer)
 A Kubernetes *Service* is a named *load balancer* that proxies traffic to one or more containers. The proxy works even if the containers are on different nodes. Services proxy communicate within the cluster and rarely expose ports to an outside interface.
The recommended approach is to have a LoadBalancer service to handle external communications.


```console
kubectl create -f redis-master-service.yaml
kubectl get services
kubectl describe services redis-master
```













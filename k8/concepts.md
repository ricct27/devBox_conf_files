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
In this example we'll be running Redis App where the Slaves  will have replicated data from the master. More details of Redis replication can be found a https://redis.io/topics/replication
The PHP code uses HTTP and JSON to communicate with Redis. When setting a value requests go to Redis-Master while read data comes from the redis-slave nodes.

The first stage of launching the application is to start the App Master. A Kubernetes service deployment has, at least, two parts:
  - replication controller 
  - service (load balancer)

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

3. Start a Redis Slave controller
In this case, we'll be launching two instances of the pod using the image kubernetes/redis-slave:v2. It will link to redis-master via DNS.
In this example we need to determine how the service discovers the other pods. The YAML represents the GET_HOSTS_FROM property as DNS.

```console
kubectl create -f redis-slave-controller.yaml
kubectl get rc
```
4. Slave Service (Load balancer)
We need to make our staves accessible to incoming requests. This is done by creating a service which knows how to communicate with the other slaves. 
In our case, we have two replicated pods and the service will also provide load balancing between the two nodes.
```console
kubectl create -f redis-slave-service.yaml
kubectl get svc
```
5. Deploying the FrontEnd app
 The pattern of deploying a web application is the same as the pods we've deployed before.
The YAML defines a service called frontend that uses the image _gcr.io/googlesamples/gb-frontend:v3. The replication controller will ensure that three pods will always exist.

```console
kubectl create -f frontend-controller.yaml
kubectl get rc
```

The PHP code uses HTTP and JSON to communicate with Redis. When setting a value requests go to redis-master while read data comes from the redis-slave nodes.

6. FronteEnd Service
To make the frontend accessible we need to start a service to configure the proxy.
Start Proxy:
The YAML defines the service as a NodePort. NodePort allows you to set well-known ports that are shared across your entire cluster. This is like -p 80:80 in Docker.
In this case, we define our web app is running on port 80 but we'll expose the service on 30080.

```console
kubectl create -f frontend-service.yaml
kubectl get svc
```
7. Access GuestBook Frontend app
With all controllers and services defined Kubernetes will start launching them as Pods. A pod can have different states depending on what's happening. For example, if the Docker Image is still being downloaded then the Pod will have a pending state as it's not able to launch. Once ready the status will change to running.
```console
kubectl get pods
```

If we didn't assign a port to NodePort then k8 will assign an available port rundomly. We can find the assigned NodePort using 

```console
kubectl describe service frontend | grep NodePort
```

# Networking
Different approcies to how to access the Pods on the K8

## Cluster IP
When creating a service, an internal IP is associated with the service in the way that other components can use to access the pods, also used for load balanciang. 

```console
kubectl apply -f clusterip.yaml
kubectl describe svc/webapp1-clusterip-svc
curl $cluster_IP:80
curl 10.110.165.179:80
```

**Targer Port**
**Target ports** allows us to separate the port the service is available on from the port the application is listening on. **TargetPort** is the port in which the application is configured to listen on. 
**Port** is how the application will be accessed from the *outside*.
The combination between TargetPort and ClusterIp makes a Pod available inside the cluster on a definite port.

```console
  ports:
  - port: 8080
    targetport: 80
    
curl $cluster_IP:8080
curl 10.110.165.179:8080
```

## NodePort
While **TargetPort** and **ClusterIP** make it available to inside the cluster, the **NodePort** exposes the service on each **Node**’s IP via the defined static port. 

```console
kubectl apply -f nodeport.yaml
kubectl describe svc/webapp1-nodeport-svc
curl $cluster_IP:80
curl $NodeIp:80
```

## External IPs
Another approach to make a service available outside the cluster is via External IP address.

```console
  ports:
  - port: 80
  externalIPs:
  - 192.168.1.80
 ```
 
## Load Balancer









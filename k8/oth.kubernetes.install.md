## Vorausssetzungen

Siehe https://kubernetes.io/docs/setup/independent/install-kubeadm/.

It has to be on every node
- docker (community edition, version 17.03)
- kubectl
- kubeadm
- kubelet

be installed!

Install specific version:
docker:
sudo apt-get purge docker-ce-cli docker-ce
sudo apt-get install docker-ce=$(apt-cache madison docker-ce | grep 17.03 | head -1 | awk '{print $3}')
sudo apt-get install kubectl=$(apt-cache madison kubelet | grep 1.9 | head -1 | awk '{print $3}')
sudo apt-get install kubelet=$(apt-cache madison kubelet | grep 1.9 | head -1 | awk '{print $3}')
sudo apt-get install kubeadm=$(apt-cache madison kubelet | grep 1.9 | head -1 | awk '{print $3}')

To prevent future (auto) updates:
sudo apt-mark hold kubelet kubeadm kubectl docker-ce

In addition, the following IP network configuration must be available:

	 Gateway (Raspberry Pi) |   192.168.1.1
	------------------------|-----------------
	     k8scl-master	|   192.168.1.20
	     k8scl-worker1	|   192.168.1.21
	     k8scl-worker2	|   192.168.1.22
	     k8scl-worker3	|   192.168.1.23

This is usually set by default.
Verifiable on every node with:
	sudo cat /etc/NetworkManager/system-connections/<wired connection o.ä.>

The important part is:

[ipv4]
address1=192.168.1.21/24,192.168.1.1 # für worker1
dns=8.8.8.8;
dns-search=
method=manual

## 1. Delete old things

## Siehe https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/#tear-down

## On the master:
	kubectl drain k8scl-worker1 --delete-local-data --force --ignore-daemonsets
	kubectl delete node k8scl-worker1
        kubectl drain k8scl-worker2 --delete-local-data --force --ignore-daemonsets
        kubectl delete node k8scl-worker2
        kubectl drain k8scl-worker3 --delete-local-data --force --ignore-daemonsets
        kubectl delete node k8scl-worker3

## On worker1, 2 and 3:
sudo kubeadm reset

## After that on the master:
sudo kubeadm reset
sudo rm -r $HOME/.kube/

## 2. Neu installieren

## Siehe https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/#initializing-your-master
## und https://blog.alexellis.io/kubernetes-in-10-minutes/

Run the following command on the master (for cube version 1.9):
	sudo kubeadm init/
	 	--pod-network-cidr=10.244.0.0/16/
		--apiserver-advertise-address=192.168.1.20/
		--kubernetes-version stable-1.9

	Then go through the output of the command and follow the instructions.
	It should look like this:

...
To start using your cluster, you need to run (as a regular user):

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
...


## 3. Pod-Netzwerk

## Siehe https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/#pod-network

## This point classically makes the most difficulties. At first, we have had some pretty good experiences with flannel, but not since version ## 1.9. We then tried Romana.

## Please refer https://github.com/romana/romana/tree/master/containerize#using-kubeadm

## Back on the master:
	kubectl apply -f https://raw.githubusercontent.com/romana/romana/master/containerize/specs/romana-kubeadm.yml

## In case of unexpected behavior or in general, it is always good to delete the old configurations under /etc/cni/net.d/.

## 4. Add Nodes

## Please refer https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/#44-joining-your-nodes

## Use SSH to go to workers 1, 2 and 3 and enter the following command:
	sudo kubeadm join/
	 	--token <token> <master-ip>:<master-port>/
	  --discovery-token-ca-cert-hash sha256:<hash>

The current token etc. is different each time and can be found in the command output of kubeadm init on the master. Simply copy it from there and off you go.

## 5. Ersten Pod starten / Dashboard hinzufügen

Siehe https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/

Wenn alles soweit ist (einen guten Überblick bekommt man mit
	kubectl get all --all-namespaces
	kubectl get nodes
) kann der erste Pod (Dashboard) gestartet werden.

Wieder auf dem Master:
	kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
	kubectl edit svc kubernetes-dashboard -n kube-system

Den Typ des Services von "ClusterIP" auf "NodePort" ändern. Dann sollte man den zugewiesenen Port mit
	kubectl get svc kubernetes-dashboard -n kube-system

sehen können. Es sollte irgendwas zwischen 30000 und 32500 sein. Diesen kann man jetzt im Browser aufrufen.

Admin-Rechte fürs Dashboard:
kubectl create clusterrolebinding dashboard-cluster-admin-binding --clusterrole=cluster-admin --user=system:serviceaccount:kube-system:kubernetes-dashboard

Ansonsten erscheint ein oranges Banner über jeder Seite des Dashboards wegen mangelnde Rechte

FROM ubuntu:latest
Maintainer Chad Larkin <clarkin@basspro.com>

# Metadata
LABEL tkg.version="1.2.1" \
	  kubectl.version="1.19.3" \
	  kube-linter.version="0.1.6" \
	  kubens.version="0.9.1" \
	  kubectx.version="0.9.1" \
	  imgpkg.version="0.2.0" \
	  kbld.version="0.24.0" \
	  kapp.version="0.33.0" \
	  ytt.version="0.30.0" \
	  istioctl.version="1.8.2" \
	  clusterctl.version="0.3.13" \
	  description="Ubuntu with tkg and kubernetes cli tools"

# Update container and install tools
RUN apt-get update && \
    apt-get install -y curl openssh-client nano dos2unix apt-transport-https && \
	curl -L https://dl.bintray.com/larkinc/generic/tkg-kctl-tools.tar.gz | tar xvzf -  && \
	chmod +x ./imgpkg && \
	mv ./imgpkg /usr/local/bin/imgpkg && \
	chmod +x ./kapp && \
	mv ./kapp /usr/local/bin/kapp && \
	chmod +x ./kbld && \
	mv ./kbld /usr/local/bin/kbld && \
	chmod +x ./kubectl && \
	mv ./kubectl /usr/local/bin/kubectl && \
	chmod +x ./tkg && \
	mv ./tkg /usr/local/bin/tkg && \
	chmod +x ./ytt && \
	mv ./ytt /usr/local/bin/ytt && \
	curl -L https://github.com/kubernetes-sigs/cluster-api/releases/download/v0.3.13/clusterctl-linux-amd64 -o clusterctl && \
	chmod +x ./clusterctl && \
	mv ./clusterctl /usr/local/bin/clusterctl && \
	curl -L https://github.com/istio/istio/releases/download/1.8.2/istio-1.8.2-linux-amd64.tar.gz | tar xvzf - && \
	ln -s /istio-1.8.2/bin/istioctl /usr/local/bin/istioctl && \
	curl -L https://github.com/stackrox/kube-linter/releases/download/0.1.6/kube-linter-linux.tar.gz | tar xvzf - && \
	chmod +x ./kube-linter && \
	mv ./kube-linter /usr/local/bin/kube-linter && \
	curl -L https://github.com/ahmetb/kubectx/releases/download/v0.9.1/kubectx -o kubectx && \
	chmod +x ./kubectx && \
	mv ./kubectx /usr/local/bin/kubectx && \
	curl -L https://github.com/ahmetb/kubectx/releases/download/v0.9.1/kubens -o kubens && \
	chmod +x ./kubens && \
	mv ./kubens /usr/local/bin/kubens && \
	curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.10.0/kind-linux-amd64 && \
	chmod +x ./kind && \
	mv ./kind /usr/local/bin/kind && \
	curl https://baltocdn.com/helm/signing.asc | apt-key add - && \
	echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list && \
	apt-get update && \
	apt-get install helm && \
	apt-get clean
	
# Entrypoint
ENTRYPOINT /bin/bash
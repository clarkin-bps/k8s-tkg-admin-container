FROM ubuntu:latest
Maintainer Chad Larkin <clarkin@basspro.com>

# Metadata
LABEL tanzu.version="1.3.0" \
	  kubectl.version="1.20.5" \
	  kube-linter.version="0.1.6" \
	  kubens.version="0.9.1" \
	  kubectx.version="0.9.1" \
	  imgpkg.version="0.2.0" \
	  kbld.version="0.28.0" \
	  kapp.version="0.36.0" \
	  ytt.version="0.31.0" \
	  istioctl.version="1.8.2" \
	  clusterctl.version="0.3.13" \
	  valero.version="1.5.4" \
	  crashd.version="0.3.2" \
	  vendir.version="0.18.0" \
	  description="Ubuntu with tanzu and kubernetes cli tools"
	  
# Add tanzu tools 
ADD scripts scripts

# Update container and install tools
RUN apt-get update && \
	apt-get install -y curl openssh-client nano dos2unix apt-transport-https gnupg2 && \
	chmod +x ./scripts/tanzu_tools_download.sh && \
	bash ./scripts/tanzu_tools_download.sh && \
	tar xvzf ./tanzu_tools.tar.gz && \
	rm ./tanzu_tools.tar.gz && \
	chmod +x ./kubectl && \
	install ./kubectl /usr/local/bin/kubectl && \
	chmod +x ./velero && \
	install ./velero /usr/local/bin/velero && \
	chmod +x ./cli/imgpkg && \
	install ./cli/imgpkg /usr/local/bin/imgpkg && \
	chmod +x ./cli/kapp && \
	install ./cli/kapp /usr/local/bin/kapp && \
	chmod +x ./cli/kbld && \
	install ./cli/kbld /usr/local/bin/kbld && \
	chmod +x ./cli/ytt && \
	install ./cli/ytt /usr/local/bin/ytt && \
	install ./cli/core/v1.3.0/tanzu-core-linux_amd64 /usr/local/bin/tanzu && \
	tanzu plugin clean && \
	tanzu plugin install --local ./cli all && \
	tanzu plugin list && \
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
	curl -Lo ./kp https://github.com/vmware-tanzu/kpack-cli/releases/download/v0.2.0/kp-linux-0.2.0 && \
	chmod +x ./kp && \
	mv ./kp /usr/local/bin/kp && \
	curl https://baltocdn.com/helm/signing.asc | apt-key add - && \
	echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list && \
	apt-get update && \
	apt-get install helm && \
	apt-get clean
	
# Entrypoint
ENTRYPOINT /bin/bash
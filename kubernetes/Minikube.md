#### 公司应用K8s部署了一套容器云平台，为熟悉k8s及gitlab一整套系统，本地部署minikube，此为记录过程，以及过程中碰到的坑。
----
### Minikube版本（0.25.0）
其中最新版本为0.27.0，尝试后总会在 minikube start 后无限挂起，之后失败，遂果断切换到稳定的老版本0.25.2，这是在MacOS下的坑，其他系统可自行斟酌。     

__地址__：[Minikube下载集中营](https://github.com/kubernetes/minikube/releases)    
__Minikube官方安装教程__：[Minikube训练营](https://kubernetes.io/docs/tasks/tools/install-minikube/)     
__Minikube Github__：[Minikube军营](https://github.com/kubernetes/minikube/blob/v0.25.2/README.md)
*******
# 安装
### kubectl安装
`brew install kubectl`
### Minikube获取
#### OSX
`curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.25.2/minikube-darwin-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/`
#### Linux
`curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.25.2/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/`
### 启动集群

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
`# 以下步骤看网络速度了，过程中会下载两个文件`     
`Starting local Kubernetes v1.9.4 cluster...`     
`Starting VM...     `    
`Downloading Minikube ISO     `     
` 142.22 MB / 142.22 MB [============================================] 100.00% 0s     `    
`Getting VM IP address...     `    
`Moving files into cluster...    `      
`Downloading localkube binary     `     
` 163.02 MB / 163.02 MB [============================================] 100.00% 0s    `      
` 0 B / 65 B [----------------------------------------------------------]   0.00%      `     
` 65 B / 65 B [======================================================] 100.00% 0sSetting up certs...      `     
`Connecting to cluster...     `     
`Setting up kubeconfig...      `        
`Starting cluster components...      `       
`Kubectl is now configured to use the cluster.    `        
`Loading cached images from config file.     `     

启动后可在VirtualBox中看到minikube的虚拟机已经运行。     
### 配置代理
`# 停止集群     `     
`minikube stop     `                        
`Stopping local Kubernetes cluster...     `     
`Machine stopped.    `      

查看自己宿主机代理运行地址和端口，本机宿主机运行在1080端口，即 *http://127.0.0.1:1080* 。    
- 代理监听需要在所有网卡上，即坚挺地址*0.0.0.0*，而不是*127.0.0.1*或*localhost*。    
- 虚拟机地址一般为*192.168.99.100*，也可用 minikube 命令查看，`minikube ip` 。    
- 集群自身的*IP*需要被设置为忽略代理，否则宿主机无法连接到集群。    
- 集群的代理需要在启动时通过 `--docker-env` 特别指定，宿主机和集群为隔离状态，即宿主机环境变量无法共享到集群，即虚拟机。    

`# 添加一下两行进 .bashrc 或 .zshrc`    
`export http_proxy='http://127.0.0.1:1080'`     
`export https_proxy='https://127.0.0.1:1080'`     
`退出后编译 source ~/.bashrc 或 ~/.zshrc`     

`# 重新启动集群`     
`export no_proxy=192.168.99.100`     
`minikube start --docker-env HTTP_PROXY=$http_proxy --docker-env HTTPS_PROXY=$https_proxy`      

`# 启动后忽略集群节点的代理`     
`export no_proxy=$no_proxy,$(minikube ip)`     
`export NO_PROXY=$no_proxy,$(minikube ip)`     

忽略代理主要是针对宿主在访问集群时绕过代理，否则像这类私有 IP 地址段代理是永远不可能访问到的，然后就会导致宿主一直无法获取到集群的状态。

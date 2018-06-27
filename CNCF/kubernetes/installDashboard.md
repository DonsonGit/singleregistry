# 部署kubernetes-dashboard
__镜像__:kubernetes-dashboard-amd64:v1.8.3     
__kubernetes版本__：v1.9.4     
__kubernetes-dashboard__：[官方文件目录](https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/dashboard)     
******
## 部署文件
#### 部署文件为以下三个：     
```
$ ls *.yaml
dashboard-controller.yaml dashboard-service.yaml dashboard-rbac.yaml
```
#### 由于`kube-apiserver`启用了`RBAC`授权，而官方源码目录的`dashboard-controller.yaml`没有定义授权的ServiceAccount，所以后续访问API server的API的时候会被拒绝，Web中提示：     
```
Forbidden (403)
User "system.serviceaccount:kube-system:default" cannot list jobs.batch in the
namespace "default". (get jobs.batch)
```
#### 增加了一个`dashboard-rbac.yaml`文件定义一个名为dashboard的ServiceAccount，然后将它和Cluster
Role view绑定，如下所示：     
```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: dashboard
  namespace: kube-system
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: dashboard
subjects:
  - kind: ServiceAccount
    name: dashboard
    namespace: kube-system
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
```
#### 然后使用`kubectl apply -f dashboard-rbac.yaml`创建     
## 配置dashboard-service
#### 在dashboard-service中增加NodePort，以此来提供外界可以通过地址NodeIP:NodePort来访问dashboard。     
```
apiVersion: v1
kind: Service
metadata:
  name: kubernetes-dashboard
  namespace: kube-system
  labels:
    k8s-app: kubernetes-dashboard
    kubernetes.io/cluster-service: "true"
    addonmanager.kubernetes.io/mode: Reconcile
spec:
  type: NodePort 
  selector:
    k8s-app: kubernetes-dashboard
  ports:
  - port: 80
    targetPort: 9090
```
#### 更换dashboard-controller中的镜像为所需要的镜像本地或私有镜像仓库，官方镜像天朝无法拿到，需要科学上网，也可以通过某些可科学上网的设备下载镜像，推送到私有仓库以提供使用。     
`image: gcr.io/google_containers/kubernetes-dashboard-amd64:v1.6.0`     
#### 指定执行所定义的文件     
`kubectl create -f .`     
#### 检查执行结果     
##### 查看分配的NodePort   
`kubectl get services kubernetes-dashboard -n kube-system`     
##### 检查Controller
```
kubectl get deployment kubernetes-dashboard -n kube-system
kubectl get pods -n kube-system | grep dashboard
```
## 访问dashboard     
### 有三种方式
- kubernetes-dashboard服务暴露了NodePort，可以使用`http://NodeIP:NodePort`地址访问dashboard。
- 通过API server 访问 dashboard （https 6443端口和http 8080端口）。
- 通过kubectl proxy 访问 dashboard。
##### 通过kubectl proxy访问dashboard  
启动代理     
```
kubectl proxy --address='172.20.0.113' --port=8086 --accept-hosts='^*$'
Starting to serve on 172.20.0.113:8086
# 默认8080端口,127.0.0.1
kubectl proxy
# 默认IP：127.0.0.1
kubectl proxy --port=8086 --accept-hosts='^*$'
Starting to serve on 127.0.0.1:8086
```
浏览器访问URL：<http://172.20.0.113:8086/ui> 自动跳转到 <http://172.20.0.113:8086/api/v1/proxy/namespaces/kube-system/services/kubernetes-dashboard/#/workload?namespace=default>。     
##### 通过API server访问dashboard   
获取集群服务地址列表     
```
kubectl cluster-info
```
浏览器访问 <https://172.20.0.113:6443/api/v1/proxy/namespaces/kube-system/services/kubernetes-dashboard> 浏览器会提示导入证书到计算机中，需要提前手动导入，填坑贴 [通过kube-apiserver访问dashboard，提示User"system:anonymous"cannot proxy services in the namespace "kube-system".](https://github.com/opsnull/follow-me-install-kubernetes-cluster/issues/5)。     
##### 导入证书
将生成的admin.pem证书转换格式     
`openssl pkcs12 -export in admin.pem -out admin.p12 -inkey admin-key.pem`     
将生成的admin.p12证书导入电脑，记住密码。     
如果不想使用**https**，可以直接访问insecure port 8080端口：     
<http://172.20.0.113:8080/api/v1/proxy/namespaces/kube-system/services/kubernetes-dashboard>     
显示dashboard的Pod、Node的CPU、内存等metric图形的插件**Heapster**     


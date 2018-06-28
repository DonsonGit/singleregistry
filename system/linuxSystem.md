# 各个容器操作系统
推荐CoreOS

****
## CoreOS
CoreOS是一个基于Linux内核的轻量级操作系统，它的目标既不是桌面系统，也不是传统的服务器领域。CoreOS的设计目的是为了高效地管理基础设施资源，当然需要借助容器的概念。CoreOS大概是在2013年8月发布了第一个apha版本，然后在2014年7月正式发布了稳定版本。相关的资料比较多，初创公司，算是目前市场上比较成熟的容器操作系统。

## Project Atomic
2014年4月，Red Hat发布了Atomic项目。Atomic是一个用于运行容器的操作系统。Atomic项目并不是为了构建另一个操作系统：Red Hat已经有了RHEL、 Fedora 以及现在的CentOS，再鼓捣第四个操作系统出来并没有什么意义。所以，Red Hat并没有这么做，目前的Atomic是一个基于Fedora的原型系统，而另一个采用CentOS的版本也计划即将发布，目前它还不是一个可用于生产环境的产品。2015年3月底，红帽宣布推出红帽企业Linux 7原子主机（Atomic Host），这也可以看出红帽的决心。

## Snappy
Snappy Ubuntu Core 是Canonical推出的一个小型服务器操作系统，它使用与现有Ubuntu相同的库，同时使用更简便的机制（即容器）供用户安装应用。此外，Ubuntu Core 使用的这种容器机制也兼容 Docker。Snappy是在2014年12月发布的，相关的资料非常少。

## RancherOS
RancherOS是Rancher Labs的一个开源项目，旨在提供一种在生产环境中大规模运行Docker的最小最简单的方式。它只包含运行Docker必须的软件，其二进制下载包只有大约20MB。RancherOS是2015年2月发布的，为了抵制CoreOS，所以目前Docker目前比较亲睐RancherOS。

## Nano Server
微软推出的针对云环境高度优化的容器操作系统，刚刚发布，不过官方表示将会在几周内发布测试版本。Nano Server是一个Windows Server的最小化footprint安装包，针对云和容器做了高度优化。Nano Server只提供你需要的组件 - 没有任何多余的组件，这使得服务器镜像更小，部署更快，网络带宽耗费更小，同时启动更迅速也更为安全。


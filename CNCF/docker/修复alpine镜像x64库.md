# 修复docker alpine镜像x64库

mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

## Linux手动安装Golang
### 下载Go文件
```
# 64
wget https://storage.googleapis.com/golang/go1.10.3.linux-amd64.tar.gz
# 32
wget https://storage.googleapis.com/golang/go1.10.3.linux-386.tar.gz
```

### 安装
```
tar -zxf go1.10.3.linux-amd64.tar.gz -C /usr/local
```
### 配置环境变量
```
export PATH=$PATH:/usr/local/go/bin

export GOPATH=/goWorkSpace
# linux下不用设置GOROOT
export GOROOT=/usr/local/go
```

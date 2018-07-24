# 修复docker alpine镜像x64库

mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

## alpine镜像安装工具包，make等命令
```
apk add --update alpine-sdk
fetch http://dl-cdn.alpinelinux.org/alpine/v3.8/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.8/community/x86_64/APKINDEX.tar.gz
(1/39) Installing fakeroot (1.22-r0)
(2/39) Installing sudo (1.8.23-r2)
(3/39) Installing libcap (2.25-r1)
(4/39) Installing pax-utils (1.2.3-r0)
(5/39) Installing libressl (2.7.4-r0)
(6/39) Installing libattr (2.4.47-r7)
(7/39) Installing attr (2.4.47-r7)
(8/39) Installing tar (1.30-r0)
(9/39) Installing pkgconf (1.5.1-r0)
(10/39) Installing patch (2.7.6-r2)
(11/39) Installing libgcc (6.4.0-r8)
(12/39) Installing libstdc++ (6.4.0-r8)
(13/39) Installing lzip (1.20-r0)
(14/39) Installing ca-certificates (20171114-r3)
(15/39) Installing nghttp2-libs (1.32.0-r0)
(16/39) Installing libssh2 (1.8.0-r3)
(17/39) Installing libcurl (7.61.0-r0)
(18/39) Installing curl (7.61.0-r0)
(19/39) Installing abuild (3.2.0-r0)
Executing abuild-3.2.0-r0.pre-install
(20/39) Installing binutils (2.30-r5)
(21/39) Installing libmagic (5.32-r0)
(22/39) Installing file (5.32-r0)
(23/39) Installing gmp (6.1.2-r1)
(24/39) Installing isl (0.18-r0)
(25/39) Installing libgomp (6.4.0-r8)
(26/39) Installing libatomic (6.4.0-r8)
(27/39) Installing mpfr3 (3.1.5-r1)
(28/39) Installing mpc1 (1.0.3-r1)
(29/39) Installing gcc (6.4.0-r8)
(30/39) Installing musl-dev (1.1.19-r10)
(31/39) Installing libc-dev (0.7.1-r0)
(32/39) Installing g++ (6.4.0-r8)
(33/39) Installing make (4.2.1-r2)
(34/39) Installing fortify-headers (0.9-r0)
(35/39) Installing build-base (0.5-r1)
(36/39) Installing expat (2.2.5-r0)
(37/39) Installing pcre2 (10.31-r0)
(38/39) Installing git (2.18.0-r0)
(39/39) Installing alpine-sdk (1.0-r0)
Executing busybox-1.28.4-r0.trigger
Executing ca-certificates-20171114-r3.trigger
```

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

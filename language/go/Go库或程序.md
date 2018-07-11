# Go库或软件
### 文档修订说明
|文档说明|版本   |
|:------:|:-----:|
|初次上传|v1.0   |

## delve
Go调试工具

- dlv项目地址:<https://github.com/derekparker/delve>
- 安装步骤
  1. `go get -v -u github.com/derekparker/delve/cmd/dlv`
  2. `cd $GOPATH/src/github.com/derekparker/delve`
  3. `make install`
- 安装过程
```
➜  delve git:(master) make install
scripts/gencert.sh || (echo "An error occurred when generating and installing a new certificate"; exit 1)
go install -ldflags="-s -X main.Build=9a216211d3461ab031f822c012bc27cab9758da0" github.com/derekparker/delve/cmd/dlv
codesign -s "dlv-cert"  /usr/local/Cellar/go/1.10.3/libexec/bin/dlv
```


# Mac软件
笔记中列出各种使用过的Mac软件记录。

# 文档更新记录
|版本  |描述    |
|:----:|:-------|
|v1.0  |初次上传|
|v1.1  |添加tree|

*****
## libcurl
此为Mac中的命令行工具curl，位置/usr/bin/curl

### 安装步骤
- 在[官网](https://curl.haxx.se/download.html "curl")下载安装包
- 使用terminal进入curl安装包目录
- 设置安装路径：`./configure --prefix=/usr/local/curl`
- 编译：`make`
- 安装：`make install`。需要权限
### 查看curl支持的协议
```
curl-config --protocols
curl --version
```
### libcurl和curl的区别
libcurl是库，curl是命令行工具。

## Homebrew
>Homebrew是Mac OSX上的软件包管理工具，能在Mac中方便的安装软件或者卸载软件，相当于linux下的apt-get、yum神器；Homebre可以在Mac上安装一些OS X没有的UNIX工具，Homebrew将这些工具统统安装到了 /usr/local/Cellar 目录中，并在 /usr/local/bin 中创建符号链接。

**Homebrew官网**:<https://brew.sh/index_zh-cn.html>

### 安装步骤
```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
### Homebrew的使用
- 健康检查：brew doctor
- 安装软件：brew install
- 搜索软件：brew search
- 卸载软件：brew uninstall
- 更新所有软件：brew update
- 安装brew必须软件git：brew install git
- 更新具体软件：brew update xxx
- 显示已安装软件：brew list
- 查看软件信息：brew info/home xxx
- 删除具体软件：brew cleanup xxx
  - brew info 命令行显示信息
  - brew home 通过浏览器显示软件官网信息
- 查看已安装的软件的更新情况：brew outdated
- 显示包依赖：brew deps
- 启动web服务器管理软件<http://localhost:4567>：brew server
### 卸载MacPorts
MacPorts和Homebrew都是Mac OS X上的软件包管理工具,同时它们之间是不兼容的，通过这两个软件包管理工具都可以很方便的管理Mac OS X上软件及应用库的安装。但是据说MacPorts有个缺点就是会重复安装一些系统本省自带的库或软件，而Homebrew则会优先采用系统自带的库或软件不做重复安装，比如安装Python，对于系统已经有的依赖库，Homebrew不做安装。

MacPorts安装过的软件都在/opt/local目录下

```
sudo port -f uninstall installed
sudo port clean all
sudo rm -rf /opt/local/bin/port*
# 删除所有MacPorts软件及配置附带
sudo rm -rf \
/opt/local \
/Applications/DarwinPorts \
/Applications/MacPorts \
/Library/LaunchDaemons/org.macports.* \
/Library/Receipts/DarwinPorts*.pkg \
/Library/Receipts/MacPorts*.pkg \
/Library/StartupItems/DarwinPortsStartup \
/Library/Tcl/darwinports1.0 \
/Library/Tcl/macports1.0 \
~/.macports
```
## tree
目录结构生成软件

### 安装步骤
```
brew install tree
```
### 常用命令
- tree -a 查看当前后某文件夹下所有文件
- tree -d 只显示文件夹
- tree -L n 显示项目的层级，n表示层级数，想显示三层可用tree -l 3
- tree -I pattern 过滤不想显示的文件或者文件夹,如过滤node_module, tree -I
  "node_module"
- tree > tree.md 结果写入到tree.md中
### 示例
```
├── asset
│   └── images
│       ├── dp.png
│       ├── gorp.jpg
│       └── spider.jpg
├── editorlang
│   └── markdown 
│       └── markdown.md
```

## gdb
可执行程序调试工具（**强大**）

### 安装步骤
```
brew search gdb

brew install gdb
```
### 配置证书
打开钥匙串 -> 钥匙串访问 -> 证书助理 -> 创建证书

#### 填写
- 名称：gdb-cert
- 身份类型：自签名根证书
- 证书类型：代码签名
- 勾选让我覆盖这些默认值
#### 继续到最后直到
- 钥匙串：系统
- 创建
#### 在钥匙串 -> 系统中查看刚刚创建的证书
- 双击
- 点击信任
- 全部选择始终信任
- 打开终端，执行命令`sudo codesign -s gdb-cert /usr/local/bin/gdb`



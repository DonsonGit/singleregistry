## 简介
当前Node版本管理工具有两种，Nvm和n。     
### Nvm和n的区别
Nvm有点类似于Python的virtualenv或者Ruby的rvm，每个node版本的模块都会被安装在各自版本的沙箱里，因此切换版本后模块需要重新安装.     
n是一个需要全局安装的npm package。    
```
npm install -g n
```
这意味着，在安装n之前需要自己手动安装一个node，不管是通过Homebrew还是官网的pkg。     
n在安装node的时候，会先将指定版本的node存储下来，然后将其复制到`/usr/local/bin`目录下，很容易理解，不过因为会操作到非用户目录，所以需要提升权限`sudo`。     
******
### 安装Nvm (Mac下)
#### 1.卸载已安装到全局的node/npm
官网下载的node安装包，运行后会自动安装在全局目录，其中node命令在`/usr/local/bin/node`，npm命令在全局的`node_modules`目录中，具体路径`/usr/local/lib/node_modules/npm`     
已安装的nvm卸载如下：     
```
npm ls -g --depth=0 # 查看已安装在全局模块
sudo rm -rf /usr/local/lib/node_modules # 删除全局node_modules目录
sudo rm -rf /usr/local/bin/node
cd /usr/local/bin && ls -l | grep "../lib/node_modules/" | awk '{print $9}' |
xargs rm # 删除全局node软链接 ln
```
#### 2.安装nvm
```
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash
# curl -o 输出文件，-o- 不更改文件名输出
```
以上步骤后nvm便安装完成。     
#### 3.配置加速nvm
更改环境变量NVM_NODEJS_ORG_MIRROR，可以在.bash_profile中加入如下行：     
```
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node
source ~/.bash_profile # 编译文件
```
`nvm ls`查看node版本，以及当前所用node版本。     
#### 4.cnpm加速npm
Nvm和Npm默认是从国外源下载资源，可通过简单参数使用`--registry
https://registry.npm.taobao.org`来使用国内镜像。     
```
npm --registry=https://registry.npm.taobao.org install koa
```
缺点有同步时间差异，cnpm默认同步时间间隔为15分钟。     
```
# 安装cnpm
npm --registry=https://registry.npm.taobao.org install cnpm -g
```
同步模块：    
```
cnpm sync xxx connect mocha
```
#### 5.nvm常用命令
- nvm install \<version\> 安装指定版本node
- nvm uninstall \<version\> 卸载指定版本node
- nvm use \<version\> 切换指定版本node
- nvm ls 列出所安装的node版本
- nvm ls-remote 列出远程服务器node 版本
- nvm current 显示当前版本
- nvm alias \<name\> \<version\> 为指定版本添加别名
- nvm unalias \<name\> 删除别名
- nvm reinstall-packages \<version\> 重新安装指定版本node

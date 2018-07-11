# Go实践技巧
### 打印结构体
Go语言中打印结构体推荐使用『%+v』，而不是『%v』，区别如下：     
```
package main

import "fmt"

type info struct {
    name string
    id int
}

func main() {
    v := info{"Tom", 33}
    fmt.Printf("%v \n", v)
    fmt.Printf("%+v \n", v)
}
```
运行：     
```
{Tom 33}
{name:Tom id:33}
```
### Go语言是否需要设置GOROOT和GOPATH？
技巧出处：[这里][h]     
转自：<https://twitter.com/davecheney/status/431581286918934528>     
![GOROOT&GOPATH][gorp]

[h]:https://nanxiao.me/category/%E6%8A%80%E6%9C%AF/go%E8%AF%AD%E8%A8%80%E5%AE%9E%E8%B7%B5%E6%8A%80%E5%B7%A7/
[gorp]:https://github.com/DonsonGit/singleregistry/blob/master/asset/images/gorp.jpg
### Go语言中的unbuffered channel
下列两种方式创建的都是unbuffered channel:     
> ch = make(chan int)     
> ch = make(chan int, 0)
### Go计算时间差
```
package main

import (
    "time"
    "fmt"
)

func main(){
    t1 := time.Now()
    time.Sleep(5 * time.Second)
    fmt.Println(time.Since(t1))
}
```
其中time.Since(t)是time.Now().Sub(t)的shorthand。     
运行：     
```
1.2345s
```
### Go语言是纯粹的值传递形式，而非引用传递
来自：<http://www.flysnow.org/2018/02/24/golang-function-parameters-passed-by-value.html>
### Go中defer
defer示例：     
```
file, err := os.Open(dataFile)
if err != nil {
    ...
}
defer file.Close()
```
defer语句可以看成是把指定的函数压入『堆栈』，当外面函数退出时，『堆栈』内的函数会依次弹出执行。     
这样可以防止资源泄露。    

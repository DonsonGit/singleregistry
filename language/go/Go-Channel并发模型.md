# Go channels
Go语言并发模型篇

[并发和并行](http://blog.golang.org/concurrency-is-not-parallelism)并不相同，需要区分清楚并发和并行的概念。

Goroutines是指在硬件允许的情况下创建能够并行执行程序的架构。

## Go goroutine
### 开启一个goroutine
```
# 开启一个goroutine
go func

# 完整
go func(){

}()
```
### 此篇主要说明channel和goroutine的关系
关系的说明可以从如下的例子开始：

```
func main() {
  go fmt.Println("goroutine")
  fmt.Println("main function")
}
```
这段代码所产生的输出并不一定，可能只有*main function*也可能是*main
function和goroutine*，原因是当运行goroutine时，main函数并不会等待goroutine完成，而是继续往下运行，在运行完Println函数后main函数结束了执行，在Go语言里这意味着这个程序及所催生的goroutines停止执行。goroutine在这之前有可能执行完了，也有可能还没执行完，所以结果并不固定。

接下来便是Channels的出场了。

## Channels
### Channel的创建
```
# 默认容量为0
c := make(chan bool)
# 创建缓冲容量为2的channel
cc := make(chan string, 2)

# 只读的channel
r := make(<- chan bool)
# 只写的channel
w := make(chan <- string)
```


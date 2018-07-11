# Go 网络编程
Go中net包的运用与测试

## Tcp服务器
一个（web）服务器应用需要响应众多客户端的并发请求：go会为每一个客户端产生一个goroutine用来处理请求。
- 使用net包中网络通信的功能
- net包包含了用于TCP/IP以及UDP协议、域名解析等方法

### 服务端
```
package main

import (
    "fmt"
    "net"
)

func main() {
    fmt.Println("Starting the server ...")
    // 创建 listener
    listener, err := net.Listen("tcp", "localhost:50000")
    if err != nil {
        fmt.Println("Error listening", err.Error())
        return //终止程序
    }
    // 监听并接受来自客户端的连接
    for {
        // Accept会阻塞线程知道接收到一个请求
        conn, err := listener.Accept()
        if err != nil {
            fmt.Println("Error accepting", err.Error())
            return // 终止程序
        }
        go doServerStuff(conn)
    }
}

func doServerStuff(conn net.Conn) {
    for {
        buf := make([]byte, 512)
        len, err := conn.Read(buf)
        if err != nil {
            fmt.Println("Error reading", err.Error())
            return //终止程序
        }
        fmt.Printf("Received data: %v", string(buf[:len]))
    }
}
```

### 客户端
```
package main

import (
    "bufio"
    "fmt"
    "net"
    "os"
    "strings"
)

func main() {
    //打开连接:
    conn, err := net.Dial("tcp", "localhost:50000")
    if err != nil {
        //由于目标计算机积极拒绝而无法创建连接
        fmt.Println("Error dialing", err.Error())
        return // 终止程序
    }

    inputReader := bufio.NewReader(os.Stdin)
    fmt.Println("First, what is your name?")
    clientName, _ := inputReader.ReadString('\n')
    // fmt.Printf("CLIENTNAME %s", clientName)
    trimmedClient := strings.Trim(clientName, "\r\n") // Windows 平台下用 "\r\n"，Linux平台下使用 "\n"
    // 给服务器发送信息直到程序退出：
    for {
        fmt.Println("What to send to the server? Type Q to quit.")
        input, _ := inputReader.ReadString('\n')
        trimmedInput := strings.Trim(input, "\r\n")
        // fmt.Printf("input:--%s--", input)
        // fmt.Printf("trimmedInput:--%s--", trimmedInput)
        if trimmedInput == "Q" {
            return
        }
        _, err = conn.Write([]byte(trimmedClient + " says: " + trimmedInput))
    }
}
```



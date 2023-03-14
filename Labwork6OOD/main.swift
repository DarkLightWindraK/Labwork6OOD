import Foundation

func createChain() -> Handler {
    let javaHandler = JavaHandler()
    let swiftHandler = SwiftHandler()
    javaHandler.next = swiftHandler
    return javaHandler
}

let chain = createChain()
print("Введите путь до файла: ")
let path = readLine() ?? ""
chain.handle(file: path)

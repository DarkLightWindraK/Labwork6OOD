import Foundation

protocol Handler {
    var next: Handler? { get set }
    func handle(file: String)
}

class JavaHandler: Handler {
    var next: Handler?
    
    private func tryToHandle(file: String) -> Bool {
        guard file.hasSuffix(".jar") else { return false }
        
        let paths = System.findApplicationPathsForRunning(name: "java")

        guard !paths.isEmpty else { return false }

        for path in paths {
            runJavaFileUsingProgrammPath(pathOfRunner: path, pathOfFile: file)
            return true
        }
        
        return false
    }
    
    func handle(file: String) {
        if !tryToHandle(file: file) {
            next?.handle(file: file)
        }
    }
    
    func runJavaFileUsingProgrammPath(pathOfRunner: String, pathOfFile: String) {
        let command = "\(pathOfRunner) -jar \(pathOfFile)"
        print(System.execute(command: command))
    }
}

class SwiftHandler: Handler {
    var next: Handler?
    
    private func tryToHandle(file: String) -> Bool {
        guard file.hasSuffix(".swift") else { return false }
        
        let paths = System.findApplicationPathsForRunning(name: "swift")

        guard !paths.isEmpty else { return false }

        for path in paths {
            runSwiftFileUsingProgrammPath(pathOfRunner: path, pathOfFile: file)
            return true
        }
        
        return false
    }
    
    func handle(file: String) {
        if !tryToHandle(file: file) {
            next?.handle(file: file)
        }
    }
    
    func runSwiftFileUsingProgrammPath(pathOfRunner: String, pathOfFile: String) {
        let nameCompiledFile = String(pathOfFile.dropLast(6))
        let compileCommand = "swiftc -o \(nameCompiledFile) \(pathOfFile)"
        System.execute(command: compileCommand)
        print(System.execute(command: nameCompiledFile))
    }
}

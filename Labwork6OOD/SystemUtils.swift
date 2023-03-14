import Foundation

enum System {
    static func execute(command : String) -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/bash")
        
        try? task.run()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""
        
        if output.count > 0 {
            let lastIndex = output.index(before: output.endIndex)
            return String(output[output.startIndex ..< lastIndex])
        }
        
        return output
    }
    
    static func findApplicationPathsForRunning(name: String) -> [String] {
        Array(execute(command: "whereis \(name)").components(separatedBy: " ").dropFirst())
    }
}

import Foundation

public class Error: CustomStringConvertible {
    public var description: String {
        var message = "Error: \(name): \(message) \n\tFile: \(initialPosition.fileName)\t|\tLine: \(initialPosition.line + 1)\t|\tPosition: (\(initialPosition.column),\(finalPosition.column))\n\n\t\(initialPosition.fileContent)\n\t"
        for _ in 1...initialPosition.column {
            message.append(" ")
        }
        for _ in 1...finalPosition.column - initialPosition.column {
            message.append("^")
        }
        
        return message
    }
    
    let name: String
    let message: String
    let initialPosition: Position
    let finalPosition: Position
    
    public init(name: String, message: String, initialPosition: Position?, finalPosition: Position?) {
        self.name = name
        self.message = message
        self.initialPosition = initialPosition ?? Position(index: 0, line: 0, column: 0, fileName: "", fileContent: "")
        self.finalPosition = finalPosition ?? Position(index: 0, line: 0, column: 0, fileName: "", fileContent: "")
    }
}

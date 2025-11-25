import Foundation

public class Position {
    var index : Int
    var line : Int
    var column : Int
    let fileName : String
    let fileContent : String
    
    public init(index:Int, line:Int, column:Int, fileName:String, fileContent:String){
        self.index = index
        self.line = line
        self.column = column
        self.fileName = fileName
        self.fileContent = fileContent
    }
    
    public func advance() -> Position {
        return self.advance(to: "\0")
    }
    
    @discardableResult public func advance(to char : Character) -> Position {
        index += 1
        column += 1
        if parseTT(tt: TokenType.newLine).contains(char) {
            line += 1
            column = 0
        }
        
        return self
    }
    
    public func copy() -> Position {
        return Position.init(index: self.index, line: self.line, column: self.column, fileName: self.fileName, fileContent: self.fileContent)
    }
}

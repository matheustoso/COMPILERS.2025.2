import Foundation

public class Token: Node, CustomStringConvertible {
    
    public var description: String {
        if type == TokenType.newLine {
            Lang.lineCount+=1
            return "\n💬\tLEXER \t\t\(Lang.lineCount):->\t"
        }
        return "\(self.type.rawValue)::\(self.value)"
    }
    
    var type: TokenType
    var value: String
    
    public init(type: TokenType, initialPosition: Position) {
        self.type = type
        self.value = parseTT(tt: type)
        super.init(initialPosition: initialPosition.copy(), finalPosition: initialPosition.copy().advance())
    }
    
    public init(type: TokenType, initialPosition: Position, finalPosition: Position) {
        self.type = type
        self.value = parseTT(tt: type)
        super.init(initialPosition: initialPosition.copy(), finalPosition: finalPosition.copy())
    }
    
    public init(type: TokenType, value: String, initialPosition: Position, finalPosition: Position) {
        self.type = type
        self.value = value
        super.init(initialPosition: initialPosition.copy(), finalPosition: finalPosition.copy())
    }
    
    public func compare(toType type: TokenType, andValue value: String) -> Bool {
        return self.type == type && self.value == value
    }
    
    public func realValue() -> RawConvertible {
        guard self.type != TokenType.num else {
            return Double(value)!
        }
        return value
    }
}



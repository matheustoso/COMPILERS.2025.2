import Foundation

public class List: Value, CustomStringConvertible {
    public var description: String {
        return "\(self.values)"
    }
    
    public var initialPosition: Position?
    public var finalPosition: Position?
    public var context: Context?
    var values: [Value]
    
    public init(values: [Value]) {
        self.values = values
    }
    
    public init(copiedFrom list: List) {
        self.values = list.values
        self.initialPosition = list.initialPosition
        self.finalPosition = list.finalPosition
        self.context = list.context
    }
    
    public func copy() -> Value {
        return List(copiedFrom: self)
    }
}

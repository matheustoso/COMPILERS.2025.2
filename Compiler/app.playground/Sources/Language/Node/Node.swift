import Foundation

public class Node: Element {
    public var initialPosition: Position
    public var finalPosition: Position
    
    public init(initialPosition: Position, finalPosition: Position) {
        self.initialPosition = initialPosition
        self.finalPosition = finalPosition
    }
    
    public func accept(visitor: Visitor, inContext context: Context) -> RuntimeResult {
        return visitor.visit(node: self, inContext: context)
    }
}

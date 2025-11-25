import Foundation

public class Statement: Node, CustomStringConvertible {
    public var description: String {
        return "\(self.nodes)"
    }
    
    var nodes: [Node]
    
    public init(nodes: [Node], initialPosition: Position, finalPosition: Position) {
        self.nodes = nodes
        super.init(initialPosition: initialPosition, finalPosition: finalPosition)
    }
    
    public override func accept(visitor: Visitor, inContext context: Context) -> RuntimeResult {
        return visitor.visit(node: self, inContext: context)
    }
}

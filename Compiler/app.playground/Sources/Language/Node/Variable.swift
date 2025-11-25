import Foundation

public class Variable: Node, CustomStringConvertible {
    public var description: String {
        return String(describing: self.name)
    }
    
    var name: Token
    
    public init(name: Token) {
        self.name = name
        super.init(initialPosition: name.initialPosition, finalPosition: name.finalPosition)
    }
    
    public override func accept(visitor: Visitor, inContext context: Context) -> RuntimeResult {
        return visitor.visit(node: self, inContext: context)
    }
}

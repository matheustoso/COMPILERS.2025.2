import Foundation

public class Operand: Node, CustomStringConvertible {
    public var description: String {
        return self.token.description
    }
    
    var token: Token
    
    public init(token: Token) {
        self.token = token
        super.init(initialPosition: token.initialPosition, finalPosition: token.finalPosition)
    }
    
    public override func accept(visitor: Visitor, inContext context: Context) -> RuntimeResult {
        return visitor.visit(node: self, inContext: context)
    }
    
}

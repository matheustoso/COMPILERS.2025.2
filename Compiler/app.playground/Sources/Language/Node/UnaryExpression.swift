import Foundation

public class UnaryExpression: Node, CustomStringConvertible {
    public var description: String {
        return "\(self._operator),\(self.operand)"
    }
    
    var _operator: Token
    var operand: Node
    
    internal init(_operator: Token, operand: Node) {
        self._operator = _operator
        self.operand = operand
        super.init(initialPosition: _operator.initialPosition, finalPosition: operand.finalPosition)
    }
    
    public override func accept(visitor: Visitor, inContext context: Context) -> RuntimeResult {
        return visitor.visit(node: self, inContext: context)
    }
    
}

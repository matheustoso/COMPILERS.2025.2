import Foundation

public class BinaryExpression: Node, CustomStringConvertible {
    public var description: String {
        return "(\(self.leftOperand),\(self._operator),\(self.rightOperand))"
    }
    
    var leftOperand: Node
    var _operator: Token
    var rightOperand: Node
    
    public init(leftOperand: Node, _operator: Token, rightOperand: Node) {
        self.leftOperand = leftOperand
        self._operator = _operator
        self.rightOperand = rightOperand
        super.init(initialPosition: leftOperand.initialPosition, finalPosition: rightOperand.finalPosition)
    }
    
    public override func accept(visitor: Visitor, inContext context: Context) -> RuntimeResult {
        return visitor.visit(node: self, inContext: context)
    }
    
}


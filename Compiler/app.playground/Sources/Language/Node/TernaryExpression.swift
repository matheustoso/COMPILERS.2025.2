import Foundation

public class TernaryExpression: Node, CustomStringConvertible {
    public var description: String {
        return "(\(self.leftOperand),\(self.leftOperator),\(self.middleOperand),\(self.rightOperator),\(self.rightOperand))"
    }
    
    var leftOperand: Node
    var leftOperator: Token
    var middleOperand: Node
    var rightOperator: Token
    var rightOperand: Node
    
    public init(leftOperand: Node, leftOperator: Token, middleOperand: Node, rightOperator: Token, rightOperand: Node) {
        self.leftOperand = leftOperand
        self.leftOperator = leftOperator
        self.middleOperand = middleOperand
        self.rightOperator = rightOperator
        self.rightOperand = rightOperand
        super.init(initialPosition: leftOperand.initialPosition, finalPosition: rightOperand.finalPosition)
    }
    
    public override func accept(visitor: Visitor, inContext context: Context) -> RuntimeResult {
        return visitor.visit(node: self, inContext: context)
    }
    
}

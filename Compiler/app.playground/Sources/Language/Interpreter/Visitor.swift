import Foundation

public protocol Visitor {
    func visit(node: Node, inContext context: Context) -> RuntimeResult
    func visit(node: Statement, inContext context: Context) -> RuntimeResult
    func visit(node: TernaryExpression, inContext context: Context) -> RuntimeResult
    func visit(node: BinaryExpression, inContext context: Context) -> RuntimeResult
    func visit(node: UnaryExpression, inContext context: Context) -> RuntimeResult
    func visit(node: Operand, inContext context: Context) -> RuntimeResult
    func visit(node: AccessVariable, inContext context: Context) -> RuntimeResult
    func visit(node: AttributionVariable, inContext context: Context) -> RuntimeResult
    func visit(node: Call, inContext context: Context) -> RuntimeResult
    func visit(node: For, inContext context: Context) -> RuntimeResult
}

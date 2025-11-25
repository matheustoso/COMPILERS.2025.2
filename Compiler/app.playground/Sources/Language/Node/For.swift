import Foundation

public class For: Node, CustomStringConvertible {
    public var description: String {
        return "(\(TokenType.key.rawValue)::\(Keyword._for.rawValue),\(self.name),\(TokenType.key.rawValue)::\(Keyword.to.rawValue),\(self.finalIndex),\(self.increment == nil ? "" :"\(TokenType.key.rawValue)::\( Keyword.increment.rawValue)"),\(self.increment == nil ? "" : "\(String(describing: self.increment))"),\(TokenType.key.rawValue)::\(Keyword.then.rawValue),\(self.body))"
    }
    
    public var name: Token
    public var initialIndex: Node
    public var finalIndex: Node
    public var increment: Node?
    public var body: Node
    public var nullReturn: Bool
    
    public init(name: Token, initialIndex: Node, finalIndex: Node, increment: Node?, body: Node, _ nullReturn: Bool) {
        self.name = name
        self.initialIndex = initialIndex
        self.finalIndex = finalIndex
        self.increment = increment
        self.body = body
        self.nullReturn = nullReturn
        super.init(initialPosition: name.initialPosition, finalPosition: body.finalPosition)
    }
    
    public override func accept(visitor: Visitor, inContext context: Context) -> RuntimeResult {
        return visitor.visit(node: self, inContext: context)
    }
}

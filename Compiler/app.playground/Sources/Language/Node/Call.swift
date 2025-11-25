import Foundation

public class Call: Node, CustomStringConvertible {
    public var description: String {
        return "(\(self.name)->\(self.parameters.description)"
    }
    
    var name: Node
    var parameters: [Node]
    
    public init(name: Node, parameters: [Node]) {
        self.name = name
        self.parameters = parameters
        super.init(initialPosition: name.initialPosition, finalPosition: name.finalPosition)
    }
    
    public override func accept(visitor: Visitor, inContext context: Context) -> RuntimeResult {
        return visitor.visit(node: self, inContext: context)
    }
    
    public func finalPosition() -> Position {
        var position = self.finalPosition
        if let parameter = parameters.last { position = parameter.finalPosition }
        return position
    }
    
    
}

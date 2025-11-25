import Foundation

public class AttributionVariable: Variable {
    var value: Node
    
    public init(name: Token, value: Node) {
        self.value = value
        super.init(name: name)
    }
}

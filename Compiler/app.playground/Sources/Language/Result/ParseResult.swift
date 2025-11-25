import Foundation

public class ParseResult: Result<Node> {
    var advancementCount: Int
    var revertCount: Int
    
    override public init() {
        self.advancementCount = 0
        self.revertCount = 0
        super.init()
    }
    
    @discardableResult public func register(result: ParseResult) -> Node? {
        if let error = result.error { self.error = error }
        return result.data
    }
    
    @discardableResult public func tryRegister(result: ParseResult) -> Node? {
        guard result.error == nil else {
            self.revertCount = result.advancementCount
            return nil
        }
        return result.register(result: result)
    }
    
    public func register() {
        self.advancementCount += 1
    }
    
    public func success(withNode node: Node?) -> ParseResult {
        self.data = node
        return self
    }
    
    public func failure(withError error: Error) -> ParseResult {
        if self.error == nil || self.advancementCount == 0 { self.error = error }
        return self
    }
}

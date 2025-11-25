import Foundation

public class Symbols {
    var local: [String: Value]
    var inherited: [String: Value]
    
    public init(_ local: [String: Value]) {
        self.local = local
        self.inherited = [:]
    }
    
    public init(symbols: Symbols) {
        self.local = symbols.local
        self.inherited = symbols.inherited
    }
    
    public func get(fromKey name: String) -> Value? {
        guard let value = local[name] else {
            guard !inherited.isEmpty, let value = inherited[name] else {
                return nil
            }
            return value
        }
        return value
    }
    
    public func put(key: String, withValue value: Value) {
        local[key] = value
    }
    
    public func remove(entryAt key: String){
        local[key] = nil
    }
}

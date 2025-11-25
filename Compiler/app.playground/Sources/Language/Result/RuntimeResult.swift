import Foundation

public class RuntimeResult: Result<Value> {
    @discardableResult public func register(result: RuntimeResult) -> (value: Value?, number: Number?) {
        if let error = result.error { self.error = error }
        return (value: result.data, number: result.data as? Number)
    }
    
    public func success(withValue value: Value?) -> RuntimeResult {
        self.data = value
        return self
    }
    
    public func failure(withError error: Error) -> RuntimeResult {
        self.error = error
        return self
    }
    
}

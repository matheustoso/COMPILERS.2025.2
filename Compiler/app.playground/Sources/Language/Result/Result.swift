import Foundation

public class Result<Data> : CustomStringConvertible {
    public var description: String {
        guard self.error == nil else {
            return String(describing: self.error)
        }
        return String(describing: self.data)
    }
    
    public var data: Data?
    public var error: Error?
    
    public init(){}
    
    public init(data: Data?, error: Error?){
        self.data = data
        self.error = error
    }
}

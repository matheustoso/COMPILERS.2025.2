import Foundation

public protocol Value {
    var initialPosition: Position? {get set}
    var finalPosition: Position? {get set}
    var context: Context? {get set}
    
    func copy() -> Value
}



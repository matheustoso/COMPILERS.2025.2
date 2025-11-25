import Foundation

public protocol Element {
    func accept(visitor: Visitor, inContext context: Context) -> RuntimeResult
}

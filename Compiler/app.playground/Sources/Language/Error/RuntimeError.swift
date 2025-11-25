import Foundation

public class RuntimeError: Error {
    public init(message: String, initialPosition: Position?, finalPosition: Position?) {
        super.init(name: "Runtime", message: message, initialPosition: initialPosition, finalPosition: finalPosition)
    }
}

import Foundation

public class IllegalCharError: Error {
    public init(message: String, initialPosition: Position?, finalPosition: Position?) {
        super.init(name: "Illegal Char", message: message, initialPosition: initialPosition, finalPosition: finalPosition)
    }
}

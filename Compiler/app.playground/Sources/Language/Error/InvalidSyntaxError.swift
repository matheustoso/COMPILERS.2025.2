import Foundation

public class InvalidSyntaxError: Error {
    public init(message: String, initialPosition: Position?, finalPosition: Position?) {
        super.init(name: "Invalid Syntax", message: message, initialPosition: initialPosition, finalPosition: finalPosition)
    }
}

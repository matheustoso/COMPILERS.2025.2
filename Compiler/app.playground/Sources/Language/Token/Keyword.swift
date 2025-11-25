import Foundation

public enum Keyword: String {
    case variable = "var"
    case _for = "for"
    case to = "to"
    case increment = "increment"
    case then = "then"
    case end = "end"
    
    static let rawValues = ["var", "for", "to", "increment", "then", "end"]
}

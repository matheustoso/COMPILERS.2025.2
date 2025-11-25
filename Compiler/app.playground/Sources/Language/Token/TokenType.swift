public enum TokenType : String {
    case empty, newLine, num, plus, minus, div, mul, pow, and, or, xor, not, lPar, rPar, key, id, assign, equals, different, larger, smaller, largerEquals, smallerEquals, comma, eof, question, colon
}

public func parseTT(tt : TokenType) -> String {
    switch tt {
    case .empty:
        return " \t"
    case .newLine:
        return "\n"
    case .num:
        return "1234567890"
    case .plus:
        return "+"
    case .minus:
        return "-"
    case .div:
        return "/"
    case .mul:
        return "*"
    case .pow:
        return "^"
    case .and:
        return "&"
    case .or:
        return "|"
    case .xor:
        return "#"
    case .not:
        return "!"
    case .lPar:
        return "("
    case .rPar:
        return ")"
    case .key:
        return ""
    case .id:
        return "^[a-zA-Z_]*$"
    case .assign:
        return "="
    case .equals:
        return "=="
    case .different:
        return "!="
    case .larger:
        return ">"
    case .smaller:
        return "<"
    case .largerEquals:
        return ">="
    case .smallerEquals:
        return "<="
    case .comma:
        return ","
    case .eof:
        return ""
    case .question:
        return "?"
    case .colon:
        return ":"
    }
}

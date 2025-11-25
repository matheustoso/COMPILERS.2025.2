import Foundation

public class Lexer {
    let fileName: String
    let text: String
    var currentPosition: Position
    var currentChar: Character
    
    public init(text: String, fileName: String) {
        self.text = text
        self.fileName = fileName
        self.currentPosition = Position(index: -1, line: 0, column: -1, fileName: fileName, fileContent: text)
        self.currentChar = "\0"
    }
    
    public func tokenize() -> Result<[Token]> {
        var tokens: [Token] = []
        advance()
        
        while currentChar != "\0" {
            if parseTT(tt: TokenType.empty).contains(currentChar) {
                advance()
                
            } else if parseTT(tt: TokenType.newLine).contains(currentChar) {
                tokens.append(Token(type: TokenType.newLine, initialPosition: currentPosition))
                advance()
                
            } else if parseTT(tt: TokenType.num).contains(currentChar) {
                let result = createNumber()
                guard result.error == nil else { return Result(data: nil, error: result.error) }
                tokens.append(result.data!)
                
            } else if NSRegularExpression(parseTT(tt: TokenType.id)).matches(String(currentChar)) {
                let result = createId()
                guard result.error == nil else { return Result(data: nil, error: result.error) }
                tokens.append(result.data!)
                
            } else if parseTT(tt: TokenType.plus).contains(currentChar) {
                tokens.append(Token(type: TokenType.plus, initialPosition: currentPosition))
                advance()
                
            } else if parseTT(tt: TokenType.minus).contains(currentChar) {
                tokens.append(Token(type: TokenType.minus, initialPosition: currentPosition))
                advance()
                
            } else if parseTT(tt: TokenType.mul).contains(currentChar) {
                tokens.append(Token(type: TokenType.mul, initialPosition: currentPosition))
                advance()
                
            } else if parseTT(tt: TokenType.div).contains(currentChar) {
                tokens.append(Token(type: TokenType.div, initialPosition: currentPosition))
                advance()
                
            } else if parseTT(tt: TokenType.pow).contains(currentChar) {
                tokens.append(Token(type: TokenType.pow, initialPosition: currentPosition))
                advance()
                
            } else if parseTT(tt: TokenType.assign).contains(currentChar) {
                let result = createAssign()
                guard result.error == nil else { return Result(data: nil, error: result.error) }
                tokens.append(result.data!)
                
            } else if parseTT(tt: TokenType.lPar).contains(currentChar) {
                tokens.append(Token(type: TokenType.lPar, initialPosition: currentPosition))
                advance()
                
            } else if parseTT(tt: TokenType.rPar).contains(currentChar) {
                tokens.append(Token(type: TokenType.rPar, initialPosition: currentPosition))
                advance()
                
            } else if parseTT(tt: TokenType.not).contains(currentChar) {
                let result = createNot()
                guard result.error == nil else { return Result(data: nil, error: result.error) }
                tokens.append(result.data!)
                
            } else if parseTT(tt: TokenType.larger).contains(currentChar) {
                let result = createLarger()
                guard result.error == nil else { return Result(data: nil, error: result.error) }
                tokens.append(result.data!)
                
            } else if parseTT(tt: TokenType.smaller).contains(currentChar) {
                let result = createSmaller()
                guard result.error == nil else { return Result(data: nil, error: result.error) }
                tokens.append(result.data!)
                
            } else if parseTT(tt: TokenType.and).contains(currentChar) {
                tokens.append(Token(type: TokenType.and, initialPosition: currentPosition))
                advance()
                
            } else if parseTT(tt: TokenType.or).contains(currentChar) {
                tokens.append(Token(type: TokenType.or, initialPosition: currentPosition))
                advance()
                
            } else if parseTT(tt: TokenType.xor).contains(currentChar) {
                tokens.append(Token(type: TokenType.xor, initialPosition: currentPosition))
                advance()
                
            } else if parseTT(tt: TokenType.comma).contains(currentChar) {
                tokens.append(Token(type: TokenType.comma, initialPosition: currentPosition))
                advance()
                
            } else if parseTT(tt: TokenType.question).contains(currentChar) {
                tokens.append(Token(type: TokenType.question, initialPosition: currentPosition))
                advance()
                
            } else if parseTT(tt: TokenType.colon).contains(currentChar) {
                tokens.append(Token(type: TokenType.colon, initialPosition: currentPosition))
                advance()
                
            } else {
                let initialPosition = currentPosition.copy()
                let illegalChar = currentChar
                advance()
                return Result<[Token]>.init(data: nil, error: IllegalCharError(message: "'\(illegalChar)'", initialPosition: initialPosition, finalPosition: currentPosition))
            }
        }
        
        tokens.append(Token(type: TokenType.eof, initialPosition: currentPosition, finalPosition: currentPosition.copy().advance()))
        return Result(data: tokens, error: nil)
    }
    
    func advance() {
        currentPosition.advance(to: currentChar)
        if currentPosition.index < text.count {
            currentChar = text[currentPosition.index]
        } else {
            currentChar = "\0"
        }
    }
    
    func createNumber() -> Result<Token> {
        var number = ""
        var dotCount = 0
        let values = "\(parseTT(tt: TokenType.num))."
        var initialPosition = currentPosition.copy()
        
        while currentChar != "\0", values.contains(currentChar) {
            if currentChar == "." { dotCount += 1 }
            guard dotCount <= 1 else {
                initialPosition = currentPosition.copy()
                advance()
                return Result<Token>.init(data: nil, error: IllegalCharError(message: "Number has too many dots.", initialPosition: initialPosition, finalPosition: currentPosition))
            }
            number.append(currentChar)
            advance()
        }
        
        return Result<Token>.init(data: Token(type: TokenType.num, value: number, initialPosition: initialPosition, finalPosition: currentPosition), error: nil)
    }
    
    func createId() -> Result<Token> {
        var id = ""
        let initialPosition = currentPosition.copy()
        let regex = NSRegularExpression(parseTT(tt: TokenType.id))
        
        while currentChar != "\0", String(currentChar) != parseTT(tt: TokenType.newLine), regex.matches(String(currentChar)) {
            id.append(currentChar)
            advance()
        }
        
        let type = Keyword.rawValues.contains(id) ? TokenType.key : TokenType.id
        
        return Result<Token>.init(data: Token(type: type, value: id, initialPosition: initialPosition, finalPosition: currentPosition), error: nil)
    }
    
    func createAssign() -> Result<Token> {
        let initialPosition = currentPosition.copy()
        advance()
        
        if parseTT(tt: TokenType.equals).contains(currentChar) {
            advance()
            return Result<Token>.init(data: Token(type: TokenType.equals, value: parseTT(tt: TokenType.equals), initialPosition: initialPosition, finalPosition: currentPosition), error: nil)
        }
        
        return Result<Token>.init(data: Token(type: TokenType.assign, value: parseTT(tt: TokenType.assign), initialPosition: initialPosition, finalPosition: currentPosition), error: nil)
    }

    func createNot() -> Result<Token> {
        let initialPosition = currentPosition.copy()
        advance()
        
        if parseTT(tt: TokenType.equals).contains(currentChar) {
            advance()
            return Result<Token>.init(data: Token(type: TokenType.different, value: parseTT(tt: TokenType.different), initialPosition: initialPosition, finalPosition: currentPosition), error: nil)
        }
        
        return Result<Token>.init(data: Token(type: TokenType.not, value: parseTT(tt: TokenType.not), initialPosition: initialPosition, finalPosition: currentPosition), error: nil)
    }
    
    func createLarger() -> Result<Token> {
        let initialPosition = currentPosition.copy()
        var type = TokenType.larger
        advance()
        
        if parseTT(tt: TokenType.equals).contains(currentChar) {
            advance()
            type = TokenType.largerEquals
        }
    
        return Result<Token>.init(data: Token(type: type, value: parseTT(tt: type), initialPosition: initialPosition, finalPosition: currentPosition), error: nil)
    }
    
    func createSmaller() -> Result<Token> {
        let initialPosition = currentPosition.copy()
        var type = TokenType.smaller
        advance()
        
        if parseTT(tt: TokenType.equals).contains(currentChar) {
            advance()
            type = TokenType.smallerEquals
        }
    
        return Result<Token>.init(data: Token(type: type, value: parseTT(tt: type), initialPosition: initialPosition, finalPosition: currentPosition), error: nil)
    }
}

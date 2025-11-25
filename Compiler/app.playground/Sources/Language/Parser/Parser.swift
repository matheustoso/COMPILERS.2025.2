import Foundation

public class Parser {
    let tokens: [Token]
    var index: Int
    var currentToken: Token?
    
    public init(tokens: [Token]) {
        self.tokens = tokens
        self.index = -1
        advance()
    }
    
    public func parse() -> ParseResult {
        let result = statements()
        if result.error == nil, currentToken?.type != TokenType.eof {
            return result.failure(withError:
                                    InvalidSyntaxError(
                                        message: "Token cannot appear after previous tokens",
                                        initialPosition: currentToken?.initialPosition,
                                        finalPosition: currentToken?.finalPosition))
        }
        return result
    }
    
    func advance() {
        index += 1
        if index < tokens.count {
            currentToken = tokens[index]
        }
    }
    
    func revert(to amount: Int = 1) {
        index -= amount
        if index < tokens.count {
            currentToken = tokens[index]
        }
    }
    
    func _for() -> ParseResult {
        let result = ParseResult()
        guard currentToken?.compare(toType: TokenType.key, andValue: Keyword._for.rawValue) == true else {
            return result.failure(withError: InvalidSyntaxError.init(message: "'for' expected.", initialPosition: currentToken?.initialPosition, finalPosition: currentToken?.finalPosition))
        }
        
        result.register()
        advance()
        
        guard currentToken?.type == TokenType.id else {
            return result.failure(withError: InvalidSyntaxError.init(message: "Identifier expected.", initialPosition: currentToken?.initialPosition, finalPosition: currentToken?.finalPosition))
        }
        
        let name = currentToken
        result.register()
        advance()
        
        guard currentToken?.type == TokenType.assign else {
            return result.failure(withError: InvalidSyntaxError.init(message: "'=' expected.", initialPosition: currentToken?.initialPosition, finalPosition: currentToken?.finalPosition))
        }
        
        result.register()
        advance()
        
        let initialIndex = result.register(result: expression())
        guard result.error == nil else { return result }
        
        guard currentToken?.compare(toType: TokenType.key, andValue: Keyword.to.rawValue) == true else {
            return result.failure(withError: InvalidSyntaxError.init(message: "'to' expected.", initialPosition: currentToken?.initialPosition, finalPosition: currentToken?.finalPosition))
        }
        
        result.register()
        advance()
        
        let finalIndex = result.register(result: expression())
        guard result.error == nil else { return result }
        
        var increment: Node?
        
        if currentToken?.compare(toType: TokenType.key, andValue: Keyword.increment.rawValue) == true {
            result.register()
            advance()
            
            increment = result.register(result: expression())
            guard result.error == nil else { return result }
        }
        
        guard currentToken?.compare(toType: TokenType.key, andValue: Keyword.then.rawValue) == true else {
            return result.failure(withError: InvalidSyntaxError.init(message: "'then' expected.", initialPosition: currentToken?.initialPosition, finalPosition: currentToken?.finalPosition))
        }
        
        result.register()
        advance()
        
        if currentToken?.type == TokenType.newLine {
            result.register()
            advance()
            
            let body = result.register(result: statements())
            guard result.error == nil else { return result }
            
            guard currentToken?.compare(toType: TokenType.key, andValue: Keyword.end.rawValue) == true else {
                return result.failure(withError: InvalidSyntaxError.init(message: "'end' expected.", initialPosition: currentToken?.initialPosition, finalPosition: currentToken?.finalPosition))
            }
            
            result.register()
            advance()
            
            return result.success(withNode: For.init(name: name!, initialIndex: initialIndex!, finalIndex: finalIndex!, increment: increment, body: body!, true))
        }
        
        let body = result.register(result: expression())
        guard result.error == nil else { return result }
        
        return result.success(withNode: For.init(name: name!, initialIndex: initialIndex!, finalIndex: finalIndex!, increment: increment, body: body!, false))
    }
    
    func operand() -> ParseResult {
        let result = ParseResult()
        let token = currentToken
        let type = token?.type
        
        if type == TokenType.plus || type == TokenType.minus {
            result.register()
            advance()
            
            let operand = result.register(result: operand())
            guard result.error == nil else { return result }
            
            return result.success(withNode: UnaryExpression(_operator: token!, operand: operand!))
            
        } else if type == TokenType.num {
            result.register()
            advance()
            
            return result.success(withNode: Operand(token: token!))
            
        } else if type == TokenType.id {
            result.register()
            advance()
            
            return result.success(withNode: AccessVariable(name: token!))
            
        } else if type == TokenType.lPar {
            result.register()
            advance()
            
            let expression = result.register(result: expression())
            guard result.error == nil else { return result }
            
            if currentToken?.type == TokenType.rPar {
                result.register()
                advance()
                return result.success(withNode: expression)
            } else {
                return result.failure(withError: InvalidSyntaxError(message: "')' expected.", initialPosition: currentToken?.initialPosition, finalPosition: currentToken?.finalPosition))
            }
        } else if token?.compare(toType: TokenType.key, andValue: Keyword._for.rawValue) == true {
            let expression = result.register(result: _for())
            guard result.error == nil else { return result }
            
            return result.success(withNode: expression)
        }
    
        return result.failure(withError: InvalidSyntaxError(message: "Number, identifier, '+', '-', or '(' expected.", initialPosition: currentToken?.initialPosition, finalPosition: currentToken?.finalPosition))
    }
    
    func function() -> ParseResult {
        let result = ParseResult()
        let operand = result.register(result: operand())
        guard result.error == nil else { return result }
        
        if currentToken?.type == TokenType.lPar {
            result.register()
            advance()
            var parameters: [Node] = []
            
            if currentToken?.type == TokenType.rPar {
                result.register()
                advance()
                
            } else {
                parameters.append(result.register(result: expression())!)
                
                guard result.error == nil else {
                    return result.failure(withError:
                                            InvalidSyntaxError(
                                                message: "')', var, number, identifier, '+', '-', '!' or '(' expected.",
                                                initialPosition: currentToken?.initialPosition,
                                                finalPosition: currentToken?.finalPosition))
                }
                
                while currentToken?.type == TokenType.comma {
                    result.register()
                    advance()
                    
                    parameters.append(result.register(result: expression())!)
                    guard result.error == nil else { return result }
                }
                
                guard currentToken?.type == TokenType.rPar else {
                    return result.failure(withError:
                                            InvalidSyntaxError(
                                                message: "',' or ')' expected.",
                                                initialPosition: currentToken?.initialPosition,
                                                finalPosition: currentToken?.finalPosition))
                }
                
                result.register()
                advance()
            }
            
            return result.success(withNode: Call.init(name: operand!, parameters: parameters))
        }
        
        return result.success(withNode: operand)
    }
    
    func power() -> ParseResult {
        return binaryOperation(leftFunction: function, types: [TokenType.pow], rightFunction: term)
    }
    
    func term() -> ParseResult {
        return binaryOperation(function: power, types: [TokenType.mul, TokenType.div])
    }
    
    func expression() -> ParseResult {
        let result = ParseResult()
        
        if currentToken != nil, currentToken!.compare(toType: TokenType.key, andValue: Keyword.variable.rawValue) {
            result.register()
            advance()
            
            guard currentToken?.type == TokenType.id else {
                return result.failure(withError:
                                        InvalidSyntaxError(
                                            message: "Identifier expected.",
                                            initialPosition: currentToken?.initialPosition,
                                            finalPosition: currentToken?.finalPosition))
            }
            
            let name = currentToken!
            result.register()
            advance()
            
            guard currentToken?.type == TokenType.assign else {
                return result.failure(withError:
                                        InvalidSyntaxError(
                                            message: "'=' expected.",
                                            initialPosition: currentToken?.initialPosition,
                                            finalPosition: currentToken?.finalPosition))
            }
            
            result.register()
            advance()
            
            let value = result.register(result: expression())
            guard result.error == nil else { return result }

            return result.success(withNode: AttributionVariable.init(name: name, value: value!))
        }
        
        let node = result.register(result: ternaryOperation(function: logicalOperation, types: [TokenType.or, TokenType.xor]))
        guard result.error == nil else { return result }
        
        return result.success(withNode: node)
    }
    
    func statements() -> ParseResult {
        let result = ParseResult.init()
        var statements: [Node] = []
        let initialPosition = currentToken!.initialPosition.copy()
        
        while currentToken?.type == TokenType.newLine {
            result.register()
            advance()
        }
        
        var statement = result.register(result: expression())
        guard result.error == nil else { return result }
        statements.append(statement!)
        
        var moreStatements = true
        
        while moreStatements {
            var newLineCount = 0
            while currentToken?.type == TokenType.newLine {
                result.register()
                advance()
                newLineCount+=1
            }
            if newLineCount == 0 {
                moreStatements = false
            }
            guard moreStatements else { break }
            statement = result.tryRegister(result: expression())
            guard statement != nil else {
                revert(to: result.revertCount)
                moreStatements = false
                continue
            }
            statements.append(statement!)
        }

        return result.success(withNode: Statement.init(nodes: statements, initialPosition: initialPosition, finalPosition: currentToken!.finalPosition.copy()))
    }
    
    func logicalOperation() -> ParseResult {
        return binaryOperation(function: relationalOperation, types: [TokenType.and])
    }
    
    func relationalOperation() -> ParseResult {
        let result = ParseResult()
        
        if currentToken?.type == TokenType.not {
            let not = currentToken
            result.register()
            advance()
            
            let node = result.register(result: relationalOperation())
            guard result.error == nil else { return result }
            
            return result.success(withNode: UnaryExpression.init(_operator: not!, operand: node!))
        }
        
        let node = result.register(result: binaryOperation(function: arithmeticOperation, types: [TokenType.equals, TokenType.different, TokenType.larger, TokenType.smaller, TokenType.largerEquals, TokenType.smallerEquals]))
        
        guard result.error == nil else {
            return result.failure(withError:
                                    InvalidSyntaxError(
                                        message: "Number, identifier, '+', '-', '!' or '(' expected.",
                                        initialPosition: currentToken?.initialPosition,
                                        finalPosition: currentToken?.finalPosition))
        }
        
        return result.success(withNode: node)
    }
    
    func arithmeticOperation() -> ParseResult {
        return binaryOperation(function: term, types: [TokenType.plus, TokenType.minus])
    }
    
    func binaryOperation(function: () -> ParseResult, types: [TokenType]) -> ParseResult {
        let result = ParseResult()
        var leftNode = result.register(result: function())
        guard result.error == nil else { return result }
        
        while currentToken != nil, types.contains(currentToken!.type) {
            let _operator = currentToken
            result.register()
            advance()
            
            let rightNode = result.register(result: function())
            guard result.error == nil else { return result }
            leftNode = BinaryExpression.init(leftOperand: leftNode!, _operator: _operator!, rightOperand: rightNode!)
        }
        
        return result.success(withNode: leftNode)
    }
    
    func binaryOperation(leftFunction: () -> ParseResult, types: [TokenType], rightFunction: () -> ParseResult) -> ParseResult {
        let result = ParseResult()
        var leftNode = result.register(result: leftFunction())
        guard result.error == nil else { return result }
        
        while currentToken != nil, types.contains(currentToken!.type) {
            let _operator = currentToken
            result.register()
            advance()
            
            let rightNode = result.register(result: rightFunction())
            guard result.error == nil else { return result }
            leftNode = BinaryExpression.init(leftOperand: leftNode!, _operator: _operator!, rightOperand: rightNode!)
        }
        
        return result.success(withNode: leftNode)
    }
    
    func binaryOperation(leftNode: Node, function: () -> ParseResult, types: [TokenType]) -> ParseResult {
        let result = ParseResult()
        var solution = leftNode
        
        while currentToken != nil, types.contains(currentToken!.type) {
            let _operator = currentToken
            result.register()
            advance()
            
            let rightNode = result.register(result: function())
            guard result.error == nil else { return result }
            solution = BinaryExpression.init(leftOperand: leftNode, _operator: _operator!, rightOperand: rightNode!)
        }
        
        return result.success(withNode: solution)
    }
    
    func ternaryOperation(function: () -> ParseResult, types: [TokenType]) -> ParseResult {
        let result = ParseResult()
        let leftNode = result.register(result: function())
        guard result.error == nil else { return result }

        if currentToken?.type == TokenType.question {
            let leftOperator = currentToken
            result.register()
            advance()
            
            let middleNode = result.register(result: function())
            guard result.error == nil else { return result }
            
            if currentToken?.type == TokenType.colon {
                let rightOperator = currentToken
                result.register()
                advance()
                
                let rightNode = result.register(result: function())
                guard result.error == nil else { return result }
                
                return result.success(withNode: TernaryExpression.init(leftOperand: leftNode!, leftOperator: leftOperator!, middleOperand: middleNode!, rightOperator: rightOperator!, rightOperand: rightNode!))
            }
            
            return result.failure(withError:
                                    InvalidSyntaxError(
                                        message: "':' expected.",
                                        initialPosition: currentToken?.initialPosition,
                                        finalPosition: currentToken?.finalPosition))
        }
        
        let node = result.register(result: binaryOperation(leftNode: leftNode!, function: logicalOperation, types: [TokenType.or, TokenType.xor]))
        guard result.error == nil else {
            return result.failure(withError:
                                    InvalidSyntaxError(
                                        message: "')', var, number, identifier, '+', '-', '!' or '(' expected.",
                                        initialPosition: currentToken?.initialPosition,
                                        finalPosition: currentToken?.finalPosition))
        }
        
        return result.success(withNode: node)
    }
    
}

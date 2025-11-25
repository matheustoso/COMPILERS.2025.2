import Foundation

public class Interpreter: Visitor {
    public func visit(node: Node, inContext context: Context) -> RuntimeResult {
        switch node {
        case is Statement:
            return visit(node: node as! Statement, inContext: context)
        case is TernaryExpression:
            return visit(node: node as! TernaryExpression, inContext: context)
        case is BinaryExpression:
            return visit(node: node as! BinaryExpression, inContext: context)
        case is UnaryExpression:
            return visit(node: node as! UnaryExpression, inContext: context)
        case is Operand:
            return visit(node: node as! Operand, inContext: context)
        case is AccessVariable:
            return visit(node: node as! AccessVariable, inContext: context)
        case is AttributionVariable:
            return visit(node: node as! AttributionVariable, inContext: context)
        case is Call:
            return visit(node: node as! Call, inContext: context)
        case is For:
            return visit(node: node as! For, inContext: context)
        default:
            return RuntimeResult.init().failure(withError: RuntimeError.init(message: "Node type not mapped", initialPosition: node.initialPosition, finalPosition: node.finalPosition))
        }
    }
    
    public func visit(node: For, inContext context: Context) -> RuntimeResult {
        let result = RuntimeResult.init()
        var elements: [Value] = []
        
        let initialValue = result.register(result: visit(node: node.initialIndex, inContext: context)).number!
        guard result.error == nil else { return result }
        
        let finalValue = result.register(result: visit(node: node.finalIndex, inContext: context)).number!
        guard result.error == nil else { return result }
        
        var increment = Number.init(value: 1)
        
        if let incrementNode = node.increment {
            increment = result.register(result: visit(node: incrementNode, inContext: context)).number!
            guard result.error == nil else { return result }
        }
        
        var i = initialValue.value
        
        var condition: Bool {
                if increment.value >= 0 {
                    return i < finalValue.value
                }
            return i > finalValue.value
        }
        
        while condition {
            context.symbols.put(key: node.name.value, withValue: Number.init(value: i))
            i += increment.value
            
            elements.append(result.register(result: visit(node: node.body, inContext: context)).value!)
            guard result.error == nil else { return result }
        }
        
        var solution: Value
        
        if node.nullReturn {
            solution = NumberConstants.null
        } else {
            solution = List.init(values: elements)
            solution.initialPosition = node.initialPosition
            solution.finalPosition = node.finalPosition
            solution.context = context
        }
        
        return result.success(withValue: solution)
    }
    
    public func visit(node: Statement, inContext context: Context) -> RuntimeResult {
        let result = RuntimeResult.init()
        var values: [Value] = []
        
        for valueNode in node.nodes {
            let value = result.register(result: visit(node: valueNode, inContext: context)).value
            guard result.error == nil else { return result }
            values.append(value!)
        }
        let list = List.init(values: values)
        list.initialPosition = node.initialPosition
        list.finalPosition = node.finalPosition
        list.context = context
        
        return result.success(withValue: list)
    }
    
    public func visit(node: TernaryExpression, inContext context: Context) -> RuntimeResult {
        let result = RuntimeResult.init()
        let left = result.register(result: visit(node: node.leftOperand, inContext: context)).number!
        let middle = result.register(result: visit(node: node.middleOperand, inContext: context)).number!
        let right = result.register(result: visit(node: node.rightOperand, inContext: context)).number!
        var solution: Value?
        
        if node.leftOperator.type == TokenType.question, node.rightOperator.type == TokenType.colon {
            solution = left.value != NumberConstants._false.value ? middle : right
            solution!.initialPosition = node.initialPosition 
            solution!.finalPosition = node.finalPosition

            return result.success(withValue: solution)
        }
        
        return result.failure(withError: RuntimeError.init(message: "Invalid expression", initialPosition: node.initialPosition, finalPosition: node.finalPosition))
    }
    
    public func visit(node: BinaryExpression, inContext context: Context) -> RuntimeResult {
        let result = RuntimeResult.init()
        let left = result.register(result: visit(node: node.leftOperand, inContext: context)).number!
        let right = result.register(result: visit(node: node.rightOperand, inContext: context)).number!
        var solution: Value?
        
        switch node._operator.type {
        case .plus:
            solution = result.register(result: left.sum(right)).value
        case .minus:
            solution = result.register(result: left.subtract(right)).value
        case .div:
            solution = result.register(result: left.divide(by: right)).value
        case .mul:
            solution = result.register(result: left.multiply(by: right)).value
        case .pow:
            solution = result.register(result: left.power(by: right)).value
        case .and:
            solution = result.register(result: left.and(right)).value
        case .or:
            solution = result.register(result: left.or(right)).value
        case .xor:
            solution = result.register(result: left.xor(right)).value
        case .equals:
            solution = result.register(result: left.equals(to: right)).value
        case .different:
            solution = result.register(result: left.different(from: right)).value
        case .larger:
            solution = result.register(result: left.larger(than: right)).value
        case .smaller:
            solution = result.register(result: left.smaller(than: right)).value
        case .largerEquals:
            solution = result.register(result: left.largerOrEqual(to: right)).value
        case .smallerEquals:
            solution = result.register(result: left.smallerOrEqual(to: right)).value
        default:
            return result.failure(withError: RuntimeError.init(message: "Invalid operator", initialPosition: node.initialPosition, finalPosition: node.finalPosition))
        }
        
        guard result.error == nil else { return result }
        
        solution!.initialPosition = node.initialPosition
        solution!.finalPosition = node.finalPosition
        
        return result.success(withValue: solution)
    }
    
    public func visit(node: UnaryExpression, inContext context: Context) -> RuntimeResult {
        let result = RuntimeResult.init()
        
        var solution = result.register(result: visit(node: node.operand, inContext: context)).number
        guard result.error == nil else { return result }
        
        if node._operator.type == TokenType.minus {
            solution = result.register(result: solution!.negate()).number
        } else if node._operator.type == TokenType.not {
            solution = result.register(result: solution!.not()).number
        }
        
        guard result.error == nil else { return result }
        
        solution!.initialPosition = node.initialPosition
        solution!.finalPosition = node.finalPosition
        
        return result.success(withValue: solution)
    }
    
    public func visit(node: Operand, inContext context: Context) -> RuntimeResult {
        let result = RuntimeResult.init()
        
        let solution = Number.init(value: node.token.realValue() as! Double)
        solution.initialPosition = node.initialPosition
        solution.finalPosition = node.finalPosition
        solution.context = context
        
        return result.success(withValue: solution)
    }
    
    public func visit(node: AccessVariable, inContext context: Context) -> RuntimeResult {
        let result = RuntimeResult.init()
        let name = node.name.value
        let value = context.symbols.get(fromKey: name)
        
        guard value != nil else {
            return result.failure(withError: RuntimeError.init(message: "Variable \(name) was not found in the context.", initialPosition: node.initialPosition, finalPosition: node.finalPosition))
        }
        var solution = value!.copy()
        solution.initialPosition = node.initialPosition
        solution.finalPosition = node.finalPosition
        solution.context = context
        
        return result.success(withValue: solution)
    }
    
    public func visit(node: AttributionVariable, inContext context: Context) -> RuntimeResult {
        let result = RuntimeResult.init()
        let name = node.name.value
        let value = result.register(result: visit(node: node.value, inContext: context)).number
        
        guard value != nil else {
            return result.failure(withError: RuntimeError.init(message: "Variable \(name) was not found in the context.", initialPosition: node.initialPosition, finalPosition: node.finalPosition))
        }
        
        context.symbols.put(key: name, withValue: value!)
        
        return result.success(withValue: value)
    }
    
    public func visit(node: Call, inContext context: Context) -> RuntimeResult {
        let result = RuntimeResult.init()
        var parameters: [Value] = []
        
        var function = result.register(result: visit(node: node.name, inContext: context)).value as? Function
        guard result.error == nil else { return result }
        function = function!.copy() as? Function
        function!.initialPosition = node.initialPosition
        function!.finalPosition = node.finalPosition
        
        for parameter in node.parameters {
            let param = result.register(result: visit(node: parameter, inContext: context)).value
            guard result.error == nil else { return result }
            parameters.append(param!)
        }
        
        var solution = result.register(result: function!.execute(withParameters: parameters)).number
        guard result.error == nil else { return result }
        solution = solution!.copy() as? Number
        solution!.initialPosition = node.initialPosition
        solution!.finalPosition = node.finalPosition
        solution!.context = context

        return result.success(withValue: solution)
    }
}

import Foundation

public enum FunctionConstants {
    public static let _if = Function(name: "if")
    public static let sum = Function(name: "sum")
    public static let avg = Function(name: "avg")
    public static let max = Function(name: "max")
    public static let min = Function(name: "min")
    public static let abs = Function(name: "abs")
    public static let sqrt = Function(name: "sqrt")
    public static let rand = Function(name: "rand")
    public static let ifNames = ["condition","true","false"]
    public static let sumNames = ["number","*"]
    public static let avgNames = ["number","*"]
    public static let maxNames = ["number","*"]
    public static let minNames = ["number","*"]
    public static let absNames = ["number"]
    public static let sqrtNames = ["number"]
    public static let randNames = ["maximum"]
}

public class Function: Value, CustomStringConvertible {
    public var description: String {
        return "<func \(self.name)>"
    }
    
    public var initialPosition: Position?
    public var finalPosition: Position?
    public var context: Context?
    let name: String
    
    public init(name: String) {
        self.name = name
    }
    
    public init(copiedFrom function: Function) {
        self.name = function.name
    }
    
    public func copy() -> Value {
        return Function.init(copiedFrom: self)
    }
    
    public func createNewContext() -> Context {
        let context = Context.init(name: self.name, parent: self.context, entry: self.initialPosition)
        if let symbols = context.parent?.symbols {
            context.symbols = symbols
        }
        return context
    }
    
    func checkParameters(names: [String], values: [Value]) -> RuntimeResult {
        if !names.contains("*") && values.count > names.count {
            return RuntimeResult.init().failure(withError: RuntimeError.init(message: "\(values.count-names.count) excess parameters.", initialPosition: self.initialPosition, finalPosition: self.finalPosition))
        }
        
        if values.count < names.count {
            return RuntimeResult.init().failure(withError: RuntimeError.init(message: "\(names.count-values.count) missing parameters.", initialPosition: self.initialPosition, finalPosition: self.finalPosition))
        }
        
        return RuntimeResult.init().success(withValue: nil)
    }

    func populateParameters(names: [String], values: [Value], context: Context) {
        var hasAnonymousParameters = false
        
        var j = 0
        for index in 0..<values.count {
            if(!hasAnonymousParameters && names[index] == "*") {
                hasAnonymousParameters = true
            }
            if(hasAnonymousParameters) {
                j+=1
            }
            let name = hasAnonymousParameters ? "*\(j)" : names[index]
            var value = values[index]
            value.context = context
            context.symbols.put(key: name, withValue: value)
        }
    }
    
    public func checkAndPopulateParameters(parameterNames names: [String], parameterValues values: [Value], context: Context) -> RuntimeResult {
        let result = RuntimeResult.init()
        result.register(result: checkParameters(names: names, values: values))
        guard result.error == nil else {
            return result
        }
        populateParameters(names: names, values: values, context: context)
        return result.success(withValue: nil)
    }
    
    public func execute(withParameters parameters: [Value]) -> RuntimeResult {
        let result = RuntimeResult.init()
        let context = createNewContext()
        switch self.name {
        case "if":
            result.register(result: checkAndPopulateParameters(parameterNames: FunctionConstants.ifNames, parameterValues: parameters, context: context))
            guard result.error == nil else {
                return result
            }
            let value = result.register(result: executeIf(context)).value
            guard result.error == nil else {
                return result
            }
            return result.success(withValue: value)
        case "sum":
            result.register(result: checkAndPopulateParameters(parameterNames: FunctionConstants.sumNames, parameterValues: parameters, context: context))
            guard result.error == nil else {
                return result
            }
            let value = result.register(result: executeSum(context, parameterCount: parameters.count)).value
            guard result.error == nil else {
                return result
            }
            return result.success(withValue: value)
        case "avg":
            result.register(result: checkAndPopulateParameters(parameterNames: FunctionConstants.avgNames, parameterValues: parameters, context: context))
            guard result.error == nil else {
                return result
            }
            let value = result.register(result: executeAvg(context, parameterCount: parameters.count)).value
            guard result.error == nil else {
                return result
            }
            return result.success(withValue: value)
        case "max":
            result.register(result: checkAndPopulateParameters(parameterNames: FunctionConstants.maxNames, parameterValues: parameters, context: context))
            guard result.error == nil else {
                return result
            }
            let value = result.register(result: executeMax(context, parameterCount: parameters.count)).value
            guard result.error == nil else {
                return result
            }
            return result.success(withValue: value)
        case "min":
            result.register(result: checkAndPopulateParameters(parameterNames: FunctionConstants.minNames, parameterValues: parameters, context: context))
            guard result.error == nil else {
                return result
            }
            let value = result.register(result: executeMin(context, parameterCount: parameters.count)).value
            guard result.error == nil else {
                return result
            }
            return result.success(withValue: value)
        case "abs":
            result.register(result: checkAndPopulateParameters(parameterNames: FunctionConstants.absNames, parameterValues: parameters, context: context))
            guard result.error == nil else {
                return result
            }
            let value = result.register(result: executeAbs(context)).value
            guard result.error == nil else {
                return result
            }
            return result.success(withValue: value)
        case "sqrt":
            result.register(result: checkAndPopulateParameters(parameterNames: FunctionConstants.sqrtNames, parameterValues: parameters, context: context))
            guard result.error == nil else {
                return result
            }
            let value = result.register(result: executeSqrt(context)).value
            guard result.error == nil else {
                return result
            }
            return result.success(withValue: value)
        case "rand":
            result.register(result: checkAndPopulateParameters(parameterNames: FunctionConstants.randNames, parameterValues: parameters, context: context))
            guard result.error == nil else {
                return result
            }
            let value = result.register(result: executeRand(context)).value
            guard result.error == nil else {
                return result
            }
            return result.success(withValue: value)
        default:
            break
        }
        return result.failure(withError: RuntimeError.init(message: "\(self.name) function not found.", initialPosition: self.initialPosition, finalPosition: self.finalPosition))
    }
    
    func executeIf(_ context: Context) -> RuntimeResult {
        let condition = context.symbols.get(fromKey: FunctionConstants.ifNames[0]) as! Number
        let _true = context.symbols.get(fromKey: FunctionConstants.ifNames[1]) as! Number
        let _false = context.symbols.get(fromKey: FunctionConstants.ifNames[2]) as! Number
        return RuntimeResult.init().success(withValue: condition.value == NumberConstants._true.value ? _true : _false)
    }
    
    func executeSum(_ context: Context, parameterCount: Int) -> RuntimeResult {
        let result = RuntimeResult.init()
        var sum = context.symbols.get(fromKey: FunctionConstants.sumNames[0]) as! Number
        for index in 1..<parameterCount {
            sum = result.register(result: sum.sum(context.symbols.get(fromKey: "\(FunctionConstants.sumNames[1])\(index)") as! Number)).number!
        }
        
        return result.success(withValue: sum)
    }
    
    func executeAvg(_ context: Context, parameterCount: Int) -> RuntimeResult {
        let result = RuntimeResult.init()
        var sum = context.symbols.get(fromKey: FunctionConstants.avgNames[0]) as! Number
        for index in 1..<parameterCount {
            sum = result.register(result: sum.sum(context.symbols.get(fromKey: "\(FunctionConstants.avgNames[1])\(index)") as! Number)).number!
        }
        let avg = result.register(result: sum.divide(by: Number.init(value: Double(parameterCount)))).number
        
        return result.success(withValue: avg)
    }
    
    func executeMax(_ context: Context, parameterCount: Int) -> RuntimeResult {
        let result = RuntimeResult.init()
        var max = context.symbols.get(fromKey: FunctionConstants.avgNames[0]) as! Number
        var temp: Number
        for index in 1..<parameterCount {
            temp = context.symbols.get(fromKey: "\(FunctionConstants.avgNames[1])\(index)") as! Number
            if result.register(result: max.smaller(than: temp)).number?.value == NumberConstants._true.value {
                max = temp
            }
        }

        return result.success(withValue: max)
    }
    
    func executeMin(_ context: Context, parameterCount: Int) -> RuntimeResult {
        let result = RuntimeResult.init()
        var min = context.symbols.get(fromKey: FunctionConstants.avgNames[0]) as! Number
        var temp: Number
        for index in 1..<parameterCount {
            temp = context.symbols.get(fromKey: "\(FunctionConstants.avgNames[1])\(index)") as! Number
            if result.register(result: min.larger(than: temp)).number?.value == NumberConstants._true.value {
                min = temp
            }
        }

        return result.success(withValue: min)
    }
    
    func executeAbs(_ context: Context) -> RuntimeResult {
        let result = RuntimeResult.init()
        let number = context.symbols.get(fromKey: FunctionConstants.absNames[0]) as! Number
        return result.success(withValue: Number.init(value: abs(number.value)))
    }
    
    func executeSqrt(_ context: Context) -> RuntimeResult {
        let result = RuntimeResult.init()
        let number = context.symbols.get(fromKey: FunctionConstants.sqrtNames[0]) as! Number
        let sqrt = result.register(result: number.power(by: Number.init(value: 0.5))).value
        guard result.error == nil else {
            return result.failure(withError: RuntimeError.init(message: "Invalid root.", initialPosition: number.initialPosition, finalPosition: number.finalPosition))
        }
        return result.success(withValue: sqrt)
    }
    
    func executeRand(_ context: Context) -> RuntimeResult {
        let result = RuntimeResult.init()
        let maximum = context.symbols.get(fromKey: FunctionConstants.randNames[0]) as! Number
        let multiplier = Number.init(value: Double.random(in: 0...1))
        let random = result.register(result: maximum.multiply(by: multiplier)).number
        return result.success(withValue: random)
    }
}

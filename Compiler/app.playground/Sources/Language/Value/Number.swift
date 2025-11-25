import Foundation

public enum NumberConstants {
    public static let _false: Number = .init(value: 0, isBoolean: true)
    public static let _true: Number = .init(value: 1, isBoolean: true)
    public static let null: Number = .init(value: 0)
}

public class Number: Value, CustomStringConvertible {
    public var description: String {
        var str = "\(self.value)"
        if self.isBoolean {
            str = self.value == 0 ? "false" : "true"
        }
        return str
    }
    
    public var initialPosition: Position?
    public var finalPosition: Position?
    public var context: Context?
    public var value: Double
    public var isBoolean: Bool
    
    public init(value: Double) {
        self.value = value
        self.isBoolean = false
    }
    
    public init(value: Double, isBoolean: Bool) {
        self.value = value
        self.isBoolean = isBoolean
    }
    
    public init(copiedFrom number: Number) {
        self.initialPosition = number.initialPosition
        self.finalPosition = number.finalPosition
        self.context = number.context
        self.value = number.value
        self.isBoolean = number.isBoolean
    }
    
    public func copy() -> Value {
        return Number(copiedFrom: self)
    }
    
    public func sum(_ number: Number) -> RuntimeResult {
        return RuntimeResult().success(withValue: Number(value: self.value + number.value))
    }
    
    public func subtract(_ number: Number) -> RuntimeResult {
        return RuntimeResult().success(withValue: Number(value: self.value - number.value))
    }
    
    public func multiply(by number: Number) -> RuntimeResult {
        return RuntimeResult().success(withValue: Number(value: self.value * number.value))
    }
    
    public func divide(by number: Number) -> RuntimeResult {
        return RuntimeResult().success(withValue: Number(value: self.value / number.value))
    }
    
    public func power(by number: Number) -> RuntimeResult {
        let result = pow(self.value, number.value)
        if result.isNaN {
            return RuntimeResult().failure(withError: RuntimeError(message: "Invalid power. Resulted in NaN.", initialPosition: self.initialPosition!, finalPosition: number.finalPosition!))
        }
        return RuntimeResult().success(withValue: Number(value: result))
    }
    
    public func equals(to number: Number) -> RuntimeResult {
        return RuntimeResult().success(withValue: self.value == number.value ? NumberConstants._true : NumberConstants._false)
    }
    
    public func different(from number: Number) -> RuntimeResult {
        return RuntimeResult().success(withValue: self.value != number.value ? NumberConstants._true : NumberConstants._false)
    }
    
    public func larger(than number: Number) -> RuntimeResult {
        return RuntimeResult().success(withValue: self.value > number.value ? NumberConstants._true : NumberConstants._false)
    }
    
    public func smaller(than number: Number) -> RuntimeResult {
        return RuntimeResult().success(withValue: self.value < number.value ? NumberConstants._true : NumberConstants._false)
    }
    
    public func largerOrEqual(to number: Number) -> RuntimeResult {
        return RuntimeResult().success(withValue: self.value >= number.value ? NumberConstants._true : NumberConstants._false)
    }
    
    public func smallerOrEqual(to number: Number) -> RuntimeResult {
        return RuntimeResult().success(withValue: self.value <= number.value ? NumberConstants._true : NumberConstants._false)
    }
    
    public func and(_ number: Number) -> RuntimeResult {
        return RuntimeResult().success(withValue:
            self.value != NumberConstants._false.value && number.value != NumberConstants._false.value
                ? NumberConstants._true : NumberConstants._false)
    }
    
    public func or(_ number: Number) -> RuntimeResult {
        return RuntimeResult().success(withValue:
            self.value != NumberConstants._false.value || number.value != NumberConstants._false.value
                ? NumberConstants._true : NumberConstants._false)
    }
    
    public func xor(_ number: Number) -> RuntimeResult {
        return RuntimeResult().success(withValue:
            self.value == NumberConstants._false.value && number.value != NumberConstants._false.value
                || self.value != NumberConstants._false.value && number.value == NumberConstants._false.value
                ? NumberConstants._true : NumberConstants._false)
    }
    
    public func not() -> RuntimeResult {
        return RuntimeResult().success(withValue: self.value == NumberConstants._false.value ? NumberConstants._true : NumberConstants._false)
    }
    
    public func negate() -> RuntimeResult {
        return RuntimeResult().success(withValue: Number(value: -self.value))
    }

}

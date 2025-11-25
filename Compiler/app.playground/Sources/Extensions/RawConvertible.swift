import Foundation

public protocol RawConvertible {
    init()
}

extension Double: RawConvertible {}
extension String: RawConvertible {}

import Foundation

public class Context {
    var name: String
    var entry: Position?
    var parent: Context?
    var symbols: Symbols
    
    public init(name: String) {
        self.name = name
        symbols = Symbols([:])
    }
    
    public init(name: String, parent: Context?) {
        self.name = name
        self.parent = parent
        symbols = Symbols([:])
    }
    
    public init(name: String, entry: Position?) {
        self.name = name
        self.entry = entry
        symbols = Symbols([:])
    }
    
    public init(name: String, parent: Context?, entry: Position?) {
        self.name = name
        self.parent = parent
        self.entry = entry
        symbols = Symbols([:])
    }
}

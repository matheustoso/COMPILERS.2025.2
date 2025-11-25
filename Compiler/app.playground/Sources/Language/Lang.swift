import Foundation

public class Lang {
    static var globalSymbols = Symbols.init([:])
    static var lineCount = 1
    
    public static func compile(text: String, fileName: String) {
        guard !text.isEmpty else {
            print("Source code empty\n")
            return
        }
            
        //Update grammar
        lineCount = 1
        let globalContext = Context.init(name: "Lang")
        globalSymbols.put(key: "true", withValue: NumberConstants._true)
        globalSymbols.put(key: "false", withValue: NumberConstants._false)
        globalSymbols.put(key: "if", withValue: FunctionConstants._if)
        globalSymbols.put(key: "sum", withValue: FunctionConstants.sum)
        globalSymbols.put(key: "avg", withValue: FunctionConstants.avg)
        globalSymbols.put(key: "max", withValue: FunctionConstants.max)
        globalSymbols.put(key: "min", withValue: FunctionConstants.min)
        globalSymbols.put(key: "abs", withValue: FunctionConstants.abs)
        globalSymbols.put(key: "sqrt", withValue: FunctionConstants.sqrt)
        globalSymbols.put(key: "rand", withValue: FunctionConstants.rand)
        globalContext.symbols = globalSymbols
        
        //Lexer generates tokens
        let lexerResult = Lexer.init(text: text, fileName: fileName).tokenize()
        guard lexerResult.error == nil else {
            print("💢\tLEXER ERROR \t\t->\t\(lexerResult.error!)")
            return
        }
        print("💬\tLEXER \t\t\(lineCount):->\t\(lexerResult.data!)")

        //Parser generates tree
        let parserResult = Parser.init(tokens: lexerResult.data!).parse()
        guard parserResult.error == nil else {
            print("💢\tPARSER ERROR \t->\t\(parserResult.error!)")
            return
        }
        let statements = parserResult.data! as? Statement
        for (index, line) in statements!.nodes.enumerated() {
            print("🌲\tPARSER \t\t\(index+1):->\t\(line)")
        }
        
        //Interpreter solves tree
        let interpreterResult = parserResult.data!.accept(visitor: Interpreter.init(), inContext: globalContext)
        guard interpreterResult.error == nil else {
            print("💢\tINTERPRETER ERROR ->\t\(interpreterResult.error!)")
            return
        }
        let list = interpreterResult.data! as? List
        for (index, line) in list!.values.enumerated() {
            print("👁️‍🗨️\tINTERPRETER \(index+1):->\t\(line)")
        }
    }
}

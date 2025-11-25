import Cocoa

//Executes the code written on the 'shell' multiline string literal.
print("FROM CODE    ======================================================================\\n")

let shell =
"""
var end
"""

Lang.compile(text: shell, fileName: "shell")

//Compiles the src.txt file on the resources playground package
print("FROM FILE    ======================================================================\n")

let fileName = "src"

guard let fileUrl = Bundle.main.path(forResource:fileName, ofType: ".txt") else {
    preconditionFailure("Source code missing. src.txt resource expected.")
} 

let fileText = try String(contentsOfFile: fileUrl, encoding: .utf8)

Lang.compile(text: fileText, fileName: fileName)


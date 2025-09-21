using System.Text;
using Lexer.Application;

string filepath;
string content;

Console.WriteLine("Lexer:\n\t1 - Read from shell\n\t2 - Read from file\n\tAny other key to exit");
var command = Console.ReadLine();

if (command == "1" || command == "2")
{
    if (command == "1")
    {
        Console.WriteLine("Enter code to analyze:");

        filepath = "<stdin>";
        content = Console.ReadLine() ?? string.Empty;
    }
    else
    {
        while (true)
        {
            Console.WriteLine("Enter filepath:");
            filepath = Console.ReadLine() ?? string.Empty;

            if (File.Exists(filepath)) break;

            Console.WriteLine("File not found.");
        }

        using StreamReader streamReader = new(filepath, Encoding.UTF8);
        content = streamReader.ReadToEnd();
    }

    var result = LexerService.Analyze(filepath, content);

    foreach (var token in result.Tokens)
        Console.WriteLine(token.ToString());

    if (!result.IsValid())
        Console.WriteLine(result.Error?.ToString());
}

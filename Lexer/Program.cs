using System.Text;
using Lexer.Application;

string filepath;
string content;
var command = "0";
var validCommands = new string[] { "1", "2" };

while (command != "3")
{
    Console.WriteLine("Lexer:\n\t1 - Read from shell\n\t2 - Read from file\n\t3 - Exit");
    command = Console.ReadLine();

    if (validCommands.Contains(command))
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
    } else if (command == "3") 
        Console.WriteLine("Exiting.");
    else
        Console.WriteLine("Invalid selection.");
    
}

namespace Lexer.Domain.Entities.Result
{
    public class LexerError : Exception
    {
        public Context Start { get; set; }
        public Context End { get; set; }

        public LexerError(Context start, Context end, string message) : base(message)
        {
            Start = start;
            End = end;
        }

        public override string ToString()
        {
            return $"""
                Lexer Error on file {Start.FileName}: {Message}
                    Start:
                        Line: {Start.Line + 1}
                        Column: {Start.Column + 1}
                    End:
                        Line: {End.Line + 1}
                        Column: {End.Column}
                """;
        }
    }
}

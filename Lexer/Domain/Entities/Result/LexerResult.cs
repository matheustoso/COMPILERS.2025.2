namespace Lexer.Domain.Entities.Result
{
    public class LexerResult
    {
        public IEnumerable<Token> Tokens { get; set; }
        public LexerError? Error { get; set; }

        public LexerResult(IEnumerable<Token> tokens, LexerError? error = null)
        {
            Tokens = tokens;
            Error = error;
        }

        public bool IsValid() => Error is null;

        public override string ToString()
        {
            var str = string.Empty;
            foreach (var token in Tokens)
                str += token.ToString() + "\n";
            return str;
        }
    }
}

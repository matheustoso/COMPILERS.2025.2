using System.Text.RegularExpressions;
using Lexer.Domain.Enum;

namespace Lexer.Domain.Entities
{
    public class TokenType
    {
        public Regex Pattern { get; set; }
        public TokenTypeValue Value { get; set; }

        public TokenType(Regex pattern, TokenTypeValue value)
        {
            Pattern = pattern;
            Value = value;
        }

        public TokenType(TokenTypeValue value)
        {
            Pattern = new Regex(string.Empty);
            Value = value;
        }
    }
}

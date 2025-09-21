using Lexer.Domain.Constants;
using Lexer.Domain.Enum;

namespace Lexer.Domain.Entities
{
    public class Token
    {
        public TokenType Type { get; set; }
        public string Attribute { get; set; }

        public Token(TokenType type, string attribute)
        {
            Type = type;
            Attribute = attribute;
        }

        public Token(TokenType type)
        {
            Type = type;
            Attribute = string.Empty;
        }

        public override string ToString()
        {
            var value = Attribute != string.Empty
                ? Attribute
                : Type.Value switch
                {
                    TokenTypeValue.ASSIGN => Operators.Assign,
                    TokenTypeValue.EQUAL => Operators.Equal,
                    TokenTypeValue.NOT_EQUAL => Operators.NotEqual,
                    TokenTypeValue.LARGER => Operators.Larger,
                    TokenTypeValue.LARGER_EQUAL => Operators.LargerEqual,
                    TokenTypeValue.SMALLER => Operators.Smaller,
                    TokenTypeValue.SMALLER_EQUAL => Operators.SmallerEqual,
                    TokenTypeValue.ADD => Operators.Add,
                    TokenTypeValue.SUBTRACT => Operators.Subtract,
                    TokenTypeValue.DIVIDE => Operators.Divide,
                    TokenTypeValue.MULTIPLY => Operators.Multiply,
                    TokenTypeValue.AND => Operators.And,
                    TokenTypeValue.OR => Operators.Or,
                    TokenTypeValue.NOT => Operators.Not,
                    TokenTypeValue.LEFT_PARENTHESIS => Delimiters.LeftParenthesis,
                    TokenTypeValue.RIGHT_PARENTHESIS => Delimiters.RightParenthesis,
                    TokenTypeValue.LEFT_BRACE => Delimiters.LeftBrace,
                    TokenTypeValue.RIGHT_BRACE => Delimiters.RightBrace,
                    TokenTypeValue.SEMICOLON => Delimiters.Semicolon,
                    TokenTypeValue.ILLEGAL => TokenTypeValue.ILLEGAL.ToString(),
                    _ => string.Empty
                };

            return $"{Type.Value}   ->  {value}";
        }
    }
}

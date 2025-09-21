using Lexer.Domain.Entities;

namespace Lexer.Domain.ValueObjects
{
    public class Tokens
    {
        public static readonly Token Assign = new(TokenTypes.Assign);
        public static readonly Token Equal = new(TokenTypes.Equal);
        public static readonly Token NotEqual = new(TokenTypes.NotEqual);
        public static readonly Token Larger = new(TokenTypes.Larger);
        public static readonly Token LargerEqual = new(TokenTypes.LargerEqual);
        public static readonly Token Smaller = new(TokenTypes.Smaller);
        public static readonly Token SmallerEqual = new(TokenTypes.SmallerEqual);
        public static readonly Token Add = new(TokenTypes.Add);
        public static readonly Token Subtract = new(TokenTypes.Subtract);
        public static readonly Token Divide = new(TokenTypes.Divide);
        public static readonly Token Multiply = new(TokenTypes.Multiply);
        public static readonly Token And = new(TokenTypes.And);
        public static readonly Token Or = new(TokenTypes.Or);
        public static readonly Token Not = new(TokenTypes.Not);

        public static readonly Token LeftParenthesis = new(TokenTypes.LeftParenthesis);
        public static readonly Token RightParenthesis = new(TokenTypes.RightParenthesis);
        public static readonly Token LeftBrace = new(TokenTypes.LeftBrace);
        public static readonly Token RightBrace = new(TokenTypes.RightBrace);
        public static readonly Token Semicolon = new(TokenTypes.Semicolon);

        public static readonly Token Empty = new(TokenTypes.Empty);
        public static readonly Token NewLine = new(TokenTypes.NewLine);
    }
}

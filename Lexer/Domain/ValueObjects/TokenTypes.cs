using Lexer.Domain.Constants;
using Lexer.Domain.Entities;
using Lexer.Domain.Enum;

namespace Lexer.Domain.ValueObjects
{
    public class TokenTypes
    {
        public static readonly TokenType Keyword = new(Patterns.Keyword(), TokenTypeValue.KEYWORD);
        public static readonly TokenType Id = new(Patterns.Id(), TokenTypeValue.ID);

        #region Constants
        public static readonly TokenType Decimal = new(Patterns.Decimal(), TokenTypeValue.DECIMAL);
        public static readonly TokenType Int = new(Patterns.Int(), TokenTypeValue.INT);
        public static readonly TokenType String = new(Patterns.String(), TokenTypeValue.STRING);
        #endregion

        #region Operators
        public static readonly TokenType Assign = new(Patterns.Assign(), TokenTypeValue.ASSIGN);
        public static readonly TokenType Equal = new(Patterns.Equal(), TokenTypeValue.EQUAL);
        public static readonly TokenType NotEqual = new(Patterns.NotEqual(), TokenTypeValue.NOT_EQUAL);
        public static readonly TokenType Larger = new(Patterns.Larger(), TokenTypeValue.LARGER);
        public static readonly TokenType LargerEqual = new(Patterns.LargerEqual(), TokenTypeValue.LARGER_EQUAL);
        public static readonly TokenType Smaller = new(Patterns.Smaller(), TokenTypeValue.SMALLER);
        public static readonly TokenType SmallerEqual = new(Patterns.SmallerEqual(), TokenTypeValue.SMALLER_EQUAL);
        public static readonly TokenType Add = new(Patterns.Add(), TokenTypeValue.ADD);
        public static readonly TokenType Subtract = new(Patterns.Subtract(), TokenTypeValue.SUBTRACT);
        public static readonly TokenType Divide = new(Patterns.Divide(), TokenTypeValue.DIVIDE);
        public static readonly TokenType Multiply = new(Patterns.Multiply(), TokenTypeValue.MULTIPLY);
        public static readonly TokenType And = new(Patterns.And(), TokenTypeValue.AND);
        public static readonly TokenType Or = new(Patterns.Or(), TokenTypeValue.OR);
        public static readonly TokenType Not = new(Patterns.Not(), TokenTypeValue.NOT);
        #endregion

        #region Delimiters
        public static readonly TokenType LeftParenthesis = new(Patterns.LeftParenthesis(), TokenTypeValue.LEFT_PARENTHESIS);
        public static readonly TokenType RightParenthesis = new(Patterns.RightParenthesis(), TokenTypeValue.RIGHT_PARENTHESIS);
        public static readonly TokenType LeftBrace = new(Patterns.LeftBrace(), TokenTypeValue.LEFT_BRACE);
        public static readonly TokenType RightBrace = new(Patterns.RightBrace(), TokenTypeValue.RIGHT_BRACE);
        public static readonly TokenType Semicolon = new(Patterns.Semicolon(), TokenTypeValue.SEMICOLON);
        #endregion

        #region Whitespace
        public static readonly TokenType Empty = new(Patterns.Empty(), TokenTypeValue.EMPTY);
        public static readonly TokenType NewLine = new(Patterns.NewLine(), TokenTypeValue.NEW_LINE);
        public static readonly TokenType EndOfFile = new(TokenTypeValue.END_OF_FILE);
        #endregion
    }
}

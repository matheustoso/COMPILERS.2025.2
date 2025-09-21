namespace Lexer.Domain.Enum
{
    public enum TokenTypeValue
    {
        ILLEGAL,
        KEYWORD,
        ID,

        #region Constants
        DECIMAL,
        INT,
        STRING,
        #endregion

        #region Operators
        ASSIGN,
        EQUAL,
        NOT_EQUAL,
        LARGER,
        LARGER_EQUAL,
        SMALLER,
        SMALLER_EQUAL,
        ADD,
        SUBTRACT,
        DIVIDE,
        MULTIPLY,
        AND,
        OR,
        NOT,
        #endregion

        #region Delimiters
        LEFT_PARENTHESIS,
        RIGHT_PARENTHESIS,
        LEFT_BRACE,
        RIGHT_BRACE,
        SEMICOLON,
        #endregion

        #region Whitespace
        EMPTY,
        NEW_LINE,
        END_OF_FILE
        #endregion
    }
}

using System.Text.RegularExpressions;

namespace Lexer.Domain.Constants
{
    internal static partial class Patterns
    {
        [GeneratedRegex(@"^(if|else|while|for|int|decimal|string|void|null|return|true|false)$")]
        internal static partial Regex Keyword();

        [GeneratedRegex(@"^([a-zA-Z_][a-zA-Z0-9_]*)$")]
        internal static partial Regex Id();


        #region Constants
        [GeneratedRegex(@"^([0-9]+\.[0-9]+)$")]
        internal static partial Regex Decimal();
        [GeneratedRegex(@"^([0-9]+)$")]
        internal static partial Regex Int();
        [GeneratedRegex(@"^(""([^\\""]|\\.)*"")$")]
        internal static partial Regex String();
        #endregion

        #region Operators
        [GeneratedRegex($@"^({Operators.Assign})$")]
        internal static partial Regex Assign();

        [GeneratedRegex($@"^({Operators.Equal})$")]
        internal static partial Regex Equal();

        [GeneratedRegex($@"^({Operators.NotEqual})$")]
        internal static partial Regex NotEqual();

        [GeneratedRegex($@"^({Operators.Larger})$")]
        internal static partial Regex Larger();

        [GeneratedRegex($@"^({Operators.LargerEqual})$")]
        internal static partial Regex LargerEqual();

        [GeneratedRegex($@"^({Operators.Smaller})$")]
        internal static partial Regex Smaller();

        [GeneratedRegex($@"^({Operators.SmallerEqual})$")]
        internal static partial Regex SmallerEqual();

        [GeneratedRegex($@"^(\{Operators.Add})$")]
        internal static partial Regex Add();

        [GeneratedRegex($@"^({Operators.Subtract})$")]
        internal static partial Regex Subtract();

        [GeneratedRegex($@"^({Operators.Divide})$")]
        internal static partial Regex Divide();

        [GeneratedRegex($@"^(\{Operators.Multiply})$")]
        internal static partial Regex Multiply();

        [GeneratedRegex($@"^({Operators.And})$")]
        internal static partial Regex And();

        [GeneratedRegex($@"^(\{Operators.Or})$")]
        internal static partial Regex Or();

        [GeneratedRegex($@"^({Operators.Not})$")]
        internal static partial Regex Not();
        #endregion

        #region Delimiters
        [GeneratedRegex($@"^(\{Delimiters.LeftParenthesis})$")]
        internal static partial Regex LeftParenthesis();

        [GeneratedRegex($@"^(\{Delimiters.RightParenthesis})$")]
        internal static partial Regex RightParenthesis();

        [GeneratedRegex($@"^({Delimiters.LeftBrace})$")]
        internal static partial Regex LeftBrace();

        [GeneratedRegex($@"^({Delimiters.RightBrace})$")]
        internal static partial Regex RightBrace();

        [GeneratedRegex($@"^({Delimiters.Semicolon})$")]
        internal static partial Regex Semicolon();

        [GeneratedRegex($@"^({StringConstants.StringQuote})$")]
        internal static partial Regex StringQuote();
        #endregion

        #region Whitespace
        [GeneratedRegex(@"^([ \t\r])$")]
        internal static partial Regex Empty();

        [GeneratedRegex(@"^(\n)$")]
        internal static partial Regex NewLine();
        #endregion
    }
}

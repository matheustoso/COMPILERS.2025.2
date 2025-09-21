using Lexer.Domain.Constants;
using Lexer.Domain.Entities;
using Lexer.Domain.Entities.Result;
using Lexer.Domain.ValueObjects;

namespace Lexer.Application
{
    public static class LexerService
    {
        public static LexerResult Analyze(string fileName, string content)
        {
            IEnumerable<Token> tokens = new List<Token>();

            try
            {
                var context = new Context(-1, 0, -1, fileName);
                var current = NextChar(content, context);

                //Match de Padrões
                while (current.HasValue)
                {
                    if (Patterns.Empty().IsMatch(current.Value.ToString()))
                        current = NextChar(content, context);

                    else if (Patterns.NewLine().IsMatch(current.Value.ToString()))
                        (tokens, current) = ResolveToken(Tokens.NewLine, content, context, current.Value, tokens);

                    else if (Patterns.Id().IsMatch(current.Value.ToString()))
                        (tokens, current) = ResolveIdOrKeyword(content, context, current.Value, tokens);

                    else if (Patterns.Int().IsMatch(current.Value.ToString()))
                        (tokens, current) = ResolveIntOrDecimal(content, context, current.Value, tokens);

                    else if (Patterns.StringQuote().IsMatch(current.Value.ToString()))
                        (tokens, current) = ResolveString(content, context, current.Value, tokens);

                    else if (Patterns.Assign().IsMatch(current.Value.ToString()))
                        (tokens, current) = ResolveAssignOrEqual(content, context, current.Value, tokens);

                    else if (Patterns.Not().IsMatch(current.Value.ToString()))
                        (tokens, current) = ResolveNotOrNotEqual(content, context, current.Value, tokens);

                    else if (Patterns.Larger().IsMatch(current.Value.ToString()))
                        (tokens, current) = ResolveLargerOrLargerEqual(content, context, current.Value, tokens);

                    else if (Patterns.Smaller().IsMatch(current.Value.ToString()))
                        (tokens, current) = ResolveSmallerOrSmallerEqual(content, context, current.Value, tokens);

                    else if (Patterns.Add().IsMatch(current.Value.ToString()))
                        (tokens, current) = ResolveToken(Tokens.Add, content, context, current.Value, tokens);

                    else if (Patterns.Subtract().IsMatch(current.Value.ToString()))
                        (tokens, current) = ResolveToken(Tokens.Subtract, content, context, current.Value, tokens);

                    else if (Patterns.Divide().IsMatch(current.Value.ToString()))
                        (tokens, current) = ResolveToken(Tokens.Divide, content, context, current.Value, tokens);

                    else if (Patterns.Multiply().IsMatch(current.Value.ToString()))
                        (tokens, current) = ResolveToken(Tokens.Multiply, content, context, current.Value, tokens);

                    else if (Patterns.And().IsMatch(current.Value.ToString()))
                        (tokens, current) = ResolveToken(Tokens.And, content, context, current.Value, tokens);

                    else if (Patterns.Or().IsMatch(current.Value.ToString()))
                        (tokens, current) = ResolveToken(Tokens.Or, content, context, current.Value, tokens);

                    else if (Patterns.LeftParenthesis().IsMatch(current.Value.ToString()))
                        (tokens, current) = ResolveToken(Tokens.LeftParenthesis, content, context, current.Value, tokens);

                    else if (Patterns.RightParenthesis().IsMatch(current.Value.ToString()))
                        (tokens, current) = ResolveToken(Tokens.RightParenthesis, content, context, current.Value, tokens);

                    else if (Patterns.LeftBrace().IsMatch(current.Value.ToString()))
                        (tokens, current) = ResolveToken(Tokens.LeftBrace, content, context, current.Value, tokens);

                    else if (Patterns.RightBrace().IsMatch(current.Value.ToString()))
                        (tokens, current) = ResolveToken(Tokens.RightBrace, content, context, current.Value, tokens);

                    else if (Patterns.Semicolon().IsMatch(current.Value.ToString()))
                        (tokens, current) = ResolveToken(Tokens.Semicolon, content, context, current.Value, tokens);

                    else
                        throw new LexerError(context, context, ErrorMessages.ILLEGAL_CHAR);
                }

                return new(tokens);
            }
            catch (LexerError error)
            {
                return new(tokens, error);
            }

        }

        private static (IEnumerable<Token>, char?) ResolveIdOrKeyword(string content, Context context, char current, IEnumerable<Token> tokens)
        {
            var lexeme = current.ToString();
            char? nextChar;

            while (true)
            {
                nextChar = NextChar(content, context, current);

                if (!nextChar.HasValue || !TokenTypes.Id.Pattern.IsMatch(lexeme + nextChar)) 
                    break;

                lexeme += nextChar;
            };

            var tokenType = TokenTypes.Keyword.Pattern.IsMatch(lexeme)
                ? TokenTypes.Keyword
                : TokenTypes.Id;

            return (tokens.Append(new(tokenType, lexeme)), nextChar);
        }

        private static (IEnumerable<Token> tokens, char? current) ResolveIntOrDecimal(string content, Context context, char current, IEnumerable<Token> tokens)
        {
            var startContext = context.Copy();

            char? nextChar = NextChar(content, context, current);
            var lexeme = current.ToString();
            var isDecimal = false;

            while (nextChar.HasValue && (Char.IsNumber(nextChar.Value) || nextChar.ToString() == NumberConstants.DecimalSeparator))
            {
                if (nextChar.ToString() == NumberConstants.DecimalSeparator)
                    isDecimal = true;

                lexeme += nextChar;
                nextChar = NextChar(content, context, current);
            }

            if (isDecimal && !TokenTypes.Decimal.Pattern.IsMatch(lexeme))
                throw new LexerError(startContext, context, ErrorMessages.TOO_MANY_DECIMAL_SEPARATORS);

            var tokenType = isDecimal
                ? TokenTypes.Decimal
                : TokenTypes.Int;

            return (tokens.Append(new(tokenType, lexeme)), nextChar);
        }

        private static (IEnumerable<Token> tokens, char? current) ResolveString(string content, Context context, char current, IEnumerable<Token> tokens)
        {
            var startContext = context.Copy();

            var lexeme = current.ToString();
            char? nextChar = NextChar(content, context, current);

            while (nextChar.ToString() != StringConstants.StringQuote || lexeme[^1].ToString() == StringConstants.StringEscape)
            {
                lexeme += nextChar;
                nextChar = NextChar(content, context, current);

                if (!nextChar.HasValue) 
                    throw new LexerError(startContext, context, ErrorMessages.UNTERMINATED_STRING);
            };

            lexeme += nextChar;
            if (!TokenTypes.String.Pattern.IsMatch(lexeme))
                throw new LexerError(startContext, context, ErrorMessages.UNTERMINATED_STRING);

            return (tokens.Append(new(TokenTypes.String, lexeme)), NextChar(content, context, current));
        }

        private static (IEnumerable<Token> tokens, char? current) ResolveAssignOrEqual(string content, Context context, char current, IEnumerable<Token> tokens)
        {
            var lexeme = current.ToString();
            char? nextChar = NextChar(content, context, current);

            if (TokenTypes.Equal.Pattern.IsMatch(lexeme + nextChar))
                return (tokens.Append(Tokens.Equal), NextChar(content, context, current));

            return (tokens.Append(Tokens.Assign), nextChar);
        }

        private static (IEnumerable<Token> tokens, char? current) ResolveNotOrNotEqual(string content, Context context, char current, IEnumerable<Token> tokens)
        {
            var lexeme = current.ToString();
            char? nextChar = NextChar(content, context, current);

            if (TokenTypes.NotEqual.Pattern.IsMatch(lexeme + nextChar))
                return (tokens.Append(Tokens.NotEqual), NextChar(content, context, current));

            return (tokens.Append(Tokens.Not), nextChar);
        }

        private static (IEnumerable<Token> tokens, char? current) ResolveLargerOrLargerEqual(string content, Context context, char current, IEnumerable<Token> tokens)
        {
            var lexeme = current.ToString();
            char? nextChar = NextChar(content, context, current);

            if (TokenTypes.LargerEqual.Pattern.IsMatch(lexeme + nextChar))
                return (tokens.Append(Tokens.LargerEqual), NextChar(content, context, current));

            return (tokens.Append(Tokens.Larger), nextChar);
        }

        private static (IEnumerable<Token> tokens, char? current) ResolveSmallerOrSmallerEqual(string content, Context context, char current, IEnumerable<Token> tokens)
        {
            var lexeme = current.ToString();
            char? nextChar = NextChar(content, context, current);

            if (TokenTypes.SmallerEqual.Pattern.IsMatch(lexeme + nextChar))
                return (tokens.Append(Tokens.SmallerEqual), NextChar(content, context, current));

            return (tokens.Append(Tokens.Smaller), nextChar);
        }

        private static (IEnumerable<Token> tokens, char? current) ResolveToken(Token token, string content, Context context, char current, IEnumerable<Token> tokens)
            => (tokens.Append(token), NextChar(content, context, current));

        private static char? NextChar(string content, Context context, char? current = null)
        {
            context.Advance(current);
            return context.Index < content.Length ? content[context.Index] : null;
        }
    }
}

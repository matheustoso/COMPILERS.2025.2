using Lexer.Domain.ValueObjects;

namespace Lexer.Domain.Entities
{
    public class Context
    {
        public int Index { get; set; } 
        public int Line { get; set; } 
        public int Column { get; set; }
        public string FileName { get; set; }

        public Context(int index, int line, int column, string fileName)
        {
            Index = index;
            Line = line;
            Column = column;
            FileName = fileName;
        }

        public void Advance(char? current)
        {
            Index++;

            if (current is '\n')
            {
                Line++;
                Column = 0;
            } else
            {
                Column++;
            }
        }

        public Context Copy() => new(Index, Line, Column, FileName);
    }
}

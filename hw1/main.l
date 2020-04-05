%top{
    #include <string.h>
    int iterator = 0;
    int line_number = 1;
    char input_line[256];
    void print(int token);
    void print_error();

    typedef enum TYPES {
	    DATATYPE_INT = 1, DATATYPE_DOUBLE, DATATYPE_BOOL, DATATYPE_CHAR = 4
    } TYPES;

    typedef enum KEYWORDS {
        VOID = 5, CONST, KEY_NULL, FOR, DO, 
        WHILE, BREAK, CONTINUE, IF, ELSE, 
        RETURN, STRUCT, SWITCH, CASE, DEFAULT = 19
    } KEYWORDS;

    typedef enum OPERATORS {
        PLUS = 20, MINUS, MULTIPLE, DIVIDE, MOD, 
        TWO_MINUS, TWO_PLUS, LESS, LESS_THAN, GREATER, 
        GREATER_THAN, SAME, NOT_EQUAL, EQUAL, AND, 
        OR, NOT, BI_AND, BI_OR, BI_XOR, BI_COMPLEMENT, 
        LEFT_SHIFT, RIGHT_SHIFT = 42
    } OPERATORS;

    typedef enum PUNCTUANTIONS {
        COLON = 43, SEMICOLON, COMMA, DOT,
        LEFT_BRACKET, RIGHT_BRACKET, LEFT_BRACE, RIGHT_BRACE,
        LEFT_PERAN, RIGHT_PERAN = 53
    } PUNCTUANTIONS;

    typedef enum LIBRARY_FUNCTIONS {
        PRINTF = 54, SCANF, GETC, GETS, GETCHAR, 
        PUTS, PUTCHAR, CLEARERR, FOPEN, FCLOSE, 
        GETW, PUTW, FGETC, PUTC, FPUTC,
        FGETS, FPUTS, FEOF, FSEEK, FTELL,
        REWIND, SPRINTF, SSCANF, REMOVE, FFLUSH = 69
    } LIBRARY_FUNCTIONS;

    typedef enum TOKEN_TYPE {
        ID = 70, STRING, CHAR, INTEGER, DOUBLE, SCI
    } TOKEN_TYPE;
}


%x VARDEF
STRING 			        (\042[^\042\n]*\042)
CHARACTER		        (\047[^\047\n]\047)
MULTI_CHARACTER		    (\047[^\047\n]+\047)
ZERO                    (0)
INTEGER_VALID           ([1-9]+[0-9]*)
INTEGER_INVALID         (0[0-9]+)
IDENTIFIER		        ([_a-zA-Z][_a-zA-Z0-9]*)


%%

{CHARACTER}             return CHAR;
{MULTI_CHARACTER}       { print_error(); return;}

{STRING}                return STRING;
{ZERO}                  return INTEGER;
{INTEGER_VALID}	        return INTEGER;
{INTEGER_INVALID}       { print_error(); return;}
<VARDEF>{IDENTIFIER}    { BEGIN(INITIAL); return ID; }

"int"           { BEGIN(VARDEF); return DATATYPE_INT; }
"double"        { BEGIN(VARDEF); return DATATYPE_DOUBLE; }
"bool"          { BEGIN(VARDEF); return DATATYPE_BOOL; }
"char"          { BEGIN(VARDEF); return DATATYPE_CHAR; }

"void"          return VOID;
"const"         return CONST;
"null"          return KEY_NULL;
"for"           return FOR;
"do"            return DO;
"while"         return WHILE;
"break"         return BREAK;
"continue"      return CONTINUE;
"if"            return IF;
"else"          return ELSE;
"return"        return RETURN;
"struct"        return STRUCT;
"switch"        return SWITCH;
"case"          return CASE;
"default"       return DEFAULT;

"+"             return PLUS;
"-"             return MINUS;
"*"             return MULTIPLE;
"/"             return DIVIDE;
"%"             return MOD;
"++"            return TWO_PLUS;
"--"            return TWO_MINUS;
"<"             return LESS;
"<="            return LESS_THAN;
">"             return GREATER;
">="            return GREATER_THAN;
"=="            return SAME;
"!="            return NOT_EQUAL;
"="             return EQUAL;
"&&"            return AND;
"||"            return OR;
"!"             return NOT;
"&"             return BI_AND;
"|"             return BI_OR;
"^"             return BI_XOR;
"~"             return BI_COMPLEMENT;
"<<"            return LEFT_SHIFT;
">>"            return RIGHT_SHIFT;

":"			    return COLON;
";"				return SEMICOLON;
","				return COMMA;
"."				return DOT;
"["				return LEFT_BRACKET;
"]"				return RIGHT_BRACKET;
"("				return LEFT_PERAN;
")"				return RIGHT_PERAN;
"{"				return LEFT_BRACE;
"}"				return RIGHT_BRACE;

"printf"		return PRINTF;
"scanf"			return SCANF;
"getc"			return GETC;
"gets"			return GETS;
"getchar"		return GETCHAR;
"puts"			return PUTS;
"putchar"		return PUTCHAR;
"clearerr"		return CLEARERR;
"fopen"			return FOPEN;
"fclose"		return FCLOSE;
"getw"			return GETW;
"putw"			return PUTW;
"fgetc"			return FGETC;
"putc"			return PUTC;
"fputc"			return FPUTC;
"fgets"			return FGETS;
"fputs"			return FPUTS;
"feof"			return FEOF;
"fseek"			return FSEEK;
"ftell"			return FTELL;
"rewind"		return REWIND;
"sprintf"		return SPRINTF;
"sscanf"		return SSCANF; 
"remove"		return REMOVE; 
"fflush"		return FFLUSH; 


%%


int yywrap() {return 1;} // yywrap() - wraps the above rule section 

void print(int token) {
    if(token >= 0 && token <= 3) printf("#token key:%s\n", yytext); //datatypes
    if(token >= 5 && token <= 19) printf("#token key:%s\n", yytext); //keywords
    if(token >= 20 && token <= 42) printf("#token op:%s\n", yytext); //operators
    if(token >= 43 && token <= 53) printf("#token punc:%s\n", yytext); //punctuations
    if(token >= 54 && token <= 69) printf("#token key:%s\n", yytext); //stdio functions
    if(token == ID) printf("#token id:%s\n", yytext);
    if(token == INTEGER) printf("#token integer:%s\n",yytext);
    if(token == STRING){
		char text[256];
		int i;
		for(iterator = 1; yytext[i] != '\042'; i++){
			text[iterator - 1] = yytext[iterator];
		}
		text[iterator - 1]='\0';
		printf("#token string:%s\n",text);
	}
}

void print_error() {
    printf("Error at line %d:%s\n", line_number, yytext);
}

int main () {
    int token;
    while((token = yylex())) {
		strcat(input_line, yytext);
	    print(token);
	}
    return 0;
}
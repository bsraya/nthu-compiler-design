%top{
    #include <string.h>
    int iterator = 0;
    int line_number = 1;
    char line_content[256];
    int source = 1;
    int token = 1;
    void print(int token);
    void raise_error();
    void newline();

    typedef enum TYPES {
	    DATATYPE_INT = 1, 
        DATATYPE_DOUBLE, 
        DATATYPE_BOOL, 
        DATATYPE_FLOAT,
        DATATYPE_CHAR,
        DATATYPE_SIGNED,
        DATATYPE_UNSIGNED,
        DATATYPE_LONG,
        DATATYPE_SHORT = 9
    } TYPES;

    typedef enum KEYWORDS {
        VOID = 10, KEY_NULL, FOR, DO, WHILE, 
        BREAK, CONTINUE, IF, ELSE, AUTO, 
        CONST, STATIC, UNION, ENUM, GOTO,
        REGISTER, SIZEOF, TYPEDEF, VOLATILE, EXTERN,
        RETURN, STRUCT, SWITCH, CASE, DEFAULT = 34
    } KEYWORDS;

    typedef enum OPERATORS {
        PLUS = 35, MINUS, MULTIPLE, DIVIDE, MOD, 
        TWO_MINUS, TWO_PLUS, LESS, LESS_THAN, GREATER, 
        GREATER_THAN, SAME, NOT_EQUAL, EQUAL, AND, 
        OR, NOT, BI_AND, BI_OR, BI_XOR, 
        BI_COMPLEMENT, LEFT_SHIFT, RIGHT_SHIFT = 57
    } OPERATORS;

    typedef enum PUNCTUANTIONS {
        COLON = 58, SEMICOLON, COMMA, DOT,
        LEFT_SQUARE_BRACKET, RIGHT_SQUARE_BRACKET, LEFT_BRACKET, RIGHT_BRACKET,
        LEFT_CURLY_BRACKET, RIGHT_CURLY_BRACKET = 67
    } PUNCTUANTIONS;

    typedef enum LIBRARY_FUNCTIONS {
        PRINTF = 68, SCANF, GETC, GETS, GETCHAR, 
        PUTS, PUTCHAR, CLEARERR, FOPEN, FCLOSE, 
        GETW, PUTW, FGETC, PUTC, FPUTC,
        FGETS, FPUTS, FEOF, FSEEK, FTELL,
        REWIND, SPRINTF, SSCANF, REMOVE, FFLUSH = 92
    } LIBRARY_FUNCTIONS;

    typedef enum TOKEN_TYPE {
        TOKEN_IDENTIFIER = 93, TOKEN_STRING, TOKEN_CHARACTER, TOKEN_INTEGER, TOKEN_DOUBLE, TOKEN_SCI_NOT
    } TOKEN_TYPE;

    typedef enum CONFIGURATIONS {
        CONFIG_SOURCEOFF = 200, CONFIG_SOURCEON, CONFIG_TOKENOFF, CONFIG_TOKENON
    } CONFIGURATIONS;

    typedef enum OTHERS{
        OTR_SPACE = 300, OTR_COMMENT, OTR_MULTILINE_COMMENT
    } OTHERS;
}

/* definitions */
%x VARIABLE_ASSIGNMENT
%s MULTILINE_COMMENT
SOURCEOFF		                    ("#pragma source off")
SOURCEON		                    ("#pragma source on")
TOKENOFF		                    ("#pragma token off")
TOKENON	                            ("#pragma token on")

CHARACTER		                    (\047[^\047\n]\047)
MULTI_CHARACTER		                (\047[^\047\n]+\047)
UNINFLECTED_TERM_CHAR		        (\047[^\047\n]*)

KEYWORD		                        ("double"|"int"|"char"|"bool"|"void"|"null"|"for"|"while"|"do"|"if"|"else"|"auto"|"static"|"union"|"enum"|"goto"|"register"|"sizeof"|"typedef"|"volatile"|"extern"|"switch"|"return"|"break"|"continue"|"const"|"true"|"false"|"struct"|"case"|"default"|"printf"|"scanf"|"getc"|"gets"|"getchar"|"puts"|"putchar"|"clearerr"|"fopen"|"fclose"|"getw"|"putw"|"fgetc"|"putc"|"fputc"|"fgets"|"fputs"|"feof"|"fseek"|"ftell"|"rewind"|"sprintf"|"sscanf"|"remove"|"fflush")
COMMENT	                            ("//"[^\n]*)
IDENTIFIER		                    ([_a-zA-Z][_a-zA-Z0-9]*)

STRING 			                    (\042[^\042\n]*\042)
UNINFLECTED_TERM_STRING             (\042[^\042\n]*)

BACKSLASH                           (\\*)

ZERO                                (0)
VALID_INTEGER                       ([1-9]+[0-9]*)
INVALID_INTEGER                     (0[0-9]+)

DOUBLE 			                    ([1-9]+[0-9]*"."[0-9]+)
ZERO_DOUBLE		                    (0.[0-9]+)
INVALID_DOUBLE                      ([0-9]+".") 

VALID_SCIENTIFIC_NOTATION           ([0-9]+["."[0-9]*]?[eE][+-]?[0-9]+)
INVALID_SCIENTIFIC_NOTATION         ([0-9]+["."[0-9]*]?[eE][+-]?[0-9]+"."[0-9]*)

%%

{SOURCEOFF}                         { source = 0; return CONFIG_SOURCEOFF; }
{SOURCEON}                          { source = 1; return CONFIG_SOURCEON; }
{TOKENOFF}                          { token = 0; return CONFIG_TOKENOFF; }
{TOKENON}                           { token = 1; return CONFIG_TOKENON; }

{COMMENT}                           return OTR_COMMENT;
"/*"				                { BEGIN(MULTILINE_COMMENT); return OTR_MULTILINE_COMMENT; }
<MULTILINE_COMMENT>[^*\n]*          return OTR_MULTILINE_COMMENT;
<MULTILINE_COMMENT>"*"+[^*/\n]*     return OTR_MULTILINE_COMMENT;
<MULTILINE_COMMENT>\n 		        { newline(); }
<MULTILINE_COMMENT>"*"+"/"	        { BEGIN(INITIAL); return OTR_MULTILINE_COMMENT;}

{ZERO}                              return TOKEN_INTEGER;
{VALID_INTEGER}	                    return TOKEN_INTEGER;
{DOUBLE}                            return TOKEN_DOUBLE;
{ZERO_DOUBLE}                       return TOKEN_DOUBLE;
{VALID_SCIENTIFIC_NOTATION}         return TOKEN_SCI_NOT;
{CHARACTER}                         return TOKEN_CHARACTER;
{STRING}                            return TOKEN_STRING;

{BACKSLASH}                         { raise_error(); return 0; }
{INVALID_INTEGER}                   { raise_error(); return 0; }
{INVALID_DOUBLE}                    { raise_error(); return 0; }
{INVALID_SCIENTIFIC_NOTATION}       { raise_error(); return 0; }
{MULTI_CHARACTER}                   { raise_error(); return 0; }
{UNINFLECTED_TERM_CHAR}             { raise_error(); return 0; }
{UNINFLECTED_TERM_STRING}           { raise_error(); return 0; }

[\n]                                { newline(); }
[ \t\r]+                            return OTR_SPACE;

"signed"                            return DATATYPE_SIGNED;
"unsigned"                          return DATATYPE_UNSIGNED;
"long"                              return DATATYPE_LONG;
"short"                             return DATATYPE_SHORT;
"int"                               { BEGIN(VARIABLE_ASSIGNMENT); return DATATYPE_INT; }
"double"                            { BEGIN(VARIABLE_ASSIGNMENT); return DATATYPE_DOUBLE; }
"bool"                              { BEGIN(VARIABLE_ASSIGNMENT); return DATATYPE_BOOL; }
"char"                              { BEGIN(VARIABLE_ASSIGNMENT); return DATATYPE_CHAR; }
<VARIABLE_ASSIGNMENT>"="			{ BEGIN(INITIAL); return EQUAL; }
<VARIABLE_ASSIGNMENT>";"			{ BEGIN(INITIAL); return SEMICOLON; }
<VARIABLE_ASSIGNMENT>[ \t\r]+   	return OTR_SPACE;
<VARIABLE_ASSIGNMENT>"*"			return MULTIPLE;
<VARIABLE_ASSIGNMENT>{KEYWORD}      { raise_error(); return 0; }
<VARIABLE_ASSIGNMENT>{IDENTIFIER}   { BEGIN(INITIAL); return TOKEN_IDENTIFIER; }
<VARIABLE_ASSIGNMENT>.              { raise_error(); return 0; }

"void"                              return VOID;
"null"                              return KEY_NULL;
"for"                               return FOR;
"do"                                return DO;
"while"                             return WHILE;
"break"                             return BREAK;
"continue"                          return CONTINUE;
"if"                                return IF;
"else"                              return ELSE;
"auto"                              return AUTO;
"const"                             return CONST;
"static"                            return STATIC;
"union"                             return UNION;
"enum"                              return ENUM;
"goto"                              return GOTO;
"register"                          return REGISTER;
"sizeof"                            return SIZEOF;
"typedef"                           return TYPEDEF;
"volatile"                          return VOLATILE;
"extern"                            return EXTERN;
"return"                            return RETURN;
"struct"                            return STRUCT;
"switch"                            return SWITCH;
"case"                              return CASE;
"default"                           return DEFAULT;

"+"                                 return PLUS;
"-"                                 return MINUS;
"*"                                 return MULTIPLE;
"/"                                 return DIVIDE;
"%"                                 return MOD;
"++"                                return TWO_PLUS;
"--"                                return TWO_MINUS;
"<"                                 return LESS;
"<="                                return LESS_THAN;
">"                                 return GREATER;
">="                                return GREATER_THAN;
"=="                                return SAME;
"!="                                return NOT_EQUAL;
"="                                 return EQUAL;
"&&"                                return AND;
"||"                                return OR;
"!"                                 return NOT;
"&"                                 return BI_AND;
"|"                                 return BI_OR;
"^"                                 return BI_XOR;
"~"                                 return BI_COMPLEMENT;
"<<"                                return LEFT_SHIFT;
">>"                                return RIGHT_SHIFT;

":"			                        return COLON;
";"				                    return SEMICOLON;
","				                    return COMMA;
"."				                    return DOT;
"["				                    return LEFT_SQUARE_BRACKET;
"]"				                    return RIGHT_SQUARE_BRACKET;
"("				                    return LEFT_BRACKET;
")"				                    return RIGHT_BRACKET;
"{"				                    return LEFT_CURLY_BRACKET;
"}"				                    return RIGHT_CURLY_BRACKET;

"printf" 		                    return PRINTF; 
"scanf"			                    return SCANF;
"getc"			                    return GETC;
"gets"			                    return GETS;
"getchar"		                    return GETCHAR;
"puts"			                    return PUTS;
"putchar"		                    return PUTCHAR;
"clearerr"		                    return CLEARERR;
"fopen"			                    return FOPEN;
"fclose"		                    return FCLOSE;
"getw"			                    return GETW;
"putw"			                    return PUTW;
"fgetc"			                    return FGETC;
"putc"			                    return PUTC;
"fputc"			                    return FPUTC;
"fgets"			                    return FGETS;
"fputs"			                    return FPUTS;
"feof"			                    return FEOF;
"fseek"			                    return FSEEK;
"ftell"			                    return FTELL;
"rewind"		                    return REWIND;
"sprintf" 		                    return SPRINTF; 
"sscanf"		                    return SSCANF; 
"remove"		                    return REMOVE; 
"fflush"		                    return FFLUSH; 

{IDENTIFIER}                        return TOKEN_IDENTIFIER;
.                                   { raise_error(); return 0; }

%%

int yywrap() {return 1;} // yywrap() - wraps the above rule section 

void print(int token) {
    if(token >= 1 && token <= 9) printf("#token key:%s\n", yytext); //datatypes
    if(token >= 10 && token <= 34) printf("#token key:%s\n", yytext); //keywords
    if(token >= 35 && token <= 57) printf("#token op:%s\n", yytext); //operators
    if(token >= 58 && token <= 67) printf("#token punc:%s\n", yytext); //punctuations
    if(token >= 68 && token <= 92) printf("#token key:%s\n", yytext); //stdio functions
    if (token == TOKEN_IDENTIFIER) printf("#token id:%s\n", yytext);
    if (token == TOKEN_INTEGER) printf("#token integer:%s\n",yytext);
    if (token ==  TOKEN_CHARACTER) printf("#token char:%s\n", yytext);
    if (token ==  TOKEN_DOUBLE) printf("#token double:%s", yytext);
    if (token ==  TOKEN_SCI_NOT) printf("#token sci:%s", yytext);
    if (token ==  TOKEN_STRING) {
        char text[256];
        for (iterator = 1; yytext[iterator] != '\042'; iterator++) {text[iterator - 1] = yytext[iterator];}
        text[iterator - 1]='\0';
        printf("#token string:%s\n",text);
    }
}

void raise_error() {
    printf("Error at line %d:%s\n", line_number, yytext);
    exit(EXIT_SUCCESS);
}

void newline() {
    if(source == 1) printf("%d:%s\n", line_number, line_content);
    
    memset(line_content, 0, sizeof(line_content));
    line_number++;
}

int main () {
    int token;
    while((token = yylex())) {
		strcat(line_content, yytext);
	    print(token);
	}
    return 0;
}
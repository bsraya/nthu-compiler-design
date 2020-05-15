%top{
    #include <string.h>
    int sourceOn = 1;
    int tokenOn = 1;
    int current_line_number = 1;
    char current_line_content[256];
    void print(int token);
    void raise_error();
    void newline();

    typedef enum DATATYPE {
	    DATATYPE_INT = 1, 
        DATATYPE_DOUBLE, 
        DATATYPE_FLOAT,
        DATATYPE_CHAR,
        DATATYPE_LONG,
        DATATYPE_BOOL,
        DATATYPE_SHORT = 7
    } DATATYPE;

    typedef enum KEYWORD {
        VOID = 8, FOR, DO, WHILE, BREAK, 
        CONTINUE, IF, ELSE, AUTO, CONST, 
        STATIC, UNION, ENUM, GOTO, REGISTER, 
        SIZEOF, TYPEDEF, VOLATILE, EXTERN, RETURN, 
        STRUCT, SWITCH, CASE, DEFAULT = 31
    } KEYWORD;

    typedef enum OPERATOR {
        PLUS = 32, MINUS, MULTIPLE, DIVIDE, MOD, 
        TWO_MINUS, TWO_PLUS, LESS, LESS_THAN, GREATER, 
        GREATER_THAN, SAME, NOT_EQUAL, EQUAL, AND, 
        OR, NOT, BI_AND, BI_OR, BI_XOR, 
        BI_COMPLEMENT, LEFT_SHIFT, RIGHT_SHIFT = 54
    } OPERATOR;

    typedef enum PUNCTUANTION {
        GRAVE_ACCENT = 55, POUND, DOLLAR, 
        COLON, SEMICOLON, COMMA, DOT,
        LEFT_SQUARE_BRACKET, RIGHT_SQUARE_BRACKET, LEFT_BRACKET, RIGHT_BRACKET,
        LEFT_CURLY_BRACKET, RIGHT_CURLY_BRACKET, AT_SIGN = 68
    } PUNCTUANTION;

    typedef enum LIBRARY_FUNCTION {
        FCLOSE = 69, CLEARERR, FEOF, FERROR, FFLUSH,
        FGETPOS, FOPEN, FREAD, FREOPEN, FSEEK,
        FSETPOS, FTELL, FWRITE, REMOVE, RENAME,
        REWIND, SETBUF, SETVBUF, TMPFILE,
        TMPNAM, FPRINTF, PRINTF, SPRINTF, VFPRINTF,
        VPRINTF, VSPRINTF, FSCANF, SCANF, SSCANF,
        FGETC, FGETS, FPUTC, FPUTS, GETC,
        GETCHAR, GETS, PUTC, PUTCHAR, PUTS, 
        UNGETC, PERROR, GETW, PUTW = 111
    } LIBRARY_FUNCTION;

    typedef enum RESERVED_WORD {
        RESVRD_TRUE = 112, RESVRD_FALSE = 113, RESVRD_NULL = 114
    } RESERVED_WORD;

    typedef enum TOKEN_TYPE {
        TOKEN_IDENTIFIER = 150, TOKEN_STRING, TOKEN_CHARACTER, TOKEN_INTEGER, TOKEN_DOUBLE, TOKEN_SCI_NOT
    } TOKEN_TYPE;

    typedef enum CONFIGURATION {
        CONFIG_SOURCEOFF = 200, CONFIG_SOURCEON, CONFIG_TOKENOFF, CONFIG_TOKENON
    } CONFIGURATION;

    typedef enum OTHER{
        OTR_SPACE = 300, OTR_COMMENT, OTR_MULTILINE_COMMENT
    } OTHERS;
}

/* definitions */
%x VARIABLE_ASSIGNMENT
%s MULTILINE_COMMENT
SOURCEOFF		                    (\#pragma[[:space:]]source[[:space:]]off)
SOURCEON		                    (\#pragma[[:space:]]source[[:space:]]on)
TOKENOFF		                    (\#pragma[[:space:]]token[[:space:]]off)
TOKENON	                            (\#pragma[[:space:]]token[[:space:]]on)

CHARACTER		                    (\'[^\'\n]\')
CHARACTER_SPACES                    (\'\\(b|0|n|t|r|f|v)\')
MULTI_CHARACTER		                (\'[^\'\n]+\')
UNINFLECTED_TERM_CHAR		        (\'[^\'\n]*)

COMMENT	                            ("//"[^\n]*)
IDENTIFIER		                    ([_a-zA-Z][_a-zA-Z0-9]*)

STRING 			                    (\"[^\"\n]*\")
UNINFLECTED_TERM_STRING             (\"[^\"\n]*)

BACKSLASHES                         (\\*)

ZERO                                (0)
VALID_INTEGER                       ([1-9]+[0-9]*)
INVALID_INTEGER                     (0[0-9]+)

DOUBLE 			                    ([1-9]+[0-9]*"."[0-9]+)
ZERO_DOUBLE		                    (0.[0-9]+)
NO_ZERO_DOUBLE                      (\.[0-9]+)
INVALID_DOUBLE                      ([0-9]+".") 

VALID_SCIENTIFIC_NOTATION           ([0-9]+["."[0-9]*]?[eE][+-]?[0-9]+)
INVALID_SCIENTIFIC_NOTATION         ([0-9]+["."[0-9]*]?[eE][+-]?[0-9]+"."[0-9]*)

LIST_OF_KEYWORDS             		("double"|"int"|"char"|"bool"|"void"|"null"|"for"|"while"|"do"|"if"|"else"|"switch"|"return"|"break"|"continue"|"const"|"true"|"false"|"struct"|"case"|"default"|"printf"|"scanf"|"getc"|"gets"|"getchar"|"puts"|"putchar"|"clearerr"|"fopen"|"fclose"|"getw"|"putw"|"fgetc"|"putc"|"fputc"|"fgets"|"fputs"|"feof"|"fseek"|"ftell"|"rewind"|"sprintf"|"sscanf"|"remove"|"fflush")

%%

{SOURCEOFF}                         { sourceOn = 0; return CONFIG_SOURCEOFF; }
{TOKENOFF}                          { tokenOn = 0; return CONFIG_TOKENOFF; }
{SOURCEON}                          { sourceOn = 1; return CONFIG_SOURCEON; }
{TOKENON}                           { tokenOn = 1; return CONFIG_TOKENON; }

{COMMENT}                           return OTR_COMMENT;
"/*"				                { BEGIN(MULTILINE_COMMENT); return OTR_MULTILINE_COMMENT; }
<MULTILINE_COMMENT>[^*\n]*          return OTR_MULTILINE_COMMENT;
<MULTILINE_COMMENT>"*"+[^*/\n]*     return OTR_MULTILINE_COMMENT;
<MULTILINE_COMMENT>\n 		        newline(); 
<MULTILINE_COMMENT>"*"+"/"	        { BEGIN(INITIAL); return OTR_MULTILINE_COMMENT;}

{ZERO}                              return TOKEN_INTEGER;
{VALID_INTEGER}	                    return TOKEN_INTEGER;
{DOUBLE}                            return TOKEN_DOUBLE;
{ZERO_DOUBLE}                       return TOKEN_DOUBLE;
{NO_ZERO_DOUBLE}                    return TOKEN_DOUBLE;
{VALID_SCIENTIFIC_NOTATION}         return TOKEN_SCI_NOT;
{CHARACTER}                         return TOKEN_CHARACTER;
{CHARACTER_SPACES}                  return TOKEN_CHARACTER;
{STRING}                            return TOKEN_STRING;

{BACKSLASHES}                       { raise_error(); return 0; }
{INVALID_INTEGER}                   { raise_error(); return 0; }
{INVALID_DOUBLE}                    { raise_error(); return 0; }
{INVALID_SCIENTIFIC_NOTATION}       { raise_error(); return 0; }
{MULTI_CHARACTER}                   { raise_error(); return 0; }
{UNINFLECTED_TERM_CHAR}             { raise_error(); return 0; }
{UNINFLECTED_TERM_STRING}           { raise_error(); return 0; }

[\n]                                { newline(); }
[ \t\r]+                            return OTR_SPACE;

"true"                              return RESVRD_TRUE;
"false"                             return RESVRD_FALSE;
"null"                              return RESVRD_NULL;

"bool"                              { BEGIN(VARIABLE_ASSIGNMENT); return DATATYPE_BOOL; }
"long"                              { BEGIN(VARIABLE_ASSIGNMENT); return DATATYPE_LONG; }
"short"                             { BEGIN(VARIABLE_ASSIGNMENT); return DATATYPE_SHORT; }
"int"                               { BEGIN(VARIABLE_ASSIGNMENT); return DATATYPE_INT; }
"double"                            { BEGIN(VARIABLE_ASSIGNMENT); return DATATYPE_DOUBLE; }
"char"                              { BEGIN(VARIABLE_ASSIGNMENT); return DATATYPE_CHAR; }
<VARIABLE_ASSIGNMENT>"="			{ BEGIN(INITIAL); return EQUAL; }
<VARIABLE_ASSIGNMENT>";"			{ BEGIN(INITIAL); return SEMICOLON; }
<VARIABLE_ASSIGNMENT>[ \t\r]+   	return OTR_SPACE;
<VARIABLE_ASSIGNMENT>"*"			return MULTIPLE;
<VARIABLE_ASSIGNMENT>{LIST_OF_KEYWORDS}	    { raise_error(); return 0; }
<VARIABLE_ASSIGNMENT>{IDENTIFIER}   { BEGIN(INITIAL); return TOKEN_IDENTIFIER; }
<VARIABLE_ASSIGNMENT>.			    { raise_error(); return 0; }

"void"                              return VOID;
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

"`"                                 return GRAVE_ACCENT;
"#"                                 return POUND;
"$"                                 return DOLLAR;
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
"@"                                 return AT_SIGN;

"fclose"		                    return FCLOSE;
"clearerr"		                    return CLEARERR;
"feof"			                    return FEOF;
"ferror"                            return FERROR; 
"fflush"		                    return FFLUSH;
"fgetpos"                           return FGETPOS;
"fopen"                             return FOPEN;
"fread"                             return FREAD;
"freopen"                           return FREOPEN;
"fseek"			                    return FSEEK;
"fsetpos"                           return FSETPOS;
"ftell"			                    return FTELL;
"fwrite"                            return FWRITE;
"remove"		                    return REMOVE;
"rename"                            return RENAME;
"rewind"		                    return REWIND;
"setbuf"                            return SETBUF;
"setvbuf"                           return SETVBUF;
"tmpfile"                           return TMPFILE;
"tmpnam"                            return TMPNAM;
"fprintf"                           return FPRINTF;
"printf" 		                    return PRINTF; 
"sprintf" 		                    return SPRINTF; 
"vfprintf"                          return VFPRINTF;
"vprintf"                           return VPRINTF;
"vsprintf"                          return VSPRINTF;
"fscanf"                            return FSCANF;
"scanf"			                    return SCANF;
"sscanf"		                    return SSCANF;
"fgetc"			                    return FGETC;  
"fgets"			                    return FGETS;
"fputc"			                    return FPUTC;
"fputs"			                    return FPUTS;
"getc"			                    return GETC;
"getchar"		                    return GETCHAR;
"gets"			                    return GETS;
"putc"			                    return PUTC;
"putchar"		                    return PUTCHAR;
"puts"			                    return PUTS;
"ungetc"                            return UNGETC;
"perror"                            return PERROR;
"getw"			                    return GETW;
"putw"			                    return PUTW;

{IDENTIFIER}                        return TOKEN_IDENTIFIER;
.                                   { raise_error(); return 0; }

%%

int yywrap() {return 1;} // yywrap() - wraps the above rule section 

int main () {
    int token;
    while((token = yylex())) {
		strcat(current_line_content, yytext);
        if(tokenOn == 1) print(token);
    }
    return 0;
}



void print(int token) {
    if(token >= 1 && token <= 7) fprintf(stdout, "#token key:%s\n", yytext); //datatypes
    if(token >= 8 && token <= 31) fprintf(stdout, "#token key:%s\n", yytext); //keywords
    if(token >= 32 && token <= 54) fprintf(stdout, "#token op:%s\n", yytext); //operators
    if(token >= 55 && token <= 68) {fprintf(stdout, "#token punc:%s\n", yytext); return;} //punctuations
    if(token >= 69 && token <= 111) fprintf(stdout, "#token key:%s\n", yytext); //stdio functions
    if(token >= 112 && token <= 114) fprintf(stdout, "#token key:%s\n", yytext);
    if(token == TOKEN_IDENTIFIER) fprintf(stdout, "#token id:%s\n", yytext);
    if(token == TOKEN_INTEGER) fprintf(stdout, "#token integer:%s\n",yytext);
    if(token == TOKEN_CHARACTER) fprintf(stdout, "#token char:%s\n", yytext);
    if(token == TOKEN_DOUBLE) fprintf(stdout, "#token double:%s\n", yytext);
    if(token == TOKEN_SCI_NOT) fprintf(stdout, "#token sci:%s\n", yytext);
    if(token == TOKEN_STRING) {
        char text[256];
        int iterator;
        for (iterator = 1; yytext[iterator] != '\042'; iterator++) {text[iterator - 1] = yytext[iterator];}
        text[iterator - 1]='\0';
        fprintf(stdout, "#token string:\"%s\"\n",text);
    }
}

void raise_error() {
    fprintf(stderr, "Error at line %d:%s\n", current_line_number, yytext);
    exit(EXIT_SUCCESS);
}

void newline() {
    if(sourceOn == 1) {fprintf(stdout, "%d:%s\n", current_line_number, current_line_content);}
    memset(current_line_content, 0, sizeof(current_line_content));
    current_line_number++;
}
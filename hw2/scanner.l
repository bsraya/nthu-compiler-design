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
        DATATYPE_BOOL = 5,
    } DATATYPE;

    typedef enum KEYWORD {
        VOID = 6, FOR, DO, WHILE, BREAK, 
        CONTINUE, IF, ELSE, AUTO, CONST, 
        STATIC, UNION, ENUM, GOTO, REGISTER, 
        SIZEOF, TYPEDEF, VOLATILE, EXTERN, RETURN, 
        STRUCT, SWITCH, CASE, DEFAULT = 29
    } KEYWORD;

    typedef enum OPERATOR {
        PLUS = 30, MINUS, MULTIPLE, DIVIDE, MOD, 
        TWO_MINUS, TWO_PLUS, LESS, LESS_THAN, GREATER, 
        GREATER_THAN, SAME, NOT_EQUAL, EQUAL, AND, 
        OR, NOT, BI_AND, BI_OR, BI_XOR, 
        BI_COMPLEMENT, LEFT_SHIFT, RIGHT_SHIFT = 52
    } OPERATOR;

    typedef enum PUNCTUANTION {
        GRAVE_ACCENT = 53, POUND, DOLLAR, 
        COLON, SEMICOLON, COMMA, DOT,
        LEFT_SQUARE_BRACKET, RIGHT_SQUARE_BRACKET, LEFT_BRACKET, RIGHT_BRACKET,
        LEFT_CURLY_BRACKET, RIGHT_CURLY_BRACKET, AT_SIGN = 66
    } PUNCTUANTION;

    typedef enum LIBRARY_FUNCTION {
        FCLOSE = 67, CLEARERR, FEOF, FERROR, FFLUSH,
        FGETPOS, FOPEN, FREAD, FREOPEN, FSEEK,
        FSETPOS, FTELL, FWRITE, REMOVE, RENAME,
        REWIND, SETBUF, SETVBUF, TMPFILE,
        TMPNAM, FPRINTF, PRINTF, SPRINTF, VFPRINTF,
        VPRINTF, VSPRINTF, FSCANF, SCANF, SSCANF,
        FGETC, FGETS, FPUTC, FPUTS, GETC,
        GETCHAR, GETS, PUTC, PUTCHAR, PUTS, 
        UNGETC, PERROR, GETW, PUTW = 109
    } LIBRARY_FUNCTION;

    typedef enum RESERVED_WORD {
        RESVRD_TRUE = 110, RESVRD_FALSE = 111, RESVRD_NULL = 112
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

{SOURCEOFF}                         { sourceOn = 0; strcat(cur_line_content,yytext);  }
{TOKENOFF}                          { tokenOn = 0; strcat(cur_line_content,yytext);  }
{SOURCEON}                          { sourceOn = 1; strcat(cur_line_content,yytext);  }
{TOKENON}                           { tokenOn = 1; strcat(cur_line_content,yytext);  }

{COMMENT}                           { strcat(cur_line_content,yytext); }
"/*"				                { BEGIN(MULTILINE_COMMENT); strcat(cur_line_content,yytext); }
<MULTILINE_COMMENT>[^*\n]*          { strcat(cur_line_content,yytext); }
<MULTILINE_COMMENT>"*"+[^*/\n]*     { strcat(cur_line_content,yytext); }
<MULTILINE_COMMENT>\n 		        newline(); 
<MULTILINE_COMMENT>"*"+"/"	        { BEGIN(INITIAL); strcat(cur_line_content,yytext); }

{ZERO}                              { strcat(cur_line_content,yytext); return TOKEN_INTEGER; }
{VALID_INTEGER}	                    { strcat(cur_line_content,yytext); return TOKEN_INTEGER; }
{DOUBLE}                            { strcat(cur_line_content,yytext); return TOKEN_DOUBLE; }
{ZERO_DOUBLE}                       { strcat(cur_line_content,yytext); return TOKEN_DOUBLE; }
{NO_ZERO_DOUBLE}                    { strcat(cur_line_content,yytext); return TOKEN_DOUBLE; }
{VALID_SCIENTIFIC_NOTATION}         { strcat(cur_line_content,yytext); return TOKEN_SCI_NOT; }
{CHARACTER}                         { strcat(cur_line_content,yytext); return TOKEN_CHARACTER; }
{CHARACTER_SPACES}                  { strcat(cur_line_content,yytext); return TOKEN_CHARACTER; }
{STRING}                            { strcat(cur_line_content,yytext); return TOKEN_STRING; }

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

"bool"                                      { BEGIN(VARIABLE_ASSIGNMENT); return DATATYPE_BOOL; }
"int"                                       { BEGIN(VARIABLE_ASSIGNMENT); return DATATYPE_INT; }
"double"                                    { BEGIN(VARIABLE_ASSIGNMENT); return DATATYPE_DOUBLE; }
"char"                                      { BEGIN(VARIABLE_ASSIGNMENT); return DATATYPE_CHAR; }
"float"                                     { BEGIN(VARIABLE_ASSIGNMENT); return DATATYPE_FLOAT; }
<VARIABLE_ASSIGNMENT>"="			        { BEGIN(INITIAL); return EQUAL; }
<VARIABLE_ASSIGNMENT>";"			        { BEGIN(INITIAL); return SEMICOLON; }
<VARIABLE_ASSIGNMENT>[ \t\r]+   	        return OTR_SPACE;
<VARIABLE_ASSIGNMENT>"*"			        return MULTIPLE;
<VARIABLE_ASSIGNMENT>{LIST_OF_KEYWORDS}	    { raise_error(); return 0; }
<VARIABLE_ASSIGNMENT>{IDENTIFIER}           { BEGIN(INITIAL); return TOKEN_IDENTIFIER; }
<VARIABLE_ASSIGNMENT>.			            { raise_error(); return 0; }

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
    if(token >= 1 && token <= 5) fprintf(stdout, "#token key:%s\n", yytext); //datatypes
    if(token >= 6 && token <= 29) fprintf(stdout, "#token key:%s\n", yytext); //keywords
    if(token >= 30 && token <= 52) fprintf(stdout, "#token op:%s\n", yytext); //operators
    if(token >= 53 && token <= 66) {fprintf(stdout, "#token punc:%s\n", yytext); return;} //punctuations
    if(token >= 67 && token <= 109) fprintf(stdout, "#token key:%s\n", yytext); //stdio functions
    if(token >= 110 && token <= 112) fprintf(stdout, "#token key:%s\n", yytext);
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
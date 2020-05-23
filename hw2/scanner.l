%top{
    #include <string.h>

    void raise_error();
    void yyerror(const char *msg);

    int sourceOn = 1;
    int tokenOn = 1;
    int current_line_line = 1;
    char current_line_content[256]; 

    
    void yyerror(const char *msg) {
        fprintf(stderr, "Error at line %d: %s\n", current_line_line, current_line_content);
        exit(-1);
    }   

    void raise_error(){
	    fprintf(stderr, "Error at line %d: %s\n",cur_line_num,yytext);
	    exit(1);
    }
    
    typedef enum TYPES {
	    DATATYPE_INT = 1, 
        DATATYPE_DOUBLE, 
        DATATYPE_BOOL, 
        DATATYPE_FLOAT,
        DATATYPE_CHAR = 5,
    } TYPES;

    typedef enum KEYWORDS {
        KEY_TRUE = 10, KEY_FALSE, KEY_NULL, VOID, FOR, 
        DO, WHILE, BREAK, CONTINUE, IF, 
        ELSE, AUTO, CONST, STATIC, UNION, 
        ENUM, GOTO, REGISTER, SIZEOF, TYPEDEF, 
        VOLATILE, EXTERN, RETURN, STRUCT, SWITCH, 
        CASE, DEFAULT = 36
    } KEYWORDS;

    typedef enum OPERATORS {
        PLUS = 37, MINUS, MULTIPLE, DIVIDE, MOD, 
        TWO_MINUS, TWO_PLUS, LESS, LESS_THAN, GREATER, 
        GREATER_THAN, SAME, NOT_EQUAL, EQUAL, AND, 
        OR, NOT, BI_AND, BI_OR, BI_XOR, 
        BI_COMPLEMENT, LEFT_SHIFT, RIGHT_SHIFT = 59
    } OPERATORS;

    typedef enum PUNCTUANTIONS {
        GRAVE_ACCENT = 60, POUND, DOLLAR, 
        COLON, SEMICOLON, COMMA, DOT,
        LEFT_SQUARE_BRACKET, RIGHT_SQUARE_BRACKET, LEFT_BRACKET, RIGHT_BRACKET,
        LEFT_CURLY_BRACKET, RIGHT_CURLY_BRACKET = 72
    } PUNCTUANTIONS;

    typedef enum LIBRARY_FUNCTIONS {
        FCLOSE = 73, CLEARERR, FEOF, FERROR, FFLUSH,
        FGETPOS, FOPEN, FREAD, FREOPEN, FSEEK,
        FSETPOS, FTELL, FWRITE, REMOVE, RENAME,
        REWIND, SETBUF, SETVBUF, TMPFILE,
        TMPNAM, FPRINTF, PRINTF, SPRINTF, VFPRINTF,
        VPRINTF, VSPRINTF, FSCANF, SCANF, SSCANF,
        FGETC, FGETS, FPUTC, FPUTS, GETC,
        GETCHAR, GETS, PUTC, PUTCHAR, PUTS, 
        UNGETC, PERROR, GETW, PUTW = 115
    } LIBRARY_FUNCTIONS;

    typedef enum TOKEN_TYPE {
        TOKEN_IDENTIFIER = 150, TOKEN_STRING, TOKEN_CHARACTER, TOKEN_INTEGER, TOKEN_DOUBLE, TOKEN_SCI_NOT
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
SOURCEOFF		                            (\#pragma[[:space:]]source[[:space:]]off)
SOURCEON		                            (\#pragma[[:space:]]source[[:space:]]on)
TOKENOFF		                            (\#pragma[[:space:]]token[[:space:]]off)
TOKENON	                                    (\#pragma[[:space:]]token[[:space:]]on)

CHARACTER		                            (\'[^\'\n]\')
CHARACTER_SPACES                            (\'\\(b|0|n|t|r|f|v)\')
MULTI_CHARACTER		                        (\'[^\'\n]+\')
UNINFLECTED_TERM_CHAR		                (\'[^\'\n]*)

COMMENT	                                    ("//"[^\n]*)
IDENTIFIER		                            ([_a-zA-Z][_a-zA-Z0-9]*)

STRING 			                            (\"[^\"\n]*\")
UNINFLECTED_TERM_STRING                     (\"[^\"\n]*)

BACKSLASHES                                 (\\*)

ZERO                                        (0)
VALID_INTEGER                               ([1-9]+[0-9]*)
INVALID_INTEGER                             (0[0-9]+)

DOUBLE 			                            ([1-9]+[0-9]*"."[0-9]+)
ZERO_DOUBLE		                            (0.[0-9]+)
NO_ZERO_DOUBLE                              (\.[0-9]+)
INVALID_DOUBLE                              ([0-9]+".") 

VALID_SCIENTIFIC_NOTATION                   ([0-9]+["."[0-9]*]?[eE][+-]?[0-9]+)
INVALID_SCIENTIFIC_NOTATION                 ([0-9]+["."[0-9]*]?[eE][+-]?[0-9]+"."[0-9]*)

LIST_OF_KEYWORD             		        ("goto"|"register"|"sizeof"|"typedef"|"volatile"|"extern"|"static"|"union"|"enum"|"auto"|"double"|"int"|"char"|"bool"|"void"|"null"|"for"|"while"|"do"|"if"|"else"|"switch"|"return"|"break"|"continue"|"const"|"true"|"false"|"struct"|"case"|"default"|"printf"|"scanf"|"getc"|"gets"|"getchar"|"puts"|"putchar"|"clearerr"|"fopen"|"fclose"|"getw"|"putw"|"fgetc"|"putc"|"fputc"|"fgets"|"fputs"|"feof"|"fseek"|"ftell"|"rewind"|"sprintf"|"sscanf"|"remove"|"fflush"|"ferror"|"fgetpos"|"fread"|"freopen"|"fsetpos"|"fwrite"|"rename"|"setbuf"|"setvbuf"|"tmpfile"|"tmpnam"|"fprintf"|"vfprintf"|"vprintf"|"vsprintf"|"fscanf"|"ungetc"|"perror")

%%

[\n]                                        { newline();                                                                }
[ \t\r]+                                    { yylval.stringValue = yytext;                                         }

{SOURCEOFF}                                 { sourceOn = 0; yylval.stringValue = yytext;                           }
{SOURCEON}                                  { sourceOn = 1; yylval.stringValue = yytext;                           }          
{TOKENOFF}                                  { tokenOn = 0;  yylval.stringValue = yytext;                           }
{TOKENON}                                   { tokenOn = 1;  yylval.stringValue = yytext;                           }

{ZERO}                                      { yylval.stringValue = yytext; yylval.intValue = atoi(yytext); return TOKEN_INTEGER;       }
{VALID_INTEGER}	                            { yylval.stringValue = yytext; yylval.intValue = atoi(yytext); return TOKEN_INTEGER;       }
{DOUBLE}                                    { yylval.stringValue = yytext; yylval.doubleValue = atof(yytext); return TOKEN_DOUBLE;     }
{ZERO_DOUBLE}                               { yylval.stringValue = yytext; yylval.doubleValue = atof(yytext); return TOKEN_DOUBLE;     }
{NO_ZERO_DOUBLE}                            { yylval.stringValue = yytext; yylval.doubleValue = atof(yytext); return TOKEN_DOUBLE;     }
{VALID_SCIENTIFIC_NOTATION}                 { yylval.stringValue = yytext; return TOKEN_SCI_NOT; }
{CHARACTER}                                 { yylval.stringValue = yytext; yylval.charValue = yytext; return TOKEN_CHARACTER;          }
{CHARACTER_SPACES}                          { yylval.stringValue = yytext; yylval.stringValue = yytext; return TOKEN_CHARACTER;        }
{STRING}                                    { yylval.stringValue = yytext; yylval.stringValue = yytext; return TOKEN_STRING;           }

{BACKSLASHES}                               { raise_error(); return 0; }
{INVALID_INTEGER}                           { raise_error(); return 0; }
{INVALID_DOUBLE}                            { raise_error(); return 0; }
{INVALID_SCIENTIFIC_NOTATION}               { raise_error(); return 0; }
{MULTI_CHARACTER}                           { raise_error(); return 0; }
{UNINFLECTED_TERM_CHAR}                     { raise_error(); return 0; }
{UNINFLECTED_TERM_STRING}                   { raise_error(); return 0; }

{COMMENT}                                   { yylval.stringValue = yytext;                                         }
"/*"				                        { BEGIN(MULTILINE_COMMENT); yylval.stringValue = yytext;               }
<MULTILINE_COMMENT>[^*\n]*                  { yylval.stringValue = yytext;                                         }
<MULTILINE_COMMENT>"*"+[^*/\n]*             { yylval.stringValue = yytext;                                         }
<MULTILINE_COMMENT>\n 		                { newline();   yylval.stringValue = yytext;                                                               }
<MULTILINE_COMMENT>"*"+"/"	                { BEGIN(INITIAL); strcat(current_line_content,yytext);                          }

"bool"                                      { BEGIN(VARIABLE_ASSIGNMENT); yylval.stringValue = yytext; yylval.stringValue = yytext; return DATATYPE_BOOL;         }
"int"                                       { BEGIN(VARIABLE_ASSIGNMENT); yylval.stringValue = yytext; yylval.stringValue = yytext; return DATATYPE_INT;          }
"double"                                    { BEGIN(VARIABLE_ASSIGNMENT); yylval.stringValue = yytext; yylval.stringValue = yytext; return DATATYPE_DOUBLE;       }
"char"                                      { BEGIN(VARIABLE_ASSIGNMENT); yylval.stringValue = yytext; yylval.stringValue = yytext; return DATATYPE_CHAR;         }
"float"                                     { BEGIN(VARIABLE_ASSIGNMENT); yylval.stringValue = yytext; yylval.stringValue = yytext; return DATATYPE_FLOAT;        }
<VARIABLE_ASSIGNMENT>"="			        { BEGIN(INITIAL);             yylval.stringValue = yytext; return ASSIGN_EQUAL;          }
<VARIABLE_ASSIGNMENT>";"			        { BEGIN(INITIAL);             yylval.stringValue = yytext; return SEMICOLON;             }
<VARIABLE_ASSIGNMENT>{IDENTIFIER}           { BEGIN(INITIAL);             yylval.stringValue = yytext; return TOKEN_IDENTIFIER;      }
<VARIABLE_ASSIGNMENT>"*"			        {                             yylval.stringValue = yytext; return MULTIPLE;              }
<VARIABLE_ASSIGNMENT>[ \t\r]+   	        { yylval.stringValue = yytext;                                                                     }
<VARIABLE_ASSIGNMENT>{LIST_OF_KEYWORD}	    { raise_error(); return 0;                                                                              }
<VARIABLE_ASSIGNMENT>.			            { raise_error(); return 0;                                                                              }

"true"                                      { yylval.stringValue = yytext; return RESERVED_TRUE;        }
"false"                                     { yylval.stringValue = yytext; return RESERVED_FALSE;       }
"null"                                      { yylval.stringValue = yytext; return RESERVED_NULL;        }

"void"                                      { yylval.stringValue = yytext; return VOID;                 }
"for"                                       { yylval.stringValue = yytext; return FOR;                  }
"do"                                        { yylval.stringValue = yytext; return DO;                   }
"while"                                     { yylval.stringValue = yytext; return WHILE;                }
"break"                                     { yylval.stringValue = yytext; return BREAK;                }
"continue"                                  { yylval.stringValue = yytext; return CONTINUE;             }
"if"                                        { yylval.stringValue = yytext; return IF;                   }
"else"                                      { yylval.stringValue = yytext; return ELSE;                 }
"auto"                                      { yylval.stringValue = yytext; return AUTO;                 }            
"const"                                     { yylval.stringValue = yytext; return CONST;                }
"static"                                    { yylval.stringValue = yytext; return STATIC;               }
"union"                                     { yylval.stringValue = yytext; return UNION;                }
"enum"                                      { yylval.stringValue = yytext; return ENUM;                 }
"goto"                                      { yylval.stringValue = yytext; return GOTO;                 }
"register"                                  { yylval.stringValue = yytext; return REGISTER;             }
"sizeof"                                    { yylval.stringValue = yytext; return SIZEOF;               }
"typedef"                                   { yylval.stringValue = yytext; return TYPEDEF;              }
"volatile"                                  { yylval.stringValue = yytext; return VOLATILE;             }
"extern"                                    { yylval.stringValue = yytext; return EXTERN;               }
"return"                                    { yylval.stringValue = yytext; return RETURN;               }
"struct"                                    { yylval.stringValue = yytext; return STRUCT;               }
"switch"                                    { yylval.stringValue = yytext; return SWITCH;               }
"case"                                      { yylval.stringValue = yytext; return CASE;                 }
"default"                                   { yylval.stringValue = yytext; return DEFAULT;              }

"+"                                         { yylval.stringValue = yytext; return PLUS;                 }
"-"                                         { yylval.stringValue = yytext; return MINUS;                }
"*"                                         { yylval.stringValue = yytext; return MULTIPLE;             }
"/"                                         { yylval.stringValue = yytext; return DIVIDE;               }
"%"                                         { yylval.stringValue = yytext; return MOD;                  }
"++"                                        { yylval.stringValue = yytext; return INCREMENT;            }
"--"                                        { yylval.stringValue = yytext; return DECREMENT;            }    
"<"                                         { yylval.stringValue = yytext; return LESS;                 }
"<="                                        { yylval.stringValue = yytext; return LESS_THAN;            }
">"                                         { yylval.stringValue = yytext; return GREATER;              }
">="                                        { yylval.stringValue = yytext; return GREATER_THAN;         }
"=="                                        { yylval.stringValue = yytext; return EQUAL_TO;             }
"!="                                        { yylval.stringValue = yytext; return NOT_EQUAL_TO;         }
"="                                         { yylval.stringValue = yytext; return ASSIGN_EQUAL;         }
"&&"                                        { yylval.stringValue = yytext; return LOGICAL_AND;          }
"||"                                        { yylval.stringValue = yytext; return LOGICAL_OR;           }
"!"                                         { yylval.stringValue = yytext; return LOGICAL_NOT;          }
"&"                                         { yylval.stringValue = yytext; return BITWISE_AND;          }
"|"                                         { yylval.stringValue = yytext; return BITWISE_OR;           }
"^"                                         { yylval.stringValue = yytext; return BITWISE_XOR;          }
"~"                                         { yylval.stringValue = yytext; return BITWISE_COMPLEMENT;   }
"<<"                                        { yylval.stringValue = yytext; return LEFT_SHIFT;           }
">>"                                        { yylval.stringValue = yytext; return RIGHT_SHIFT;          }

"`"                                         { yylval.stringValue = yytext; return GRAVE_ACCENT;         }
"#"                                         { yylval.stringValue = yytext; return POUND;                }
"$"                                         { yylval.stringValue = yytext; return DOLLAR;               }
":"			                                { yylval.stringValue = yytext; return COLON;                }
";"				                            { yylval.stringValue = yytext; return SEMICOLON;            }
","				                            { yylval.stringValue = yytext; return COMMA;                }
"."				                            { yylval.stringValue = yytext; return DOT;                  }
"["				                            { yylval.stringValue = yytext; return LEFT_SQUARE_BRACKET;  }
"]"				                            { yylval.stringValue = yytext; return RIGHT_SQUARE_BRACKET; }
"("				                            { yylval.stringValue = yytext; return LEFT_BRACKET;         }
")"				                            { yylval.stringValue = yytext; return RIGHT_BRACKET;        }
"{"				                            { yylval.stringValue = yytext; return LEFT_CURLY_BRACKET;   }
"}"				                            { yylval.stringValue = yytext; return RIGHT_CURLY_BRACKET;  }
"@"                                         { yylval.stringValue = yytext; return AT_SIGN;              }


{IDENTIFIER}                                { yylval.stringValue = yytext; yylval.intValue = atoi(yytext); return TOKEN_IDENTIFIER;    }
.                                           { raise_error(); return 0; }

%%

int yywrap() {
    return 1;
} 

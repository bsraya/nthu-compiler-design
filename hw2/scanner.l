%top{
    #include <string.h>

    void print(int token);
    void raise_error();
    void newline();
    void yyerror(const *msg)

    int sourceOn = 1;
    int tokenOn = 1;
    int current_line_number = 1;
    char current_line_content[256];
    
    
    void yyerror(const *msg) {
        fprint(stderr, "Error at line %d: %s\n", current_line_number, current_line_content);
        exit(EXIT_FAILURE);
    }

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
        DECREMENT, INCREMENT, LESS, LESS_THAN, GREATER, 
        GREATER_THAN, EQUAL_TO, NOT_EQUAL_TO, ASSIGN_EQUAL, LOGICAL_AND, 
        LOGICAL_OR, LOGICAL_NOT, BITWISE_AND, BITWISE_OR, BITWISE_XOR, 
        BITWISE_COMPLEMENT, LEFT_SHIFT, RIGHT_SHIFT = 52
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

{SOURCEOFF}                                 { sourceOn = 0; strcat(cur_line_content, yytext);    }
{SOURCEON}                                  { sourceOn = 1; strcat(cur_line_content, yytext);    }
{TOKENOFF}                                  { tokenOn = 0; strcat(cur_line_content, yytext);     }
{TOKENON}                                   { tokenOn = 1; strcat(cur_line_content, yytext);     }

{COMMENT}                                   { strcat(cur_line_content, yytext);                              }
"/*"				                        { BEGIN(MULTILINE_COMMENT); strcat(cur_line_content, yytext);    }
<MULTILINE_COMMENT>[^*\n]*                  { strcat(cur_line_content, yytext);                              }
<MULTILINE_COMMENT>"*"+[^*/\n]*             { strcat(cur_line_content, yytext);                              }
<MULTILINE_COMMENT>\n 		                { newline();                                                    }
<MULTILINE_COMMENT>"*"+"/"	                { BEGIN(INITIAL); strcat(cur_line_content,yytext);              }

{ZERO}                                      { strcat(cur_line_content, yytext); return TOKEN_INTEGER;        }
{VALID_INTEGER}	                            { strcat(cur_line_content, yytext); return TOKEN_INTEGER;        }
{DOUBLE}                                    { strcat(cur_line_content, yytext); return TOKEN_DOUBLE;         }
{ZERO_DOUBLE}                               { strcat(cur_line_content, yytext); return TOKEN_DOUBLE;         }
{NO_ZERO_DOUBLE}                            { strcat(cur_line_content, yytext); return TOKEN_DOUBLE;         }
{VALID_SCIENTIFIC_NOTATION}                 { strcat(cur_line_content, yytext); return TOKEN_SCI_NOT;        }
{CHARACTER}                                 { strcat(cur_line_content, yytext); return TOKEN_CHARACTER;      }
{CHARACTER_SPACES}                          { strcat(cur_line_content, yytext); return TOKEN_CHARACTER;      }
{STRING}                                    { strcat(cur_line_content, yytext); return TOKEN_STRING;         }

{BACKSLASHES}                               { raise_error(); return 0; }
{INVALID_INTEGER}                           { raise_error(); return 0; }
{INVALID_DOUBLE}                            { raise_error(); return 0; }
{INVALID_SCIENTIFIC_NOTATION}               { raise_error(); return 0; }
{MULTI_CHARACTER}                           { raise_error(); return 0; }
{UNINFLECTED_TERM_CHAR}                     { raise_error(); return 0; }
{UNINFLECTED_TERM_STRING}                   { raise_error(); return 0; }

[\n]                                        { newline();                                                     }
[ \t\r]+                                    { strcat(cur_line_content, yytext);                              }

"true"                                      { strcat(cur_line_content, yytext); return RESVRD_TRUE;          }
"false"                                     { strcat(cur_line_content, yytext); return RESVRD_FALSE;         }
"null"                                      { strcat(cur_line_content, yytext); return RESVRD_NULL;          }

"bool"                                      { BEGIN(VARIABLE_ASSIGNMENT); strcat(cur_line_content, yytext); return DATATYPE_BOOL;        }
"int"                                       { BEGIN(VARIABLE_ASSIGNMENT); strcat(cur_line_content, yytext); return DATATYPE_INT;         }
"double"                                    { BEGIN(VARIABLE_ASSIGNMENT); strcat(cur_line_content, yytext); return DATATYPE_DOUBLE;      }
"char"                                      { BEGIN(VARIABLE_ASSIGNMENT); strcat(cur_line_content, yytext); return DATATYPE_CHAR;        }
"float"                                     { BEGIN(VARIABLE_ASSIGNMENT); strcat(cur_line_content, yytext); return DATATYPE_FLOAT;       }
<VARIABLE_ASSIGNMENT>"="			        { BEGIN(INITIAL);             strcat(cur_line_content, yytext); return ASSIGN_EQUAL;         }
<VARIABLE_ASSIGNMENT>";"			        { BEGIN(INITIAL);             strcat(cur_line_content, yytext); return SEMICOLON;            }
<VARIABLE_ASSIGNMENT>{IDENTIFIER}           { BEGIN(INITIAL);             strcat(cur_line_content, yytext); return TOKEN_IDENTIFIER;     }
<VARIABLE_ASSIGNMENT>"*"			        { strcat(cur_line_content, yytext); return MULTIPLE;                                         }
<VARIABLE_ASSIGNMENT>[ \t\r]+   	        { strcat(cur_line_content, yytext);                                                          }
<VARIABLE_ASSIGNMENT>{LIST_OF_KEYWORD}	    { raise_error(); return 0;                                                                   }
<VARIABLE_ASSIGNMENT>.			            { raise_error(); return 0;                                                                   }

"void"                                      { strcat(cur_line_content, yytext); return VOID;                 }
"for"                                       { strcat(cur_line_content, yytext); return FOR;                  }
"do"                                        { strcat(cur_line_content, yytext); return DO;                   }
"while"                                     { strcat(cur_line_content, yytext); return WHILE;                }
"break"                                     { strcat(cur_line_content, yytext); return BREAK;                }
"continue"                                  { strcat(cur_line_content, yytext); return CONTINUE;             }
"if"                                        { strcat(cur_line_content, yytext); return IF;                   }
"else"                                      { strcat(cur_line_content, yytext); return ELSE;                 }
"auto"                                      { strcat(cur_line_content, yytext); return AUTO;                 }            
"const"                                     { strcat(cur_line_content, yytext); return CONST;                }
"static"                                    { strcat(cur_line_content, yytext); return STATIC;               }
"union"                                     { strcat(cur_line_content, yytext); return UNION;                }
"enum"                                      { strcat(cur_line_content, yytext); return ENUM;                 }
"goto"                                      { strcat(cur_line_content, yytext); return GOTO;                 }
"register"                                  { strcat(cur_line_content, yytext); return REGISTER;             }
"sizeof"                                    { strcat(cur_line_content, yytext); return SIZEOF;               }
"typedef"                                   { strcat(cur_line_content, yytext); return TYPEDEF;              }
"volatile"                                  { strcat(cur_line_content, yytext); return VOLATILE;             }
"extern"                                    { strcat(cur_line_content, yytext); return EXTERN;               }
"return"                                    { strcat(cur_line_content, yytext); return RETURN;               }
"struct"                                    { strcat(cur_line_content, yytext); return STRUCT;               }
"switch"                                    { strcat(cur_line_content, yytext); return SWITCH;               }
"case"                                      { strcat(cur_line_content, yytext); return CASE;                 }
"default"                                   { strcat(cur_line_content, yytext); return DEFAULT;              }

"+"                                         { strcat(cur_line_content, yytext); return PLUS;                 }
"-"                                         { strcat(cur_line_content, yytext); return MINUS;                }
"*"                                         { strcat(cur_line_content, yytext); return MULTIPLE;             }
"/"                                         { strcat(cur_line_content, yytext); return DIVIDE;               }
"%"                                         { strcat(cur_line_content, yytext); return MOD;                  }
"++"                                        { strcat(cur_line_content, yytext); return INCREMENT;            }
"--"                                        { strcat(cur_line_content, yytext); return DECREMENT;            }    
"<"                                         { strcat(cur_line_content, yytext); return LESS;                 }
"<="                                        { strcat(cur_line_content, yytext); return LESS_THAN;            }
">"                                         { strcat(cur_line_content, yytext); return GREATER;              }
">="                                        { strcat(cur_line_content, yytext); return GREATER_THAN;         }
"=="                                        { strcat(cur_line_content, yytext); return EQUAL_TO;             }
"!="                                        { strcat(cur_line_content, yytext); return NOT_EQUAL_TO;         }
"="                                         { strcat(cur_line_content, yytext); return ASSIGN_EQUAL;         }
"&&"                                        { strcat(cur_line_content, yytext); return LOGICAL_AND;          }
"||"                                        { strcat(cur_line_content, yytext); return LOGICAL_OR;           }
"!"                                         { strcat(cur_line_content, yytext); return LOGICAL_NOT;          }
"&"                                         { strcat(cur_line_content, yytext); return BITWISE_AND;          }
"|"                                         { strcat(cur_line_content, yytext); return BITWISE_OR;           }
"^"                                         { strcat(cur_line_content, yytext); return BITWISE_XOR;          }
"~"                                         { strcat(cur_line_content, yytext); return BITWISE_COMPLEMENT;   }
"<<"                                        { strcat(cur_line_content, yytext); return LEFT_SHIFT;           }
">>"                                        { strcat(cur_line_content, yytext); return RIGHT_SHIFT;          }

"`"                                         { strcat(cur_line_content, yytext); return GRAVE_ACCENT;         }
"#"                                         { strcat(cur_line_content, yytext); return POUND;                }
"$"                                         { strcat(cur_line_content, yytext); return DOLLAR;               }
":"			                                { strcat(cur_line_content, yytext); return COLON;                }
";"				                            { strcat(cur_line_content, yytext); return SEMICOLON;            }
","				                            { strcat(cur_line_content, yytext); return COMMA;                }
"."				                            { strcat(cur_line_content, yytext); return DOT;                  }
"["				                            { strcat(cur_line_content, yytext); return LEFT_SQUARE_BRACKET;  }
"]"				                            { strcat(cur_line_content, yytext); return RIGHT_SQUARE_BRACKET; }
"("				                            { strcat(cur_line_content, yytext); return LEFT_BRACKET;         }
")"				                            { strcat(cur_line_content, yytext); return RIGHT_BRACKET;        }
"{"				                            { strcat(cur_line_content, yytext); return LEFT_CURLY_BRACKET;   }
"}"				                            { strcat(cur_line_content, yytext); return RIGHT_CURLY_BRACKET;  }
"@"                                         { strcat(cur_line_content, yytext); return AT_SIGN;              }

"fclose"		                            { strcat(cur_line_content, yytext); return FCLOSE;               }
"clearerr"		                            { strcat(cur_line_content, yytext); return CLEARERR;             }
"feof"			                            { strcat(cur_line_content, yytext); return FEOF;                 }           
"ferror"                                    { strcat(cur_line_content, yytext); return FERROR;               } 
"fflush"		                            { strcat(cur_line_content, yytext); return FFLUSH;               }
"fgetpos"                                   { strcat(cur_line_content, yytext); return FGETPOS;              }
"fopen"                                     { strcat(cur_line_content, yytext); return FOPEN;                }
"fread"                                     { strcat(cur_line_content, yytext); return FREAD;                }
"freopen"                                   { strcat(cur_line_content, yytext); return FREOPEN;              }
"fseek"			                            { strcat(cur_line_content, yytext); return FSEEK;                }
"fsetpos"                                   { strcat(cur_line_content, yytext); return FSETPOS;              }
"ftell"			                            { strcat(cur_line_content, yytext); return FTELL;                }
"fwrite"                                    { strcat(cur_line_content, yytext); return FWRITE;               }
"remove"		                            { strcat(cur_line_content, yytext); return REMOVE;               }
"rename"                                    { strcat(cur_line_content, yytext); return RENAME;               }
"rewind"		                            { strcat(cur_line_content, yytext); return REWIND;               }
"setbuf"                                    { strcat(cur_line_content, yytext); return SETBUF;               }
"setvbuf"                                   { strcat(cur_line_content, yytext); return SETVBUF;              }
"tmpfile"                                   { strcat(cur_line_content, yytext); return TMPFILE;              }
"tmpnam"                                    { strcat(cur_line_content, yytext); return TMPNAM;               }
"fprintf"                                   { strcat(cur_line_content, yytext); return FPRINTF;              }
"printf" 		                            { strcat(cur_line_content, yytext); return PRINTF;               }  
"sprintf" 		                            { strcat(cur_line_content, yytext); return SPRINTF;              }
"vfprintf"                                  { strcat(cur_line_content, yytext); return VFPRINTF;             }
"vprintf"                                   { strcat(cur_line_content, yytext); return VPRINTF;              }
"vsprintf"                                  { strcat(cur_line_content, yytext); return VSPRINTF;             }
"fscanf"                                    { strcat(cur_line_content, yytext); return FSCANF;               }
"scanf"			                            { strcat(cur_line_content, yytext); return SCANF;                }
"sscanf"		                            { strcat(cur_line_content, yytext); return SSCANF;               }
"fgetc"			                            { strcat(cur_line_content, yytext); return FGETC;                }        
"fgets"			                            { strcat(cur_line_content, yytext); return FGETS;                }
"fputc"			                            { strcat(cur_line_content, yytext); return FPUTC;                }
"fputs"			                            { strcat(cur_line_content, yytext); return FPUTS;                }
"getc"			                            { strcat(cur_line_content, yytext); return GETC;                 }
"getchar"		                            { strcat(cur_line_content, yytext); return GETCHAR;              }
"gets"			                            { strcat(cur_line_content, yytext); return GETS;                 }
"putc"			                            { strcat(cur_line_content, yytext); return PUTC;                 }
"putchar"		                            { strcat(cur_line_content, yytext); return PUTCHAR;              }
"puts"			                            { strcat(cur_line_content, yytext); return PUTS;                 }
"ungetc"                                    { strcat(cur_line_content, yytext); return UNGETC;               }
"perror"                                    { strcat(cur_line_content, yytext); return PERROR;               }
"getw"			                            { strcat(cur_line_content, yytext); return GETW;                 }
"putw"			                            { strcat(cur_line_content, yytext); return PUTW;                 }

{IDENTIFIER}                                { strcat(cur_line_content, yytext); return TOKEN_IDENTIFIER;     }
.                                           { raise_error(); return 0;                                       }

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
    if(token >= 1 && token <= 5) fprintf(stdout, "#token key:%s\n", yytext); // datatypes
    if(token >= 6 && token <= 29) fprintf(stdout, "#token key:%s\n", yytext); // keywords
    if(token >= 30 && token <= 52) fprintf(stdout, "#token op:%s\n", yytext); // operators
    if(token >= 53 && token <= 66) {fprintf(stdout, "#token punc:%s\n", yytext); return;} // punctuations
    if(token >= 67 && token <= 109) fprintf(stdout, "#token key:%s\n", yytext); // stdio functions
    if(token >= 110 && token <= 112) fprintf(stdout, "#token key:%s\n", yytext); // reserved words
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
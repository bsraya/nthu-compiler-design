%{
    #include <string.h>
    #include <stdio.h>
    #include "y.tab.h"
    
    void yyerror(const char *msg);

    int sourceOn = 1;
    int tokenOn = 1;
    int current_line_number = 1;
    char current_line_content[256]; 
    
    void yyerror(const char *msg) {
        fprintf(stderr, "Error at line %d: %s\n", current_line_number, yylval.stringval);
        exit(-1);
    }   
%}

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

[\n]                                        { current_line_number++;                                                     }
[ \t\r]+                                    { yylval.stringval = strdup(yytext);                                         }

{SOURCEOFF}                                 { sourceOn = 0; yylval.stringval = strdup(yytext);                           }
{SOURCEON}                                  { sourceOn = 1; yylval.stringval = strdup(yytext);                           }          
{TOKENOFF}                                  { tokenOn = 0;  yylval.stringval = strdup(yytext);                           }
{TOKENON}                                   { tokenOn = 1;  yylval.stringval = strdup(yytext);                           }

{ZERO}                                      { yylval.stringval = strdup(yytext); return TOKEN_INTEGER;               }
{VALID_INTEGER}	                            { yylval.stringval = strdup(yytext); return TOKEN_INTEGER;               }
{DOUBLE}                                    { yylval.stringval = strdup(yytext); return TOKEN_DOUBLE;                }
{ZERO_DOUBLE}                               { yylval.stringval = strdup(yytext); return TOKEN_DOUBLE;                }
{NO_ZERO_DOUBLE}                            { yylval.stringval = strdup(yytext); return TOKEN_DOUBLE;                }
{VALID_SCIENTIFIC_NOTATION}                 { yylval.stringval = strdup(yytext); return TOKEN_SCI_NOT;               }
{CHARACTER}                                 { yylval.stringval = strdup(yytext); return TOKEN_CHARACTER;             }
{CHARACTER_SPACES}                          { yylval.stringval = strdup(yytext); return TOKEN_CHARACTER;             }
{STRING}                                    { yylval.stringval = strdup(yytext); return TOKEN_STRING;                }

{BACKSLASHES}                               { return 0; }
{INVALID_INTEGER}                           { return 0; }
{INVALID_DOUBLE}                            { return 0; }
{INVALID_SCIENTIFIC_NOTATION}               { return 0; }
{MULTI_CHARACTER}                           { return 0; }
{UNINFLECTED_TERM_CHAR}                     { return 0; }
{UNINFLECTED_TERM_STRING}                   { return 0; }

{COMMENT}                                   { yylval.stringval = strdup(yytext);                                         }
"/*"				                        { BEGIN(MULTILINE_COMMENT); yylval.stringval = strdup(yytext);               }
<MULTILINE_COMMENT>[^*\n]*                  { }
<MULTILINE_COMMENT>"*"+[^*/\n]*             { }
<MULTILINE_COMMENT>"*"+"/"	                { BEGIN(INITIAL); strcpy(yylval.stringval,yytext);                          }

"int"                                       { BEGIN(VARIABLE_ASSIGNMENT); yylval.stringval = strdup(yytext); return DATATYPE_INT;          }
"double"                                    { BEGIN(VARIABLE_ASSIGNMENT); yylval.stringval = strdup(yytext); return DATATYPE_DOUBLE;       }
"char"                                      { BEGIN(VARIABLE_ASSIGNMENT); yylval.stringval = strdup(yytext); return DATATYPE_CHAR;         }
"float"                                     { BEGIN(VARIABLE_ASSIGNMENT); yylval.stringval = strdup(yytext); return DATATYPE_FLOAT;        }
<VARIABLE_ASSIGNMENT>"="			        { BEGIN(INITIAL);             yylval.stringval = strdup(yytext); return ASSIGN_EQUAL;          }
<VARIABLE_ASSIGNMENT>";"			        { BEGIN(INITIAL);             yylval.stringval = strdup(yytext); return SEMICOLON;             }
<VARIABLE_ASSIGNMENT>{IDENTIFIER}           { BEGIN(INITIAL);             yylval.stringval = strdup(yytext); return TOKEN_IDENTIFIER;      }
<VARIABLE_ASSIGNMENT>"*"			        {                             yylval.stringval = strdup(yytext); return MULTIPLE;              }
<VARIABLE_ASSIGNMENT>[ \t\r]+   	        { yylval.stringval = strdup(yytext);                                                           }
<VARIABLE_ASSIGNMENT>.			            { return 0; }

"true"                                      { yylval.stringval = strdup(yytext); return TRUE;                 }
"false"                                     { yylval.stringval = strdup(yytext); return FALSE;                }
"void"                                      { yylval.stringval = strdup(yytext); return VOID;                 }
"for"                                       { yylval.stringval = strdup(yytext); return FOR;                  }
"do"                                        { yylval.stringval = strdup(yytext); return DO;                   }
"while"                                     { yylval.stringval = strdup(yytext); return WHILE;                }
"break"                                     { yylval.stringval = strdup(yytext); return BREAK;                }
"continue"                                  { yylval.stringval = strdup(yytext); return CONTINUE;             }
"if"                                        { yylval.stringval = strdup(yytext); return IF;                   }
"else"                                      { yylval.stringval = strdup(yytext); return ELSE;                 }
"auto"                                      { yylval.stringval = strdup(yytext); return AUTO;                 }            
"const"                                     { yylval.stringval = strdup(yytext); return CONST;                }
"static"                                    { yylval.stringval = strdup(yytext); return STATIC;               }
"union"                                     { yylval.stringval = strdup(yytext); return UNION;                }
"enum"                                      { yylval.stringval = strdup(yytext); return ENUM;                 }
"goto"                                      { yylval.stringval = strdup(yytext); return GOTO;                 }
"register"                                  { yylval.stringval = strdup(yytext); return REGISTER;             }
"sizeof"                                    { yylval.stringval = strdup(yytext); return SIZEOF;               }
"typedef"                                   { yylval.stringval = strdup(yytext); return TYPEDEF;              }
"volatile"                                  { yylval.stringval = strdup(yytext); return VOLATILE;             }
"extern"                                    { yylval.stringval = strdup(yytext); return EXTERN;               }
"return"                                    { yylval.stringval = strdup(yytext); return RETURN;               }
"struct"                                    { yylval.stringval = strdup(yytext); return STRUCT;               }
"switch"                                    { yylval.stringval = strdup(yytext); return SWITCH;               }
"case"                                      { yylval.stringval = strdup(yytext); return CASE;                 }
"default"                                   { yylval.stringval = strdup(yytext); return DEFAULT;              }

"+"                                         { yylval.stringval = strdup(yytext); return PLUS;                 }
"-"                                         { yylval.stringval = strdup(yytext); return MINUS;                }
"*"                                         { yylval.stringval = strdup(yytext); return MULTIPLE;             }
"/"                                         { yylval.stringval = strdup(yytext); return DIVIDE;               }
"%"                                         { yylval.stringval = strdup(yytext); return MOD;                  }
"++"                                        { yylval.stringval = strdup(yytext); return INCREMENT;            }
"--"                                        { yylval.stringval = strdup(yytext); return DECREMENT;            }    
"<"                                         { yylval.stringval = strdup(yytext); return LESS_THAN;                 }
"<="                                        { yylval.stringval = strdup(yytext); return LESS_EQUAL_THAN;            }
">"                                         { yylval.stringval = strdup(yytext); return GREATER_THAN;              }
">="                                        { yylval.stringval = strdup(yytext); return GREATER_EQUAL_THAN;         }
"=="                                        { yylval.stringval = strdup(yytext); return EQUAL_TO;             }
"!="                                        { yylval.stringval = strdup(yytext); return NOT_EQUAL_TO;         }
"="                                         { yylval.stringval = strdup(yytext); return ASSIGN_EQUAL;         }
"&&"                                        { yylval.stringval = strdup(yytext); return LOGICAL_AND;          }
"||"                                        { yylval.stringval = strdup(yytext); return LOGICAL_OR;           }
"!"                                         { yylval.stringval = strdup(yytext); return LOGICAL_NOT;          }
"&"                                         { yylval.stringval = strdup(yytext); return BITWISE_AND;          }
"|"                                         { yylval.stringval = strdup(yytext); return BITWISE_OR;           }
"^"                                         { yylval.stringval = strdup(yytext); return BITWISE_XOR;          }
"~"                                         { yylval.stringval = strdup(yytext); return BITWISE_COMPLEMENT;   }
"<<"                                        { yylval.stringval = strdup(yytext); return LEFT_SHIFT;           }
">>"                                        { yylval.stringval = strdup(yytext); return RIGHT_SHIFT;          }

"`"                                         { yylval.stringval = strdup(yytext); return GRAVE_ACCENT;         }
"#"                                         { yylval.stringval = strdup(yytext); return POUND;                }
"$"                                         { yylval.stringval = strdup(yytext); return DOLLAR;               }
":"			                                { yylval.stringval = strdup(yytext); return COLON;                }
";"				                            { yylval.stringval = strdup(yytext); return SEMICOLON;            }
","				                            { yylval.stringval = strdup(yytext); return COMMA;                }
"."				                            { yylval.stringval = strdup(yytext); return DOT;                  }
"["				                            { yylval.stringval = strdup(yytext); return LEFT_SQUARE_BRACKET;  }
"]"				                            { yylval.stringval = strdup(yytext); return RIGHT_SQUARE_BRACKET; }
"("				                            { yylval.stringval = strdup(yytext); return LEFT_BRACKET;         }
")"				                            { yylval.stringval = strdup(yytext); return RIGHT_BRACKET;        }
"{"				                            { yylval.stringval = strdup(yytext); return LEFT_CURLY_BRACKET;   }
"}"				                            { yylval.stringval = strdup(yytext); return RIGHT_CURLY_BRACKET;  }
"@"                                         { yylval.stringval = strdup(yytext); return AT_SIGN;              }


{IDENTIFIER}                                { yylval.stringval = strdup(yytext); return TOKEN_IDENTIFIER;     }
.                                           { return 0; }

%%

int yywrap() {
    return 1;
} 
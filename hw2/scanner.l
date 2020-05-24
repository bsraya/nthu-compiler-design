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

[\n]                                        { current_line_number++;                                                    }
[ \t\r]+                                    { strcpy(yylval.stringval, yytext);                                         }

{SOURCEOFF}                                 { sourceOn = 0; strcpy(yylval.stringval, yytext);                           }
{SOURCEON}                                  { sourceOn = 1; strcpy(yylval.stringval, yytext);                           }          
{TOKENOFF}                                  { tokenOn = 0;  strcpy(yylval.stringval, yytext);                           }
{TOKENON}                                   { tokenOn = 1;  strcpy(yylval.stringval, yytext);                           }

{ZERO}                                      { strcpy(yylval.stringval, yytext); return TOKEN_INTEGER;               }
{VALID_INTEGER}	                            { strcpy(yylval.stringval, yytext); return TOKEN_INTEGER;                }
{DOUBLE}                                    { strcpy(yylval.stringval, yytext); return TOKEN_DOUBLE;                }
{ZERO_DOUBLE}                               { strcpy(yylval.stringval, yytext); return TOKEN_DOUBLE;                }
{NO_ZERO_DOUBLE}                            { strcpy(yylval.stringval, yytext); return TOKEN_DOUBLE;                }
{VALID_SCIENTIFIC_NOTATION}                 { strcpy(yylval.stringval, yytext); return TOKEN_SCI_NOT;               }
{CHARACTER}                                 { strcpy(yylval.stringval, yytext); return TOKEN_CHARACTER;             }
{CHARACTER_SPACES}                          { strcpy(yylval.stringval, yytext); return TOKEN_CHARACTER;             }
{STRING}                                    { strcpy(yylval.stringval, yytext); return TOKEN_STRING;                }

{BACKSLASHES}                               { return 0; }
{INVALID_INTEGER}                           { return 0; }
{INVALID_DOUBLE}                            { return 0; }
{INVALID_SCIENTIFIC_NOTATION}               { return 0; }
{MULTI_CHARACTER}                           { return 0; }
{UNINFLECTED_TERM_CHAR}                     { return 0; }
{UNINFLECTED_TERM_STRING}                   { return 0; }

{COMMENT}                                   { strcpy(yylval.stringval, yytext);                                         }
"/*"				                        { BEGIN(MULTILINE_COMMENT); strcpy(yylval.stringval, yytext);               }
<MULTILINE_COMMENT>[^*\n]*                  { }
<MULTILINE_COMMENT>"*"+[^*/\n]*             { }
<MULTILINE_COMMENT>\n 		                { current_line_number++;                                                    }
<MULTILINE_COMMENT>"*"+"/"	                { BEGIN(INITIAL); strcpy(yylval.stringval,yytext);                          }

"int"                                       { BEGIN(VARIABLE_ASSIGNMENT); strcpy(yylval.stringval, yytext); return DATATYPE_INT;          }
"double"                                    { BEGIN(VARIABLE_ASSIGNMENT); strcpy(yylval.stringval, yytext); return DATATYPE_DOUBLE;       }
"char"                                      { BEGIN(VARIABLE_ASSIGNMENT); strcpy(yylval.stringval, yytext); return DATATYPE_CHAR;         }
"float"                                     { BEGIN(VARIABLE_ASSIGNMENT); strcpy(yylval.stringval, yytext); return DATATYPE_FLOAT;        }
<VARIABLE_ASSIGNMENT>"="			        { BEGIN(INITIAL);             strcpy(yylval.stringval, yytext); return ASSIGN_EQUAL;          }
<VARIABLE_ASSIGNMENT>";"			        { BEGIN(INITIAL);             strcpy(yylval.stringval, yytext); return SEMICOLON;             }
<VARIABLE_ASSIGNMENT>{IDENTIFIER}           { BEGIN(INITIAL);             strcpy(yylval.stringval, yytext); return TOKEN_IDENTIFIER;      }
<VARIABLE_ASSIGNMENT>"*"			        {                             strcpy(yylval.stringval, yytext); return MULTIPLE;              }
<VARIABLE_ASSIGNMENT>[ \t\r]+   	        { strcpy(yylval.stringval, yytext);                                                           }
<VARIABLE_ASSIGNMENT>{LIST_OF_KEYWORD}	    { return 0;                                                                                   }
<VARIABLE_ASSIGNMENT>.			            { return 0;                                                                                   }

"true"                                      { strcpy(yylval.stringval, yytext); return TRUE;                 }
"false"                                     { strcpy(yylval.stringval, yytext); return FALSE;                }
"void"                                      { strcpy(yylval.stringval, yytext); return VOID;                 }
"for"                                       { strcpy(yylval.stringval, yytext); return FOR;                  }
"do"                                        { strcpy(yylval.stringval, yytext); return DO;                   }
"while"                                     { strcpy(yylval.stringval, yytext); return WHILE;                }
"break"                                     { strcpy(yylval.stringval, yytext); return BREAK;                }
"continue"                                  { strcpy(yylval.stringval, yytext); return CONTINUE;             }
"if"                                        { strcpy(yylval.stringval, yytext); return IF;                   }
"else"                                      { strcpy(yylval.stringval, yytext); return ELSE;                 }
"auto"                                      { strcpy(yylval.stringval, yytext); return AUTO;                 }            
"const"                                     { strcpy(yylval.stringval, yytext); return CONST;                }
"static"                                    { strcpy(yylval.stringval, yytext); return STATIC;               }
"union"                                     { strcpy(yylval.stringval, yytext); return UNION;                }
"enum"                                      { strcpy(yylval.stringval, yytext); return ENUM;                 }
"goto"                                      { strcpy(yylval.stringval, yytext); return GOTO;                 }
"register"                                  { strcpy(yylval.stringval, yytext); return REGISTER;             }
"sizeof"                                    { strcpy(yylval.stringval, yytext); return SIZEOF;               }
"typedef"                                   { strcpy(yylval.stringval, yytext); return TYPEDEF;              }
"volatile"                                  { strcpy(yylval.stringval, yytext); return VOLATILE;             }
"extern"                                    { strcpy(yylval.stringval, yytext); return EXTERN;               }
"return"                                    { strcpy(yylval.stringval, yytext); return RETURN;               }
"struct"                                    { strcpy(yylval.stringval, yytext); return STRUCT;               }
"switch"                                    { strcpy(yylval.stringval, yytext); return SWITCH;               }
"case"                                      { strcpy(yylval.stringval, yytext); return CASE;                 }
"default"                                   { strcpy(yylval.stringval, yytext); return DEFAULT;              }

"+"                                         { strcpy(yylval.stringval, yytext); return PLUS;                 }
"-"                                         { strcpy(yylval.stringval, yytext); return MINUS;                }
"*"                                         { strcpy(yylval.stringval, yytext); return MULTIPLE;             }
"/"                                         { strcpy(yylval.stringval, yytext); return DIVIDE;               }
"%"                                         { strcpy(yylval.stringval, yytext); return MOD;                  }
"++"                                        { strcpy(yylval.stringval, yytext); return INCREMENT;            }
"--"                                        { strcpy(yylval.stringval, yytext); return DECREMENT;            }    
"<"                                         { strcpy(yylval.stringval, yytext); return LESS_THAN;                 }
"<="                                        { strcpy(yylval.stringval, yytext); return LESS_EQUAL_THAN;            }
">"                                         { strcpy(yylval.stringval, yytext); return GREATER_THAN;              }
">="                                        { strcpy(yylval.stringval, yytext); return GREATER_EQUAL_THAN;         }
"=="                                        { strcpy(yylval.stringval, yytext); return EQUAL_TO;             }
"!="                                        { strcpy(yylval.stringval, yytext); return NOT_EQUAL_TO;         }
"="                                         { strcpy(yylval.stringval, yytext); return ASSIGN_EQUAL;         }
"&&"                                        { strcpy(yylval.stringval, yytext); return LOGICAL_AND;          }
"||"                                        { strcpy(yylval.stringval, yytext); return LOGICAL_OR;           }
"!"                                         { strcpy(yylval.stringval, yytext); return LOGICAL_NOT;          }
"&"                                         { strcpy(yylval.stringval, yytext); return BITWISE_AND;          }
"|"                                         { strcpy(yylval.stringval, yytext); return BITWISE_OR;           }
"^"                                         { strcpy(yylval.stringval, yytext); return BITWISE_XOR;          }
"~"                                         { strcpy(yylval.stringval, yytext); return BITWISE_COMPLEMENT;   }
"<<"                                        { strcpy(yylval.stringval, yytext); return LEFT_SHIFT;           }
">>"                                        { strcpy(yylval.stringval, yytext); return RIGHT_SHIFT;          }

"`"                                         { strcpy(yylval.stringval, yytext); return GRAVE_ACCENT;         }
"#"                                         { strcpy(yylval.stringval, yytext); return POUND;                }
"$"                                         { strcpy(yylval.stringval, yytext); return DOLLAR;               }
":"			                                { strcpy(yylval.stringval, yytext); return COLON;                }
";"				                            { strcpy(yylval.stringval, yytext); return SEMICOLON;            }
","				                            { strcpy(yylval.stringval, yytext); return COMMA;                }
"."				                            { strcpy(yylval.stringval, yytext); return DOT;                  }
"["				                            { strcpy(yylval.stringval, yytext); return LEFT_SQUARE_BRACKET;  }
"]"				                            { strcpy(yylval.stringval, yytext); return RIGHT_SQUARE_BRACKET; }
"("				                            { strcpy(yylval.stringval, yytext); return LEFT_BRACKET;         }
")"				                            { strcpy(yylval.stringval, yytext); return RIGHT_BRACKET;        }
"{"				                            { strcpy(yylval.stringval, yytext); return LEFT_CURLY_BRACKET;   }
"}"				                            { strcpy(yylval.stringval, yytext); return RIGHT_CURLY_BRACKET;  }
"@"                                         { strcpy(yylval.stringval, yytext); return AT_SIGN;              }


{IDENTIFIER}                                { strcpy(yylval.stringval, yytext); return TOKEN_IDENTIFIER;     }
.                                           { return 0; }

%%

int yywrap() {
    return 1;
} 
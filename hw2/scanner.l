%top{
    #include <string.h>

    void raise_error();
    void yyerror(const *msg)

    int sourceOn = 1;
    int tokenOn = 1;
    int current_line_number = 1;
    char current_line_content[256]; 

    int yywrap() {return 1;} 
    
    void yyerror(const *msg) {
        fprint(stderr, "Error at line %d: %s\n", current_line_number, current_line_content);
        exit(EXIT_FAILURE);
    }
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
[ \t\r]+                                    { strcat(cur_line_content, yytext);                                         }

{SOURCEOFF}                                 { sourceOn = 0; strcat(cur_line_content, yytext);                           }
{SOURCEON}                                  { sourceOn = 1; strcat(cur_line_content, yytext);                           }          
{TOKENOFF}                                  { tokenOn = 0;  strcat(cur_line_content, yytext);                           }
{TOKENON}                                   { tokenOn = 1;  strcat(cur_line_content, yytext);                           }

{IDENTIFIER}                                { strcat(cur_line_content, yytext); return TOKEN_IDENTIFIER;      }
{ZERO}                                      { strcat(cur_line_content, yytext); return TOKEN_INTEGER;         }
{VALID_INTEGER}	                            { strcat(cur_line_content, yytext); return TOKEN_INTEGER;         }
{DOUBLE}                                    { strcat(cur_line_content, yytext); return TOKEN_DOUBLE;          }
{ZERO_DOUBLE}                               { strcat(cur_line_content, yytext); return TOKEN_DOUBLE;          }
{NO_ZERO_DOUBLE}                            { strcat(cur_line_content, yytext); return TOKEN_DOUBLE;          }
{VALID_SCIENTIFIC_NOTATION}                 { strcat(cur_line_content, yytext); return TOKEN_SCI_NOT;         }
{CHARACTER}                                 { strcat(cur_line_content, yytext); return TOKEN_CHARACTER;       }
{CHARACTER_SPACES}                          { strcat(cur_line_content, yytext); return TOKEN_CHARACTER;       }
{STRING}                                    { strcat(cur_line_content, yytext); return TOKEN_STRING;          }


{COMMENT}                                   { strcat(cur_line_content, yytext);                                         }
"/*"				                        { BEGIN(MULTILINE_COMMENT); strcat(cur_line_content, yytext);               }
<MULTILINE_COMMENT>[^*\n]*                  { strcat(cur_line_content, yytext);                                         }
<MULTILINE_COMMENT>"*"+[^*/\n]*             { strcat(cur_line_content, yytext);                                         }
<MULTILINE_COMMENT>\n 		                { newline();                                                                }
<MULTILINE_COMMENT>"*"+"/"	                { BEGIN(INITIAL); strcat(cur_line_content,yytext);                          }

"bool"                                      { BEGIN(VARIABLE_ASSIGNMENT); strcat(cur_line_content, yytext); return DATATYPE_BOOL;         }
"int"                                       { BEGIN(VARIABLE_ASSIGNMENT); strcat(cur_line_content, yytext); return DATATYPE_INT;          }
"double"                                    { BEGIN(VARIABLE_ASSIGNMENT); strcat(cur_line_content, yytext); return DATATYPE_DOUBLE;       }
"char"                                      { BEGIN(VARIABLE_ASSIGNMENT); strcat(cur_line_content, yytext); return DATATYPE_CHAR;         }
"float"                                     { BEGIN(VARIABLE_ASSIGNMENT); strcat(cur_line_content, yytext); return DATATYPE_FLOAT;        }
<VARIABLE_ASSIGNMENT>"="			        { BEGIN(INITIAL);             strcat(cur_line_content, yytext); return ASSIGN_EQUAL;          }
<VARIABLE_ASSIGNMENT>";"			        { BEGIN(INITIAL);             strcat(cur_line_content, yytext); return SEMICOLON;             }
<VARIABLE_ASSIGNMENT>{IDENTIFIER}           { BEGIN(INITIAL);             strcat(cur_line_content, yytext); return TOKEN_IDENTIFIER;      }
<VARIABLE_ASSIGNMENT>"*"			        {                             strcat(cur_line_content, yytext); return MULTIPLE;              }
<VARIABLE_ASSIGNMENT>[ \t\r]+   	        { strcat(cur_line_content, yytext);                                                                     }
<VARIABLE_ASSIGNMENT>{LIST_OF_KEYWORD}	    { raise_error(); return 0;                                                                              }
<VARIABLE_ASSIGNMENT>.			            { raise_error(); return 0;                                                                              }

"true"                                      { strcat(cur_line_content, yytext); return RESERVED_TRUE;        }
"false"                                     { strcat(cur_line_content, yytext); return RESERVED_FALSE;       }
"null"                                      { strcat(cur_line_content, yytext); return RESERVED_NULL;        }

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

"fclose"		                            { strcat(cur_line_content, yytext); }
"clearerr"		                            { strcat(cur_line_content, yytext); }
"feof"			                            { strcat(cur_line_content, yytext); }           
"ferror"                                    { strcat(cur_line_content, yytext); } 
"fflush"		                            { strcat(cur_line_content, yytext); }
"fgetpos"                                   { strcat(cur_line_content, yytext); }
"fopen"                                     { strcat(cur_line_content, yytext); }
"fread"                                     { strcat(cur_line_content, yytext); }
"freopen"                                   { strcat(cur_line_content, yytext); }
"fseek"			                            { strcat(cur_line_content, yytext); }
"fsetpos"                                   { strcat(cur_line_content, yytext); }
"ftell"			                            { strcat(cur_line_content, yytext); }
"fwrite"                                    { strcat(cur_line_content, yytext); }
"remove"		                            { strcat(cur_line_content, yytext); }
"rename"                                    { strcat(cur_line_content, yytext); }
"rewind"		                            { strcat(cur_line_content, yytext); }
"setbuf"                                    { strcat(cur_line_content, yytext); }
"setvbuf"                                   { strcat(cur_line_content, yytext); }
"tmpfile"                                   { strcat(cur_line_content, yytext); }
"tmpnam"                                    { strcat(cur_line_content, yytext); }
"fprintf"                                   { strcat(cur_line_content, yytext); }
"printf" 		                            { strcat(cur_line_content, yytext); }  
"sprintf" 		                            { strcat(cur_line_content, yytext); }
"vfprintf"                                  { strcat(cur_line_content, yytext); }
"vprintf"                                   { strcat(cur_line_content, yytext); }
"vsprintf"                                  { strcat(cur_line_content, yytext); }
"fscanf"                                    { strcat(cur_line_content, yytext); }
"scanf"			                            { strcat(cur_line_content, yytext); }
"sscanf"		                            { strcat(cur_line_content, yytext); }
"fgetc"			                            { strcat(cur_line_content, yytext); }        
"fgets"			                            { strcat(cur_line_content, yytext); }
"fputc"			                            { strcat(cur_line_content, yytext); }
"fputs"			                            { strcat(cur_line_content, yytext); }
"getc"			                            { strcat(cur_line_content, yytext); }
"getchar"		                            { strcat(cur_line_content, yytext); }
"gets"			                            { strcat(cur_line_content, yytext); }
"putc"			                            { strcat(cur_line_content, yytext); }
"putchar"		                            { strcat(cur_line_content, yytext); }
"puts"			                            { strcat(cur_line_content, yytext); }
"ungetc"                                    { strcat(cur_line_content, yytext); }
"perror"                                    { strcat(cur_line_content, yytext); }
"getw"			                            { strcat(cur_line_content, yytext); }
"putw"			                            { strcat(cur_line_content, yytext); }

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

{BACKSLASHES}                               { raise_error(); return 0; }
{INVALID_INTEGER}                           { raise_error(); return 0; }
{INVALID_DOUBLE}                            { raise_error(); return 0; }
{INVALID_SCIENTIFIC_NOTATION}               { raise_error(); return 0; }
{MULTI_CHARACTER}                           { raise_error(); return 0; }
{UNINFLECTED_TERM_CHAR}                     { raise_error(); return 0; }
{UNINFLECTED_TERM_STRING}                   { raise_error(); return 0; }
.                                           { raise_error(); return 0; }
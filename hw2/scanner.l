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
[ \t\r]+                                    return;

{SOURCEOFF}                                 { sourceOn = 0;                           }
{SOURCEON}                                  { sourceOn = 1;                           }          
{TOKENOFF}                                  { tokenOn = 0;                            }
{TOKENON}                                   { tokenOn = 1;                            }

{IDENTIFIER}                                { return TOKEN_IDENTIFIER;      }
{ZERO}                                      { return TOKEN_INTEGER;         }
{VALID_INTEGER}	                            { return TOKEN_INTEGER;         }
{DOUBLE}                                    { return TOKEN_DOUBLE;          }
{ZERO_DOUBLE}                               { return TOKEN_DOUBLE;          }
{NO_ZERO_DOUBLE}                            { return TOKEN_DOUBLE;          }
{VALID_SCIENTIFIC_NOTATION}                 { return TOKEN_SCI_NOT;         }
{CHARACTER}                                 { return TOKEN_CHARACTER;       }
{CHARACTER_SPACES}                          { return TOKEN_CHARACTER;       }
{STRING}                                    { return TOKEN_STRING;          }


{COMMENT}                                   {                                         }
"/*"				                        { BEGIN(MULTILINE_COMMENT);               }
<MULTILINE_COMMENT>[^*\n]*                  {                                         }
<MULTILINE_COMMENT>"*"+[^*/\n]*             {                                         }
<MULTILINE_COMMENT>\n 		                { newline();                                                                }
<MULTILINE_COMMENT>"*"+"/"	                { BEGIN(INITIAL); strcat(cur_line_content,yytext);                          }

"bool"                                      { BEGIN(VARIABLE_ASSIGNMENT); return DATATYPE_BOOL;         }
"int"                                       { BEGIN(VARIABLE_ASSIGNMENT); return DATATYPE_INT;          }
"double"                                    { BEGIN(VARIABLE_ASSIGNMENT); return DATATYPE_DOUBLE;       }
"char"                                      { BEGIN(VARIABLE_ASSIGNMENT); return DATATYPE_CHAR;         }
"float"                                     { BEGIN(VARIABLE_ASSIGNMENT); return DATATYPE_FLOAT;        }
<VARIABLE_ASSIGNMENT>"="			        { BEGIN(INITIAL);             return ASSIGN_EQUAL;          }
<VARIABLE_ASSIGNMENT>";"			        { BEGIN(INITIAL);             return SEMICOLON;             }
<VARIABLE_ASSIGNMENT>{IDENTIFIER}           { BEGIN(INITIAL);             return TOKEN_IDENTIFIER;      }
<VARIABLE_ASSIGNMENT>"*"			        {                             return MULTIPLE;              }
<VARIABLE_ASSIGNMENT>[ \t\r]+   	        {                                                                     }
<VARIABLE_ASSIGNMENT>{LIST_OF_KEYWORD}	    { raise_error(); return 0;                                                                              }
<VARIABLE_ASSIGNMENT>.			            { raise_error(); return 0;                                                                              }

"true"                                      { return RESERVED_TRUE;        }
"false"                                     { return RESERVED_FALSE;       }
"null"                                      { return RESERVED_NULL;        }

"void"                                      { return VOID;                 }
"for"                                       { return FOR;                  }
"do"                                        { return DO;                   }
"while"                                     { return WHILE;                }
"break"                                     { return BREAK;                }
"continue"                                  { return CONTINUE;             }
"if"                                        { return IF;                   }
"else"                                      { return ELSE;                 }
"auto"                                      { return AUTO;                 }            
"const"                                     { return CONST;                }
"static"                                    { return STATIC;               }
"union"                                     { return UNION;                }
"enum"                                      { return ENUM;                 }
"goto"                                      { return GOTO;                 }
"register"                                  { return REGISTER;             }
"sizeof"                                    { return SIZEOF;               }
"typedef"                                   { return TYPEDEF;              }
"volatile"                                  { return VOLATILE;             }
"extern"                                    { return EXTERN;               }
"return"                                    { return RETURN;               }
"struct"                                    { return STRUCT;               }
"switch"                                    { return SWITCH;               }
"case"                                      { return CASE;                 }
"default"                                   { return DEFAULT;              }

"fclose"		                            { }
"clearerr"		                            { }
"feof"			                            { }           
"ferror"                                    { } 
"fflush"		                            { }
"fgetpos"                                   { }
"fopen"                                     { }
"fread"                                     { }
"freopen"                                   { }
"fseek"			                            { }
"fsetpos"                                   { }
"ftell"			                            { }
"fwrite"                                    { }
"remove"		                            { }
"rename"                                    { }
"rewind"		                            { }
"setbuf"                                    { }
"setvbuf"                                   { }
"tmpfile"                                   { }
"tmpnam"                                    { }
"fprintf"                                   { }
"printf" 		                            { }  
"sprintf" 		                            { }
"vfprintf"                                  { }
"vprintf"                                   { }
"vsprintf"                                  { }
"fscanf"                                    { }
"scanf"			                            { }
"sscanf"		                            { }
"fgetc"			                            { }        
"fgets"			                            { }
"fputc"			                            { }
"fputs"			                            { }
"getc"			                            { }
"getchar"		                            { }
"gets"			                            { }
"putc"			                            { }
"putchar"		                            { }
"puts"			                            { }
"ungetc"                                    { }
"perror"                                    { }
"getw"			                            { }
"putw"			                            { }

"+"                                         { return PLUS;                 }
"-"                                         { return MINUS;                }
"*"                                         { return MULTIPLE;             }
"/"                                         { return DIVIDE;               }
"%"                                         { return MOD;                  }
"++"                                        { return INCREMENT;            }
"--"                                        { return DECREMENT;            }    
"<"                                         { return LESS;                 }
"<="                                        { return LESS_THAN;            }
">"                                         { return GREATER;              }
">="                                        { return GREATER_THAN;         }
"=="                                        { return EQUAL_TO;             }
"!="                                        { return NOT_EQUAL_TO;         }
"="                                         { return ASSIGN_EQUAL;         }
"&&"                                        { return LOGICAL_AND;          }
"||"                                        { return LOGICAL_OR;           }
"!"                                         { return LOGICAL_NOT;          }
"&"                                         { return BITWISE_AND;          }
"|"                                         { return BITWISE_OR;           }
"^"                                         { return BITWISE_XOR;          }
"~"                                         { return BITWISE_COMPLEMENT;   }
"<<"                                        { return LEFT_SHIFT;           }
">>"                                        { return RIGHT_SHIFT;          }

"`"                                         { return GRAVE_ACCENT;         }
"#"                                         { return POUND;                }
"$"                                         { return DOLLAR;               }
":"			                                { return COLON;                }
";"				                            { return SEMICOLON;            }
","				                            { return COMMA;                }
"."				                            { return DOT;                  }
"["				                            { return LEFT_SQUARE_BRACKET;  }
"]"				                            { return RIGHT_SQUARE_BRACKET; }
"("				                            { return LEFT_BRACKET;         }
")"				                            { return RIGHT_BRACKET;        }
"{"				                            { return LEFT_CURLY_BRACKET;   }
"}"				                            { return RIGHT_CURLY_BRACKET;  }
"@"                                         { return AT_SIGN;              }

{BACKSLASHES}                               { raise_error(); return 0; }
{INVALID_INTEGER}                           { raise_error(); return 0; }
{INVALID_DOUBLE}                            { raise_error(); return 0; }
{INVALID_SCIENTIFIC_NOTATION}               { raise_error(); return 0; }
{MULTI_CHARACTER}                           { raise_error(); return 0; }
{UNINFLECTED_TERM_CHAR}                     { raise_error(); return 0; }
{UNINFLECTED_TERM_STRING}                   { raise_error(); return 0; }
.                                           { raise_error(); return 0; }
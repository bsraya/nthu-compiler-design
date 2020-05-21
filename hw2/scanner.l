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

    int yywrap() {return 1;} 

    void print(int token_type) {
        if(tokenOn == 1) {
            switch(token_type) {
                case(1): /* keywords */
                    fprintf(stdout, "#key:%s", yytext);
                
                case(1): /* operators */
                    fprintf(stdout,"#op:%s\n",yytext);

                case(2): /* punctuations */
                    fprintf(stdout,"#punc:%s\n",yytext);

                case(3): /* identifiers */
                    fprintf(stdout,"#id:%s\n",yytext);

                case(4): /* integers */
                    fprintf(stdout,"#integer:%s\n",yytext);

                case(5): /* double */
                    fprintf(stdout,"#double:%s\n",yytext);

                case(6): /* scientific notations */
                    fprintf(stdout,"#sci:%s\n",yytext);

                case(7): /* character */
                    fprintf(stdout,"#char:%s\n",yytext);

                case(8): /* string */{
                    char text[256];
                    int i;
                    for(i=1;yytext[i]!='\042';i++){
                        text[i-1]=yytext[i];
                    }
                    text[i-1]='\0';
                    fprintf(stdout,"#string:%s\n",text);
                }

            }
        }
    }
    
    void newline() {
        if(sourceOn == 1) {fprintf(stdout, "%d:%s\n", current_line_number, current_line_content);}
        memset(current_line_content, 0, sizeof(current_line_content));
        current_line_number++;
    }
    
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

{IDENTIFIER}                                { strcat(cur_line_content, yytext); print(3); return TOKEN_IDENTIFIER;      }
{ZERO}                                      { strcat(cur_line_content, yytext); print(4); return TOKEN_INTEGER;         }
{VALID_INTEGER}	                            { strcat(cur_line_content, yytext); print(4); return TOKEN_INTEGER;         }
{DOUBLE}                                    { strcat(cur_line_content, yytext); print(5); return TOKEN_DOUBLE;          }
{ZERO_DOUBLE}                               { strcat(cur_line_content, yytext); print(5); return TOKEN_DOUBLE;          }
{NO_ZERO_DOUBLE}                            { strcat(cur_line_content, yytext); print(5); return TOKEN_DOUBLE;          }
{VALID_SCIENTIFIC_NOTATION}                 { strcat(cur_line_content, yytext); print(6); return TOKEN_SCI_NOT;         }
{CHARACTER}                                 { strcat(cur_line_content, yytext); print(7); return TOKEN_CHARACTER;       }
{CHARACTER_SPACES}                          { strcat(cur_line_content, yytext); print(7); return TOKEN_CHARACTER;       }
{STRING}                                    { strcat(cur_line_content, yytext); print(8); return TOKEN_STRING;          }


{COMMENT}                                   { strcat(cur_line_content, yytext);                                         }
"/*"				                        { BEGIN(MULTILINE_COMMENT); strcat(cur_line_content, yytext);               }
<MULTILINE_COMMENT>[^*\n]*                  { strcat(cur_line_content, yytext);                                         }
<MULTILINE_COMMENT>"*"+[^*/\n]*             { strcat(cur_line_content, yytext);                                         }
<MULTILINE_COMMENT>\n 		                { newline();                                                                }
<MULTILINE_COMMENT>"*"+"/"	                { BEGIN(INITIAL); strcat(cur_line_content,yytext);                          }

"bool"                                      { BEGIN(VARIABLE_ASSIGNMENT); strcat(cur_line_content, yytext); print(0); return DATATYPE_BOOL;         }
"int"                                       { BEGIN(VARIABLE_ASSIGNMENT); strcat(cur_line_content, yytext); print(0); return DATATYPE_INT;          }
"double"                                    { BEGIN(VARIABLE_ASSIGNMENT); strcat(cur_line_content, yytext); print(0); return DATATYPE_DOUBLE;       }
"char"                                      { BEGIN(VARIABLE_ASSIGNMENT); strcat(cur_line_content, yytext); print(0); return DATATYPE_CHAR;         }
"float"                                     { BEGIN(VARIABLE_ASSIGNMENT); strcat(cur_line_content, yytext); print(0); return DATATYPE_FLOAT;        }
<VARIABLE_ASSIGNMENT>"="			        { BEGIN(INITIAL);             strcat(cur_line_content, yytext); print(1); return ASSIGN_EQUAL;          }
<VARIABLE_ASSIGNMENT>";"			        { BEGIN(INITIAL);             strcat(cur_line_content, yytext); print(2); return SEMICOLON;             }
<VARIABLE_ASSIGNMENT>{IDENTIFIER}           { BEGIN(INITIAL);             strcat(cur_line_content, yytext); print(3); return TOKEN_IDENTIFIER;      }
<VARIABLE_ASSIGNMENT>"*"			        {                             strcat(cur_line_content, yytext); print(1); return MULTIPLE;              }
<VARIABLE_ASSIGNMENT>[ \t\r]+   	        { strcat(cur_line_content, yytext);                                                                     }
<VARIABLE_ASSIGNMENT>{LIST_OF_KEYWORD}	    { raise_error(); return 0;                                                                              }
<VARIABLE_ASSIGNMENT>.			            { raise_error(); return 0;                                                                              }

"true"                                      { strcat(cur_line_content, yytext); print(0); return RESERVED_TRUE;        }
"false"                                     { strcat(cur_line_content, yytext); print(0); return RESERVED_FALSE;       }
"null"                                      { strcat(cur_line_content, yytext); print(0); return RESERVED_NULL;        }

"void"                                      { strcat(cur_line_content, yytext); print(0); return VOID;                 }
"for"                                       { strcat(cur_line_content, yytext); print(0); return FOR;                  }
"do"                                        { strcat(cur_line_content, yytext); print(0); return DO;                   }
"while"                                     { strcat(cur_line_content, yytext); print(0); return WHILE;                }
"break"                                     { strcat(cur_line_content, yytext); print(0); return BREAK;                }
"continue"                                  { strcat(cur_line_content, yytext); print(0); return CONTINUE;             }
"if"                                        { strcat(cur_line_content, yytext); print(0); return IF;                   }
"else"                                      { strcat(cur_line_content, yytext); print(0); return ELSE;                 }
"auto"                                      { strcat(cur_line_content, yytext); print(0); return AUTO;                 }            
"const"                                     { strcat(cur_line_content, yytext); print(0); return CONST;                }
"static"                                    { strcat(cur_line_content, yytext); print(0); return STATIC;               }
"union"                                     { strcat(cur_line_content, yytext); print(0); return UNION;                }
"enum"                                      { strcat(cur_line_content, yytext); print(0); return ENUM;                 }
"goto"                                      { strcat(cur_line_content, yytext); print(0); return GOTO;                 }
"register"                                  { strcat(cur_line_content, yytext); print(0); return REGISTER;             }
"sizeof"                                    { strcat(cur_line_content, yytext); print(0); return SIZEOF;               }
"typedef"                                   { strcat(cur_line_content, yytext); print(0); return TYPEDEF;              }
"volatile"                                  { strcat(cur_line_content, yytext); print(0); return VOLATILE;             }
"extern"                                    { strcat(cur_line_content, yytext); print(0); return EXTERN;               }
"return"                                    { strcat(cur_line_content, yytext); print(0); return RETURN;               }
"struct"                                    { strcat(cur_line_content, yytext); print(0); return STRUCT;               }
"switch"                                    { strcat(cur_line_content, yytext); print(0); return SWITCH;               }
"case"                                      { strcat(cur_line_content, yytext); print(0); return CASE;                 }
"default"                                   { strcat(cur_line_content, yytext); print(0); return DEFAULT;              }

"fclose"		                            { strcat(cur_line_content, yytext); print(0); }
"clearerr"		                            { strcat(cur_line_content, yytext); print(0); }
"feof"			                            { strcat(cur_line_content, yytext); print(0); }           
"ferror"                                    { strcat(cur_line_content, yytext); print(0); } 
"fflush"		                            { strcat(cur_line_content, yytext); print(0); }
"fgetpos"                                   { strcat(cur_line_content, yytext); print(0); }
"fopen"                                     { strcat(cur_line_content, yytext); print(0); }
"fread"                                     { strcat(cur_line_content, yytext); print(0); }
"freopen"                                   { strcat(cur_line_content, yytext); print(0); }
"fseek"			                            { strcat(cur_line_content, yytext); print(0); }
"fsetpos"                                   { strcat(cur_line_content, yytext); print(0); }
"ftell"			                            { strcat(cur_line_content, yytext); print(0); }
"fwrite"                                    { strcat(cur_line_content, yytext); print(0); }
"remove"		                            { strcat(cur_line_content, yytext); print(0); }
"rename"                                    { strcat(cur_line_content, yytext); print(0); }
"rewind"		                            { strcat(cur_line_content, yytext); print(0); }
"setbuf"                                    { strcat(cur_line_content, yytext); print(0); }
"setvbuf"                                   { strcat(cur_line_content, yytext); print(0); }
"tmpfile"                                   { strcat(cur_line_content, yytext); print(0); }
"tmpnam"                                    { strcat(cur_line_content, yytext); print(0); }
"fprintf"                                   { strcat(cur_line_content, yytext); print(0); }
"printf" 		                            { strcat(cur_line_content, yytext); print(0); }  
"sprintf" 		                            { strcat(cur_line_content, yytext); print(0); }
"vfprintf"                                  { strcat(cur_line_content, yytext); print(0); }
"vprintf"                                   { strcat(cur_line_content, yytext); print(0); }
"vsprintf"                                  { strcat(cur_line_content, yytext); print(0); }
"fscanf"                                    { strcat(cur_line_content, yytext); print(0); }
"scanf"			                            { strcat(cur_line_content, yytext); print(0); }
"sscanf"		                            { strcat(cur_line_content, yytext); print(0); }
"fgetc"			                            { strcat(cur_line_content, yytext); print(0); }        
"fgets"			                            { strcat(cur_line_content, yytext); print(0); }
"fputc"			                            { strcat(cur_line_content, yytext); print(0); }
"fputs"			                            { strcat(cur_line_content, yytext); print(0); }
"getc"			                            { strcat(cur_line_content, yytext); print(0); }
"getchar"		                            { strcat(cur_line_content, yytext); print(0); }
"gets"			                            { strcat(cur_line_content, yytext); print(0); }
"putc"			                            { strcat(cur_line_content, yytext); print(0); }
"putchar"		                            { strcat(cur_line_content, yytext); print(0); }
"puts"			                            { strcat(cur_line_content, yytext); print(0); }
"ungetc"                                    { strcat(cur_line_content, yytext); print(0); }
"perror"                                    { strcat(cur_line_content, yytext); print(0); }
"getw"			                            { strcat(cur_line_content, yytext); print(0); }
"putw"			                            { strcat(cur_line_content, yytext); print(0); }

"+"                                         { strcat(cur_line_content, yytext); print(1); return PLUS;                 }
"-"                                         { strcat(cur_line_content, yytext); print(1); return MINUS;                }
"*"                                         { strcat(cur_line_content, yytext); print(1); return MULTIPLE;             }
"/"                                         { strcat(cur_line_content, yytext); print(1); return DIVIDE;               }
"%"                                         { strcat(cur_line_content, yytext); print(1); return MOD;                  }
"++"                                        { strcat(cur_line_content, yytext); print(1); return INCREMENT;            }
"--"                                        { strcat(cur_line_content, yytext); print(1); return DECREMENT;            }    
"<"                                         { strcat(cur_line_content, yytext); print(1); return LESS;                 }
"<="                                        { strcat(cur_line_content, yytext); print(1); return LESS_THAN;            }
">"                                         { strcat(cur_line_content, yytext); print(1); return GREATER;              }
">="                                        { strcat(cur_line_content, yytext); print(1); return GREATER_THAN;         }
"=="                                        { strcat(cur_line_content, yytext); print(1); return EQUAL_TO;             }
"!="                                        { strcat(cur_line_content, yytext); print(1); return NOT_EQUAL_TO;         }
"="                                         { strcat(cur_line_content, yytext); print(1); return ASSIGN_EQUAL;         }
"&&"                                        { strcat(cur_line_content, yytext); print(1); return LOGICAL_AND;          }
"||"                                        { strcat(cur_line_content, yytext); print(1); return LOGICAL_OR;           }
"!"                                         { strcat(cur_line_content, yytext); print(1); return LOGICAL_NOT;          }
"&"                                         { strcat(cur_line_content, yytext); print(1); return BITWISE_AND;          }
"|"                                         { strcat(cur_line_content, yytext); print(1); return BITWISE_OR;           }
"^"                                         { strcat(cur_line_content, yytext); print(1); return BITWISE_XOR;          }
"~"                                         { strcat(cur_line_content, yytext); print(1); return BITWISE_COMPLEMENT;   }
"<<"                                        { strcat(cur_line_content, yytext); print(1); return LEFT_SHIFT;           }
">>"                                        { strcat(cur_line_content, yytext); print(1); return RIGHT_SHIFT;          }

"`"                                         { strcat(cur_line_content, yytext); print(2); return GRAVE_ACCENT;         }
"#"                                         { strcat(cur_line_content, yytext); print(2); return POUND;                }
"$"                                         { strcat(cur_line_content, yytext); print(2); return DOLLAR;               }
":"			                                { strcat(cur_line_content, yytext); print(2); return COLON;                }
";"				                            { strcat(cur_line_content, yytext); print(2); return SEMICOLON;            }
","				                            { strcat(cur_line_content, yytext); print(2); return COMMA;                }
"."				                            { strcat(cur_line_content, yytext); print(2); return DOT;                  }
"["				                            { strcat(cur_line_content, yytext); print(2); return LEFT_SQUARE_BRACKET;  }
"]"				                            { strcat(cur_line_content, yytext); print(2); return RIGHT_SQUARE_BRACKET; }
"("				                            { strcat(cur_line_content, yytext); print(2); return LEFT_BRACKET;         }
")"				                            { strcat(cur_line_content, yytext); print(2); return RIGHT_BRACKET;        }
"{"				                            { strcat(cur_line_content, yytext); print(2); return LEFT_CURLY_BRACKET;   }
"}"				                            { strcat(cur_line_content, yytext); print(2); return RIGHT_CURLY_BRACKET;  }
"@"                                         { strcat(cur_line_content, yytext); print(2); return AT_SIGN;              }

{BACKSLASHES}                               { raise_error(); return 0; }
{INVALID_INTEGER}                           { raise_error(); return 0; }
{INVALID_DOUBLE}                            { raise_error(); return 0; }
{INVALID_SCIENTIFIC_NOTATION}               { raise_error(); return 0; }
{MULTI_CHARACTER}                           { raise_error(); return 0; }
{UNINFLECTED_TERM_CHAR}                     { raise_error(); return 0; }
{UNINFLECTED_TERM_STRING}                   { raise_error(); return 0; }
.                                           { raise_error(); return 0; }
%{
#include <string.h>
#include <stdio.h>
#include "y.tab.h"

int isSourceOn = 1;
int isTokenOn = 1;
int cur_line_num = 1;
char cur_line_content[256];

void yyerror(const *msg);
extern YYSTYPE yylval;
%}


/* Definitions */
%x VARDEF
%s COMMENT
UNTERM_STRING	(\042[^\042\n]*)
STRING 			(\042[^\042\n]*\042)
CHARACTER		(\047[^\047\n]\047)
MULTI_CHAR		(\047[^\047\n]+\047)
UNTERM_CHAR		(\047[^\047\n]*)
INTEGER_ZERO	(0)
INTEGER			([1-9]+[0-9]*)
INTEGER_INVALID	(0[0-9]+)
DOUBLE 			([1-9]+[0-9]*"."[0-9]+)
DOUBLE_ZERO		(0.[0-9]+)
DOUBLE_INVALID	([0-9]+".")
SCI_NOTATION	([0-9]+["."[0-9]*]?[eE][+-]?[0-9]+)
SCI_INVALID		([0-9]+["."[0-9]*]?[eE][+-]?[0-9]+"."[0-9]*)
KEY_WORDS		("double"|"int"|"char"|"bool"|"void"|"null"|"for"|"while"|"do"|"if"|"else"|"switch"|"return"|"break"|"continue"|"const"|"true"|"false"|"struct"|"case"|"default"|"printf"|"scanf"|"getc"|"gets"|"getchar"|"puts"|"putchar"|"clearerr"|"fopen"|"fclose"|"getw"|"putw"|"fgetc"|"putc"|"fputc"|"fgets"|"fputs"|"feof"|"fseek"|"ftell"|"rewind"|"sprintf"|"sscanf"|"remove"|"fflush")

SINGLE_COMMENT	("//"[^\n]*)

IDENTIFIER		([_a-zA-Z][_a-zA-Z0-9]*)

SOURCEOFF		("#pragma source off")
SOURCEON		("#pragma source on")
TOKENOFF		("#pragma token off")
TOKENON			("#pragma token on")


%%
{STRING}			{ return TOKEN_STRING; }
{UNTERM_STRING}		{ print_error();return 0; }
{CHARACTER}			{ return TOKEN_CHAR; }
{MULTI_CHAR}		{ print_error();return 0; }
{UNTERM_CHAR}		{ print_error();return 0; }
{INTEGER}			{ return TOKEN_INTEGER;}
{INTEGER_ZERO}		{ return TOKEN_INTEGER;}
{INTEGER_INVALID}	{ print_error();return 0; }

{DOUBLE}			{ return TOKEN_DOUBLE; }
{DOUBLE_ZERO}		{ return TOKEN_DOUBLE; }
{DOUBLE_INVALID}	{ print_error();return 0; }
{SCI_NOTATION}		{ return TOKEN_SCI;}
{SCI_INVALID}		{ print_error();return 0; }

[\n]				{ }
[ \t\r]+          	{ }

"int"				{ strcpy(yylval.stringval, yytext); return TYPE_INT; }
"double"			{ strcpy(yylval.stringval, yytext); return TYPE_DOUBLE; }
"char"				{ strcpy(yylval.stringval, yytext); return TYPE_CHAR; }
"float"             { strcpy(yylval.stringval, yytext); return TYPE_FLOAT; }


"void"				{ strcpy(yylval.stringval, yytext); return (KEY_VOID); }
"null"				{ strcpy(yylval.stringval, yytext); return (KEY_NULL); }
"for"				{ strcpy(yylval.stringval, yytext); return (KEY_FOR); }
"while"				{ strcpy(yylval.stringval, yytext); return (KEY_WHILE); }
"do"				{ strcpy(yylval.stringval, yytext); return (KEY_DO); }
"if"				{ strcpy(yylval.stringval, yytext); return (KEY_IF); }
"else"				{ strcpy(yylval.stringval, yytext); return (KEY_ELSE); }
"switch"			{ strcpy(yylval.stringval, yytext); return (KEY_SWITCH); }
"return"			{ strcpy(yylval.stringval, yytext); return (KEY_RETURN); }
"break"				{ strcpy(yylval.stringval, yytext); return (KEY_BREAK); }
"continue"			{ strcpy(yylval.stringval, yytext); return (KEY_CONTINUE); }
"const"				{ strcpy(yylval.stringval, yytext); return (KEY_CONST); }
"true"				{ strcpy(yylval.stringval, yytext); return (KEY_TRUE); }
"false"				{ strcpy(yylval.stringval, yytext); return (KEY_FALSE); }
"struct"			{ strcpy(yylval.stringval, yytext); return (KEY_STRUCT); }
"case"				{ strcpy(yylval.stringval, yytext); return (KEY_CASE); }
"default"			{ strcpy(yylval.stringval, yytext); return (KEY_DEFAULT); }


"++"				{ strcpy(yylval.stringval, yytext); return INCREMENT; }
"--"				{ strcpy(yylval.stringval, yytext); return DECREMENT; }
"<"					{ strcpy(yylval.stringval, yytext); return LESS; }
"<="				{ strcpy(yylval.stringval, yytext); return LESS_EQUAL; }
">"					{ strcpy(yylval.stringval, yytext); return GREATER; }
">="				{ strcpy(yylval.stringval, yytext); return GREATER_EQUAL; }
"=="				{ strcpy(yylval.stringval, yytext); return EQUAL; }
"!="				{ strcpy(yylval.stringval, yytext); return NOT_EQUAL; }
"&&"				{ strcpy(yylval.stringval, yytext); return LOGICAL_AND; }
"||"				{ strcpy(yylval.stringval, yytext); return LOGICAL_OR; }
"!"					{ strcpy(yylval.stringval, yytext); return LOGICAL_NOT; }
"<<"                { strcpy(yylval.stringval, yytext); return LEFT_SHIFT; }
">>"                { strcpy(yylval.stringval, yytext); return RIGHT_SHIFT; }

"+"					{ strcpy(yylval.stringval, yytext); return('+'); }
"-"					{ strcpy(yylval.stringval, yytext); return('-'); }
"*"					{ strcpy(yylval.stringval, yytext); return('*'); }
"/"					{ strcpy(yylval.stringval, yytext); return('/'); }
"%"					{ strcpy(yylval.stringval, yytext); return('%'); }
"&"					{ strcpy(yylval.stringval, yytext); return('&'); }
"="					{ strcpy(yylval.stringval, yytext); return('='); }
":"					{ strcpy(yylval.stringval, yytext); return(':'); }
";"					{ strcpy(yylval.stringval, yytext); return(';'); }
","					{ strcpy(yylval.stringval, yytext); return(','); }
"."					{ strcpy(yylval.stringval, yytext); return('.'); }
"["					{ strcpy(yylval.stringval, yytext); return('['); }
"]"					{ strcpy(yylval.stringval, yytext); return(']'); }
"("					{ strcpy(yylval.stringval, yytext); return('('); }
")"					{ strcpy(yylval.stringval, yytext); return(')'); }
"{"					{ strcpy(yylval.stringval, yytext); return('{'); }
"}"					{ strcpy(yylval.stringval, yytext); return('}'); }

{IDENTIFIER}		{ strcpy(yylval.stringval, yytext); return TOKEN_ID; }
.					{ }

%%
int yywrap() {
    return 1;
} 

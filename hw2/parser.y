%top{
#include <stdio.h>
int yylex();
void yyerror(char* error_message);

int main () {
    yyparse();
    printf("Parsed Successfully");
    return 0;
}
}

/* primitive datatypes */
%token DATATYPE_INT DATATYPE_DOUBLE DATATYPE_FLOAT DATATYPE_CHAR DATATYPE_SIGNED DATATYPE_UNSIGNED DATATYPE_LONG DATATYPE_SHORT

/* operators */
%token PLUS MINUS MULTIPLE DIVIDE MOD TWO_MINUS TWO_PLUS LESS LESS_THAN GREATER GREATER_THAN SAME NOT_EQUAL EQUAL AND OR NOT BI_AND BI_OR BI_XOR BI_COMPLEMENT LEFT_SHIFT RIGHT_SHIFT

/* punctuations */
%token GRAVE_ACCENT POUND DOLLAR COLON SEMICOLON COMMA DOT LEFT_SQUARE_BRACKET RIGHT_SQUARE_BRACKET LEFT_BRACKET RIGHT_BRACKET LEFT_CURLY_BRACKET RIGHT_CURLY_BRACKET AT_SIGN

/* keywords */
%token VOID FOR DO WHILE BREAK CONTINUE IF ELSE AUTO CONST STATIC UNION ENUM GOTO REGISTER SIZEOF TYPEDEF VOLATILE EXTERN RETURN STRUCT SWITCH CASE DEFAULT

/* token types */
%token TOKEN_IDENTIFIER TOKEN_STRING TOKEN_CHARACTER TOKEN_INTEGER TOKEN_DOUBLE TOKEN_SCI_NOT

%start start

%%

start   
        : declaration function;

datatype
        : DATATYPE_INT 
        | DATATYPE_DOUBLE 
        | DATATYPE_FLOAT 
        | DATATYPE_CHAR
        ;

qualifier
        : CONST;

qualifier_datatype
        : qualifier datatype;

unary_operator 
        : BI_AND
		| OP_PLUS
		| OP_MINUS
		| OP_NOT
		;

constant
        : TOKEN_INTEGER 
        | TOKEN_DOUBLE 
        | TOKEN_SCI_NOT; 

skip
        : RETURN expression SEMICOLON 
        | CONTINUE SEMICOLON 
        | BREAK SEMICOLON 
        | RETURN SEMICOLON
        ;

/* Scalar declaration without initialization -> 10pts */
scalar_declaration
        : scalar_with_const /* only for variables */
        | scalar_wihtout_const /* variables & array */
        ;


/* Array declaration without initialization -> 10pts *\


/* Function declaration -> 10pts *\


/* Expression -> 30pts (precedence & associativity) *\
expression
    :
    ;

/* Variable declaration -> 10pts (Scalar, Array, and Const declaration with initialization) *\
declaration_with_const
        : qualifier_datatype SEMICOLON /* const int; */
        | qualifier_datatype init_declarator_list_const SEMICOLON /* const int = 1;*/
        ;

init_declarator_list_const


/* Statements -> 10pts *\


/* Function definition -> 10pts *\
/* start of SWITCH */
switch_content
		: one_or_more_cases
		| one_or_more_cases default_statement
		;

one_or_more_cases
		: case_statement
		| one_or_more_cases case_statement
		;

case_statement
		: CASE switch_case_int_char COLON zero_or_more_statement
		;

default_statement
		: KEY_DEFAULT COLON zero_or_more_statement
		;

switch_case_int_char
        : TOKEN_IDENTIFIER
        | TOKEN_CHARACTER
        ;
/* end of SWITCH */

declaration: declaration external_declaration | ;

external_declaration: function | declaration;


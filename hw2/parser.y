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

start: declaration function;

datatype: 
        DATATYPE_INT | 
        DATATYPE_DOUBLE | 
        DATATYPE_FLOAT | 
        DATATYPE_CHAR;

const_datatype: CONST datatype;

no_const_datatype:
        datatype no_const_datatype |
        datatype;

declaration:
        declaration_with_const |
        declaration_without_const;

statement:
        labeled_statement |
        compound_statement |
        expression_statement | 
        selection_statement |
        iteration_statement;


skip: 
        RETURN expression SEMICOLON | 
        CONTINUE SEMICOLON | 
        BREAK SEMICOLON | 
        RETURN SEMICOLON;

unary_operator: 
        BI_AND | 
        OP_PLUS | 
        OP_MINUS | 
        OP_NOT;

constant: 
        TOKEN_INTEGER | 
        TOKEN_DOUBLE | 
        TOKEN_SCI_NOT; 

/* Scalar declaration without initialization -> 10pts */
scalar_declaration: 
        scalar_with_const /* only for variables */ | 
        scalar_wihtout_const; /* variables & array */

/* Array declaration without initialization -> 10pts *\


/* Function declaration -> 10pts *\
function_definition:;


function_declaration: ;

/* Expression -> 30pts (precedence & associativity) *\
expression:;

/* Variable declaration -> 10pts (Scalar, Array, and Const declaration with initialization) *\
const_variable_declaration: 
        const_datatype SEMICOLON |
        const_datatype const_variables SEMICOLON;

const_variables:
        const_varibles COMMA const_variable |
        const_variable;

const_variable:
        const_direct_declare EQUAL initializer |
        const_direct_declare;

const_direct_declare:
        const_direct_declare LEFT_BRACKET identifier_list? RIGHT_BRACKET;
        const_direct_declare LEFT_BRACKET parameter_list? RIGHT_BRACKET |
        const_direct_declare LEFT_BRACKET RIGHT_BRACKET |
        LEFT_BRACKET const_direct_declare RIGHT_BRACKET | 
        TOKEN_IDENTIFIER;

no_const_variable_declaration:
        no_const_datatype no_const_variables SEMICOLON |
        no_const_datatype SEMICOLON;
        
no_const_variables: 
        no_const_variables COMMA no_const_variable |
        no_const_variable;

no_const_variable: 
        no_const_direct_declare EQUAL initializer |
        no_const_direct_declare;

no_const_direct_declare: 
        no-const_direct_declare LEFT_BRACKET identifier_list? RIGHT_BRACKET |
        no_const_direct_declare LEFT_BRACKET parameter_list? RIGHT_BRACKET |
        no_const_direct_declare LEFT_BRACKET RIGHT_BRACKET |
        LEFT_BRACKET no_const_direct_declare RIGHT_BRACKET |
        TOKEN_IDENTIFIER; 

/* Statements -> 10pts *\


/* Function definition -> 10pts *\
/* start of SWITCH */
switch_content: 
        one_or_more_cases
	| one_or_more_cases default_statement
	;

one_or_more_cases: case_statement
	| one_or_more_cases case_statement
	;

case_statement: 
        CASE switch_case_int_char COLON zero_or_more_statement;

default_statement: 
        KEY_DEFAULT COLON zero_or_more_statement;

switch_case_int_char: 
        TOKEN_IDENTIFIER | 
        TOKEN_CHARACTER;
/* end of SWITCH */

declaration: 
        declaration external_declaration | ;

external_declaration: 
        function | 
        declaration;


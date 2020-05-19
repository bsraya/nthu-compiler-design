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

start: 
        declaration function
        ;

datatype: 
        DATATYPE_INT | 
        DATATYPE_DOUBLE | 
        DATATYPE_FLOAT | 
        DATATYPE_CHAR
        ;

const_datatype: 
        CONST datatype
        ;

declarations:
        declarations declaration |
        declaration
        ;

declaration:
        declaration_with_const |
        declaration_without_const
        ;

unary_operator: 
        BI_AND | 
        OP_PLUS | 
        OP_MINUS | 
        OP_NOT
        ;

constant: 
        TOKEN_INTEGER | 
        TOKEN_DOUBLE | 
        TOKEN_SCI_NOT
        ; 

initializer: 
        ;

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
        const_datatype const_variables SEMICOLON |
        const_datatype SEMICOLON ;

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
        datatype no_const_variables SEMICOLON |
        datatype SEMICOLON;
        
no_const_variables: 
        no_const_variables COMMA no_const_variable |
        no_const_variable;

no_const_variable: 
        no_const_direct_declare EQUAL initializer |
        no_const_direct_declare;

no_const_direct_declare: 
        no_const_direct_declare LEFT_BRACKET identifier_list? RIGHT_BRACKET |
        no_const_direct_declare LEFT_BRACKET parameter_list? RIGHT_BRACKET |
        no_const_direct_declare LEFT_BRACKET RIGHT_BRACKET |
        LEFT_BRACKET no_const_direct_declare RIGHT_BRACKET |
        TOKEN_IDENTIFIER; 

identifiers:
        ;

parameters:
        ;







/* Statements -> 10pts *\
constant_expression:
        TOKEN_INTEGER |
        TOKEN_CHARACTER
        ;

statement:
        compound_statement |
        expression_statement | 
        selection_statement |
        iteration_statement
        ;

statements: 
        statements statement |
        statement
        ;

compound_statement:
        /*

        */

        ;

selection_statement:
        IF LEFT_BRACKET expression RIGHT_BRACKET statements ELSE statements|
        IF LEFT_BRACKET expression RIGHT_BRACKET statements |
        SWITCH LEFT_BRACKET RIGHT_BRACKET LEFT_CURLY_BRACKET switch_statement RIGHT_BRACKET
        ;

switch_statement: 
        cases_without_default |
        cases_with_default
        ;

cases_with_default:
        case_statement default_statement
        ;

cases_without_default: 
        cases 
        ;

cases:
        cases case_statement |
        case_statement
        ;

case_statement:
        CASE constant_expression COLON statements
        ;

default_statement:
        DEFAULT COLON statements
        ;

iteration_statement:
        /*
                while(expression) {statement; statement; statement;}
                do {statement; statement; statement;} while(expression)
                for(expression; expression; expression) {statement; statement; statement;}
        */
        WHILE LEFT_BRACKET expression RIGHT_BRACKET statements;
        DO LEFT_CURLY_BRACKET statements RIGHT_CURLY_BRACKET WHILE LEFT_BRACKET expression RIGHT_BRACKET
        FOR LEFT_BRACKET expressions RIGHT_BRACKET LEFT_CURLY_BRACKET statements RIGHT_CURLY_BRACKET
        ;

skip: 
        RETURN expression SEMICOLON | 
        CONTINUE SEMICOLON | 
        BREAK SEMICOLON | 
        RETURN SEMICOLON;



/* expressions */
expression_statement:
        expression SEMICOLON |
        SEMICOLON
        ;

expression:
        
        ;






/* Function definition -> 10pts *\

declaration: 
        declaration external_declaration | ;

external_declaration: 
        function | 
        declaration;


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
%token DATATYPE_INT DATATYPE_DOUBLE DATATYPE_FLOAT DATATYPE_CHAR

/* operators */
%token PLUS MINUS MULTIPLE DIVIDE MOD INCREMENT DECREMENT LESS LESS_THAN GREATER GREATER_THAN EQUAL_TO NOT_EQUAL_TO ASSIGN_EQUAL LOGICAL_AND LOGICAL_OR LOGICAL_NOT BITWISE_AND BITWISE_OR BITWISE_XOR BITWISE_COMPLEMENT LEFT_SHIFT RIGHT_SHIFT

/* punctuations */
%token GRAVE_ACCENT POUND DOLLAR COLON SEMICOLON COMMA DOT LEFT_SQUARE_BRACKET RIGHT_SQUARE_BRACKET LEFT_BRACKET RIGHT_BRACKET LEFT_CURLY_BRACKET RIGHT_CURLY_BRACKET AT_SIGN

/* keywords */
%token VOID FOR DO WHILE BREAK CONTINUE IF ELSE AUTO CONST STATIC UNION ENUM GOTO REGISTER SIZEOF TYPEDEF VOLATILE EXTERN RETURN STRUCT SWITCH CASE DEFAULT TRUE FALSE

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
        BITWISE_COMPLEMENT | 
        PLUS | 
        MINUS | 
        LOGICAL_NOT |
        INCREMENT |
        DECREMENT
        ;

constant: 
        TOKEN_INTEGER | 
        TOKEN_DOUBLE | 
        TOKEN_SCI_NOT
        ; 

initializers: 
        initializers COMMA designation initializer |
        initializers COMMA initializer |
        designation initializer |
        initializer
        ;

initializer:
        LEFT_CURLY_BRACKET RIGHT_CURLY_BRACKET |
        LEFT_CURLY_BRACKET initializers COMMA RIGHT_CURLY_BRACKET
        ;


/* Scalar declaration without initialization -> 10pts */
scalar_declaration: 
        scalar_with_const | /* only for variables */
        scalar_wihtout_const /* variables & array */
        ;
/* Array declaration without initialization -> 10pts *\


/* Function declaration -> 10pts *\
function_definition:
        no_const_variable_declaration no_const_direct_declare declarations compound_statement|
        no_const_variable_declaration no_const_direct_declare compound_statement |
        VOID no_const_direct_declare declarations compound_statement |
        VOID no_const_direct_declare compound_statement
        ;


function_declaration: ;

/* Expression -> 30pts (precedence & associativity) *\
expression:
        ;

/* Variable declaration -> 10pts (Scalar, Array, and Const declaration with initialization) *\
const_variable_declaration: 
        const_datatype const_variables SEMICOLON |
        const_datatype SEMICOLON
        ;

const_variables:
        const_varibles COMMA const_variable |
        const_variable
        ;

const_variable:
        const_direct_declare EQUAL initializer |
        const_direct_declare
        ;

const_direct_declare:
        const_direct_declare LEFT_BRACKET identifiers RIGHT_BRACKET;
        const_direct_declare LEFT_BRACKET parameters RIGHT_BRACKET |
        const_direct_declare LEFT_BRACKET RIGHT_BRACKET |
        LEFT_BRACKET const_direct_declare RIGHT_BRACKET | 
        TOKEN_IDENTIFIER
        ;

no_const_variable_declaration:
        datatype no_const_variables SEMICOLON |
        datatype SEMICOLON
        ;
        
no_const_variables: 
        no_const_variables COMMA no_const_variable |
        no_const_variable
        ;

no_const_variable: 
        no_const_direct_declare EQUAL initializer |
        no_const_direct_declare
        ;

no_const_direct_declare: 
        no_const_direct_declare LEFT_BRACKET identifiers RIGHT_BRACKET |
        no_const_direct_declare LEFT_BRACKET parameters RIGHT_BRACKET |
        no_const_direct_declare LEFT_BRACKET RIGHT_BRACKET |
        LEFT_BRACKET no_const_direct_declare RIGHT_BRACKET |
        TOKEN_IDENTIFIER
        ; 

identifiers:
        identifiers COMMA TOKEN_IDENTIFIER |
        TOKEN_IDENTIFIER
        ;

parameters:
        parameters COMMA parameter_declaration |
        parameter_declaration
        ;

parameter_declaration:
        no_const_variable_declaration no_const_direct_declare |
        no_const_variable_declaration
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
        LEFT_CURLY_BRACKET items RIGHT_CURLY_BRACKET
        ;       

items:
        declarations statements
        ;

selection_statement:
        IF LEFT_BRACKET expression RIGHT_BRACKET statement ELSE statement |
        IF LEFT_BRACKET expression RIGHT_BRACKET statement |
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
        CASE constant_expression COLON statement
        ;

default_statement:
        DEFAULT COLON statement
        ;

iteration_statement:
        WHILE LEFT_BRACKET expression RIGHT_BRACKET statement;
        DO LEFT_CURLY_BRACKET statement RIGHT_CURLY_BRACKET WHILE LEFT_BRACKET expression RIGHT_BRACKET
        FOR LEFT_BRACKET expressions RIGHT_BRACKET LEFT_CURLY_BRACKET statement RIGHT_CURLY_BRACKET
        FOR LEFT_BRACKET expression_statement expression_statement expression RIGHT_BRACKET | 
        FOR LEFT_BRACKET RIGHT_BRACKET |
        FOR LEFT_BRACKET RIGHT_BRACKET
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

logical_or:
        logical_or OR logical_and |
        logical_and
        ;

logical_and:
        logical_and AND  |

        ;       




/* Function definition -> 10pts *\

declaration: 
        declaration external_declaration | ;

external_declaration: 
        function | 
        declaration;


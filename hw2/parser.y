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

/* reserved words */
%token RESERVED_TRUE, RESERVED_FALSE, RESERVED_NULL;

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
        zero_or_more_declaration function_definition
        ;

zero_or_more_declaration:
        zero_or_more_declaration external_declaration |
        ;

external_declaration:
        function_definition | 
        declaration
        ;

declarations:
        declarations declaration |
        declaration
        ;

declaration:
        declaration_with_const |
        declaration_without_const
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
        LEFT_CURLY_BRACKET initializers COMMA RIGHT_CURLY_BRACKET |
        assignment_expression_without_function
        ;

designation:
        designators EQUAL_TO
        ;

designators:
        designators designator |
        designator
        ;

designator:
        DOT TOKEN_IDENTIFIER
        ;


/* Scalar declaration without initialization -> 10pts */
scalar_declaration: 
        scalar_with_const | /* only for variables */
        scalar_wihtout_const /* variables & array */
        ;
/* Array declaration without initialization -> 10pts *\


/* Function declaration -> 10pts *\
function_definition:
        datatype no_const_direct_declare declarations compound_statement|
        datatype no_const_direct_declare compound_statement |
        VOID no_const_direct_declare declarations compound_statement |
        VOID no_const_direct_declare compound_statement
        ;


/* Expression -> 30pts (precedence & associativity) *\
expression_statement:
        expressions SEMICOLON |
        SEMICOLON
        ;

expressions:
        expressions COMMA assignment_expression |
        assignment_expression
        ;

assignment_expression_without_function:

        ;

assignment_expression:
        unary_expression EQUAL_TO assignment_expression |
        logical_or_expression

        ;

logical_or_without_function:
        
        ;

logical_or:
        logical_or OR logical_and |
        logical_and
        ;

logical_and_without_function:
        
        ;
        `
logical_and:
        logical_and AND  |

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

declare_const_variable:
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

declare_no_const_variable:
        ;

no_const_direct_declare: 
        no_const_direct_declare LEFT_SQUARE_BRACKET TOKEN_INTEGER RIGHT_SQUARE_BRACKET |
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
        SWITCH LEFT_BRACKET RIGHT_BRACKET LEFT_CURLY_BRACKET switch_clauses RIGHT_BRACKET
        ;

switch_clauses: 
        cases default_statement|
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
%{
        #include <stdio.h>
        int yylex();
        void yyerror(char* error_message);
        char tmp[80000];
        
%}

%union {
        char stringval[10000];
}

/* primitive datatypes */
%token <stringval> DATATYPE_INT DATATYPE_DOUBLE DATATYPE_FLOAT DATATYPE_CHAR DATATYPE_BOOL

/* reserved words */
%token <stringval> RESERVED_TRUE RESERVED_FALSE RESERVED_NULL

/* operators */
%token <stringval> PLUS MINUS MULTIPLE DIVIDE MOD INCREMENT DECREMENT LESS_EQUAL_THAN LESS_THAN GREATER_EQUAL_THAN GREATER_THAN EQUAL_TO NOT_EQUAL_TO ASSIGN_EQUAL LOGICAL_AND LOGICAL_OR LOGICAL_NOT BITWISE_AND BITWISE_OR BITWISE_XOR BITWISE_COMPLEMENT LEFT_SHIFT RIGHT_SHIFT

/* punctuations */
%token <stringval> GRAVE_ACCENT POUND DOLLAR COLON SEMICOLON COMMA DOT LEFT_SQUARE_BRACKET RIGHT_SQUARE_BRACKET LEFT_BRACKET RIGHT_BRACKET LEFT_CURLY_BRACKET RIGHT_CURLY_BRACKET AT_SIGN

/* keywords */
%token <stringval> VOID FOR DO WHILE BREAK CONTINUE IF ELSE AUTO CONST STATIC UNION ENUM GOTO REGISTER SIZEOF TYPEDEF VOLATILE EXTERN RETURN STRUCT SWITCH CASE DEFAULT TRUE FALSE

/* token types */
%token <string_val> TOKEN_IDENTIFIER TOKEN_STRING TOKEN_CHARACTER TOKEN_INTEGER TOKEN_DOUBLE TOKEN_SCI_NOT

%start program

%%

program:
    translation_unit {
        sprintf(tmp, )
    }
    ;

translation_unit:
    external_declaration {

    } | 
    translation_unit external_declaration {

    }
    ;

external_declaration: 
    declaration{

    }
    ;

declaration:
    declaration_spec SEMICOLON {
        sprintf();
    } |
    declaration_spec init_declaration_list SEMICOLON {
        sprintf();
    }
    ;

declaration_spec: 
    type_spec {
        
    } |
    type_spec declaration_spec {

    }
    ;

init_declaration_list: 
    init_declaration {

    } |
    init_declaration_list COMMA init_declaration {
        
    }
    ;

type_spec:
    DATATYPE_CHAR |
    DATATYPE_DOUBLE |
    DATATYPE_INT |
    DATATYPE_FLOAT |
    DATATYPE_CHAR
    ;

%% 

int main () {
    yyparse();
    printf("Parsed Successfully");
    return 0;
}
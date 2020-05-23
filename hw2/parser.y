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
    trans_unit {
        sprintf(tmp, "( %s )", $1);
		strcpy($$, tmp);
		printf("%s\n", $$);
    }
    ;

trans_unit:
    extern_decl {
        sprintf();
    } | 
    trans_unit extern_decl {
        sprintf();
    }
    ;

extern_decl: 
    decl{
        sprintf(tmp, "%s", $1);
		strcpy($$, tmp);
    }
    ;

decl:
    decl_spec SEMICOLON {
        sprintf();
    } |
    decl_spec init_decl_list SEMICOLON {
        sprintf();
    }
    ;

decl_spec: 
    type_spec {
        sprintf(tmp, "<scalar_decl>%s", $1);
		strcpy($$, tmp);
    } |
    type_spec decl_spec {
        sprintf();
    }
    ;

type_spec:
    DATATYPE_CHAR |
    DATATYPE_DOUBLE |
    DATATYPE_INT |
    DATATYPE_FLOAT |
    DATATYPE_CHAR
    ;

init_decl_list: 
    init_decl {
        sprintf();
    } |
    init_decl_list COMMA init_decl {
        sprintf();
    }
    ;

init_decl:
    direct_decl {
        sprintf();
    } |
    direct_decl ASSIGN_EQUAL init {
        sprintf();
    }
    ;

direct_decl:
    TOKEN_IDENTIFIER {
        sprintf();
    }
    ;

init:
    assignment_expr {
        sprintf();
    }
    ;

assignment_expr: 
    conditional_expr {
        sprintf()
    } |
    unary_expr ASSIGN_EQUAL assignment_expr {
        sprintf();
    }
    ;

conditional_expr:
    logical_or_expr {
        sprintf();
    } |
    unary_expr {
        sprintf();
    }
    ;

logical_or_expr: 
    logical_and_expr {
        sprintf();
    }
    ;

logical_and_expr: 
    inclusive_or_expr {
        sprintf();
    }
    ;

inclusive_or_expr: 
    exclusive_or_expr {
        sprintf();
    }
    ;

exclusive_or_expr:
    and_expr {
        sprintf();
    }
    ;

and_expr: 
    equality_expr {
        sprintf();
    }
    ;

equality_expr: 
    relational_expr {
        sprinf();
    }
    ;

relational_expr: 
    shift_expr {
        sprintf();
    }
    ;

shift_expr: 
    additive_expr {
        sprintf();
    }
    ;

additive_expr: 
    multiplicative_expr {
        sprintf();
    } |
    additive_expr PLUS multiplicative_expr {
        sprintf();
    }
    ;

multiplicative_expr: 
    unary_expr {
        sprintf();
    }
    ;

unary_expr: 
    postfix_expr {
        sprintf();
    }
    ;

postfix_expr: 
    primary_expr {
        sprintf();
    }
    ;





primary_expr: 
    TOKEN_IDENTIFIER {
        sprintf(tmp, "%s", $1);
        strcpy($$, tmp);
    } |
    constant {
        sprintf(tmp, "%s", $1);
        strcpy($$, tmp);
    }
    ;

constant: 
    TOKEN_INTEGER | 
    TOKEN_DOUBLE | 
    TOKEN_SCI_NOT
    ;

func_def: ;

argument_expr_list: ;

%% 

int main () {
    yyparse();
    printf("Parsed Successfully");
    return 0;
}
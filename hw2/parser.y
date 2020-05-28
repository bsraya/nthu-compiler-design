%{
        #include <stdio.h>
        #include <string.h>
        #include "y.tab.h"
        int yylex();
        void yyerror(char* error_message);      
%}

%union {
        char *stringval;
}

/* primitive datatypes */
%token <stringval> DATATYPE_INT DATATYPE_DOUBLE DATATYPE_CHAR DATATYPE_FLOAT

/* operators */
%token <stringval> PLUS MINUS MULTIPLE DIVIDE MOD INCREMENT DECREMENT LESS_THAN LESS_EQUAL_THAN GREATER_THAN GREATER_EQUAL_THAN EQUAL_TO NOT_EQUAL_TO ASSIGN_EQUAL LOGICAL_AND LOGICAL_OR LOGICAL_NOT POINTER BITWISE_AND BITWISE_COMPLEMENT BITWISE_OR BITWISE_XOR LEFT_SHIFT RIGHT_SHIFT

/* punctuations */
%token <stringval> GRAVE_ACCENT POUND DOLLAR AT_SIGN COLON SEMICOLON COMMA DOT LEFT_SQUARE_BRACKET RIGHT_SQUARE_BRACKET LEFT_BRACKET RIGHT_BRACKET LEFT_CURLY_BRACKET RIGHT_CURLY_BRACKET

/* keywords */
%token <stringval> VOID FOR WHILE DO IF ELSE SWITCH RETURN BREAK CONTINUE CONST TRUE FALSE STRUCT CASE DEFAULT AUTO STATIC UNION ENUM GOTO REGISTER SIZEOF TYPEDEF VOLATILE EXTERN 

/* tokens */
%token <stringval> TOKEN_IDENTIFIER TOKEN_STRING TOKEN_CHARACTER TOKEN_INTEGER TOKEN_DOUBLE TOKEN_SCI_NOT

%type <stringval> program
%type <stringval> trans_unit
%type <stringval> extern_decl
%type <stringval> scalar_decl
%type <stringval> decl
%type <stringval> init_decl_list
%type <stringval> init_decl
%type <stringval> direct_decl
%type <stringval> type_spec

%type <stringval> array_decl
%type <stringval> init_array_list
%type <stringval> n_dimension
%type <stringval> dimension

%type <stringval> const_decl

%type <stringval> func_decl
%type <stringval> parameters
%type <stringval> parameter

%type <stringval> func_def

%start program

%%

program:
	trans_unit
	;

trans_unit:
	extern_decl |
	trans_unit extern_decl
	;

extern_decl:
	decl |
	func_def
	;

func_def:
	type_spec TOKEN_IDENTIFIER LEFT_BRACKET parameters RIGHT_BRACKET statement {

	}
	;

decl:
	scalar_decl {
		printf("<scalar_decl>%s</scalar_decl>", $1);
		free($1);
	} |
	array_decl {
		printf("<array_decl>%s</array_decl>", $1);
		free($1);
	} |
	const_decl {
		printf("<const_decl>%s</const_decl>", $1);
		free($1);
	} |
	func_decl {
		printf("<func_decl>%s</func_decl>", $1);
		free($1);
	}
	;

func_decl:
	type_spec TOKEN_IDENTIFIER LEFT_BRACKET parameters RIGHT_BRACKET SEMICOLON {
		int len1 = strlen($1);
		int len2 = strlen($2);
		int len4 = strlen($4);

		$$ = (char*)malloc((len1+len2+1+len4+1+1)*sizeof(char)+1);
		strcat($$, $1);
		strcat($$, $2);
		strncat($$, $3, 1);
		strcat($$, $4);
		strncat($$, $5, 1);
		strncat($$, $6, 1);
	}
	;

parameters:
	parameter {
		int len = strlen($1);
		$$ = (char*)malloc(len*sizeof(char) + 1);
		$$ = $1;
	} |
	parameters COMMA parameter {
		int len1 = strlen($1);
		int len3 = strlen($3);
		$$ = (char*)malloc((len1 + 1 + len3)*sizeof(char) + 1);
		strcat($$, $1);
		strncat($$, $2, 1);
		strcat($$, $3);
	}
	;

parameter:
	type_spec TOKEN_IDENTIFIER {
		int len1 = strlen($1);
		int len2 = strlen($2);
		$$ = (char*)malloc((len1+len2)*sizeof(char) + 1);
		strcat($$, $1);
		strcat($$, $2);
	}
	;

const_decl:
	CONST scalar_decl {
		int len1 = strlen($1);
		int len2 = strlen($2);
		$$ = (char*)malloc((len1+len2)*sizeof(char) + 1);
		strcat($$, $1);
		strcat($$, $2);
	} | 
	CONST array_decl {
		int len1 = strlen($1);
		int len2 = strlen($2);
		$$ = (char*)malloc((len1+len2)*sizeof(char) + 1);
		strcat($$, $1);
		strcat($$, $2);
	}
	;

array_decl:
	type_spec init_array_list SEMICOLON {
		int len1 = strlen($1);
		int len2 = strlen($2);
		$$ = (char*)malloc((len1 + len2)*sizeof(char) + 1);
		$$[0] = '\0';
		strcat($$, $1);
		strcat($$, $2);
		strncat($$, $3, 1);
	}
	;

init_array_list:
	TOKEN_IDENTIFIER n_dimension {
		int len1 = strlen($1);
		int len2 = strlen($2);
		$$ = (char*)malloc((len1+len2)*sizeof(char) + 1);
		strcat($$, $1);
		strcat($$, $2);
	} |
	init_array_list COMMA TOKEN_IDENTIFIER n_dimension {
		int len1 = strlen($1);
		int len3 = strlen($3);
		int len4 = strlen($4);

		$$ = (char*)malloc((len1 + 1 + len3 + len4)*sizeof(char) + 1);
		strcat($$, $1);
		strncat($$, $2, 1);
		strcat($$, $3);
		strcat($$, $4);
	}
	;

n_dimension:
	dimension {
		int len = strlen($1);
		$$ = (char*)malloc(len*sizeof(char) + 1);
		$$ = $1;
	} |
	n_dimension dimension {
		int len1 = strlen($1);
		int len2 = strlen($2);
		$$ = (char*)malloc((len1+len2)*sizeof(char) + 1);
		strcat($$, $1);
		strcat($$, $2);
	}
	;

dimension:
	LEFT_SQUARE_BRACKET TOKEN_INTEGER RIGHT_SQUARE_BRACKET {
		int len = strlen($2);
		$$ = (char*)malloc((1+len+1)*sizeof(char) + 1);
		strncat($$, $1, 1);
		strcat($$, $2);
		strncat($$, $3, 1);
	}
	;

scalar_decl:
	type_spec SEMICOLON {
		int len1 = strlen($1);
		$$ = (char*)malloc(((len1+1)+1)*sizeof(char));
		$$[0] = '\0';
		strcat($$, $1);
		strncat($$, $2, 1);
	} |
	type_spec init_decl_list SEMICOLON { 
		int len1 = strlen($1);
		int len2 = strlen($2);
		$$ = (char*)malloc((len1+len2+1)*sizeof(char) + 1);
		$$[0] = '\0';
		strcat($$, $1);
  		strcat($$, $2);
  		strncat($$, $3, 1);
	}
	;

init_decl_list:
	init_decl {
		int len = strlen($1);
		$$ = (char*)malloc((len+1)*sizeof(char) + 1);
		$$ = $1;
	} |
	init_decl_list COMMA init_decl {
		int len1 = strlen($1);
		int len2 = strlen($3);
		$$ = (char*)malloc(((len1+1+len2)+1)*sizeof(char) + 1);
		strcat($$, $1);
		strncat($$, $2, 1);
		strcat($$, $3);
		free($1);
		free($3);
	}
	;

init_decl: 
	direct_decl {
		int len = strlen($1);
		$$ = (char*)malloc(len*sizeof(char) + 1);
		$$ = $1;
	} |
	direct_decl ASSIGN_EQUAL init {
		int len1 = strlen($1);
		int len3 = strlen($3);
		$$ = (char*)malloc((len1+1+len3)*sizeof(char) + 1);
		strcat($$, $1);
		strncat($$, $2, 1);
		strcat($$, $1);
	}
	;

init:
	expr
	;

expr:
	assignment_expr
	;

assignment_expr:
	conditional_expr {

	} |
	unary_expr ASSIGN_EQUAL assignment_expr {

	}
	;

conditional_expr:
	logical_and_expr {
		
	} |
	logical_or_expr LOGICAL_OR logical_and_expr {

	}
	;

logical_and_expr:
	and_expr {

	} |
	logical_and_expr LOGICAL_AND and_expr {

	}
	;

or_expr:
	xor_expr {

	} |
	or_expr BITWISE_OR xor_expr {

	}
	;

xor_expr:
	and_expr {

	} |
	xor_expr BITWISE_XOR and_expr {

	}
	;

and_expr:
	equality_expr |
	and_expr BITWISE_AND equality_expr
	;

equality_expr:
	relational_expr |
	equality_expr EQUAL_TO relational_expr |
	equality_expr NOT_EQUAL_TO relational_expr
	;

relational_expr:
	additive_expr |
	relational_expr GREATER_THAN additive_expr |
	relational_expr GREATER_EQUAL_THAN additive_expr|
	relational_expr LESS_THAN additive_expr|
	relational_expr LESS_EQUAL_THAN additive_expr
	;

additive_expr:
	mutliplicative_expr |
	additive_expr PLUS multiplicative_expr |
	additive_expr MINUS multiplicative_expr
	;

multiplicative_expr:
	unary_expr |
	multiplicative_expr	MULTIPLE unary_expr|
	multiplicative_expr DIVIDE unary_expr |
	multiplicative_expr MOD unary_expr
	;

unary_expr:
	postfix_expr |
	INCREMENT unary_expr |
	DECREMENT unary_expr |
	unary_operator unary_expr {
		printf("<expr>%s%s</expr>", $1, $2);
	}
	;

unary_operator:
	BITWISE_AND |
	BITWISE_COMPLEMENT |
	PLUS | 
	MINUS 
	;

postfix_expr:
	primary_expr |
	postfix_expr INCREMENT
	postfix_expr DECREMENT
	;

primary_expr:
	TOKEN_IDENTIFIER |
	constant |
	TOKEN_STRING
	;

constant:
	TOKEN_INTEGER {
		printf("<expr>%s</expr>", $1);
	} |
	TOKEN_DOUBLE {
		printf("<expr>%s</expr>", $1);
	} |
	TOKEN_SCI_NOT {
		printf("<expr>%s</expr>", $1);
	}
	;

direct_decl: 
	TOKEN_IDENTIFIER {
		int len = strlen($1);
		$$ = (char *)malloc(len*sizeof(char) + 1);
		$$ = $1;
	}
	;
	
type_spec:
	DATATYPE_CHAR {
		int len = strlen($1);
		$$ = (char *)malloc(len * sizeof(char) + 1);
		$$ = $1;
	} |
	DATATYPE_DOUBLE {
		int len = strlen($1);
		$$ = (char *)malloc(len * sizeof(char) + 1);
		$$ = $1;
	} |
	DATATYPE_FLOAT {
		int len = strlen($1);
		$$ = (char *)malloc(len * sizeof(char) + 1);
		$$ = $1;
	} |
	DATATYPE_INT {
		int len = strlen($1);
		$$ = (char *)malloc(len * sizeof(char) + 1);
		$$ = $1;
	}
	;

statements:
	statement |
	statements statement
	;

statement:
	compound_statement
	;

declarations:
	decl |
	declarations decl
	;

compound_statement:
	LEFT_CURLY_BRACKET code_block RIGHT_CURLY_BRACKET {

	}
	;

code_block:
	statements declarations
	;

%% 

int main () {
    yyparse();
    return 0;
}
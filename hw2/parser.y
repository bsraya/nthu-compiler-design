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
%type <stringval> init_decl_list
%type <stringval> init_decl
%type <stringval> direct_decl
%type <stringval> type_spec

%type <stringval> array_decl
%type <stringval> init_array_list
%type <stringval> n_dimension
%type <stringval> dimension

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
	func_decl_list func_def_list
	;

func_decl_list:
	func_decl SEMICOLON {

	} |
	func_decl_list  {

	}
	;

func_decl:
	type_spec TOKEN_IDENTIFIER LEFT_BRACKET RIGHT_BRACKET {

	} |
	type_spec TOKEN_IDENTIFIER LEFT_BRACKET parameters RIGHT_BRACKET {

	}
	;

parameters:
	parameter {

	} |
	parameters COMMA parameter {

	}
	;

parameter:
	TOKEN_IDENTIFIER {
		int len = strlen($1);
		
	}
	;

func_def_list:
	func_def { 

	} |
	func_def_list {

	}
	;

func_def: 
	type_spec TOKEN_IDENTIFIER LEFT_BRACKET RIGHT_BRACKET statement {

	} |
	type_spec TOKEN_IDENTIFIER LEFT_BRACKET parameters RIGHT_BRACKET statement {

	}
	;

statement:
	jump_statement
	;

decl:
	scalar_decl {
		printf("<scalar_decl>%s</scalar_decl>", $1);
		free($1);
	} | 
	array_decl {
		printf("<array_decl>%s</array_decl>", $1);
		free($1);
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

%% 

int main () {
    yyparse();
    return 0;
}
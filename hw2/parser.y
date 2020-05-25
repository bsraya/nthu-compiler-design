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
	scalar_decl
	;

scalar_decl:
	type_spec SEMICOLON {
		int len1 = strlen($1);
		$$ = (char*)malloc(((len1+1)+1)*sizeof(char));
		$$[0] = '\0';
		strcat($$, $1);
		strncat($$, $2, 1);
		printf("<scalar_decl>%s%s</scalar_decl>", $1, $2);
		free($1);
		free($2);
	} |
	type_spec init_decl_list SEMICOLON { 
		int len1 = strlen($1);
		int len2 = strlen($2);
		$$ = (char*)malloc(((len1+len2+1)+1)*sizeof(char));
		$$[0] = '\0';
		strcat($$, $1);
  		strcat($$, $2);
  		strncat($$, $3, 1);

		printf("<scalar_decl>%s%s;</scalar_decl>", $1, $2);
		free($1);
		free($2);
		free($3);
	}
	;

init_decl_list:
	init_decl {
		int len = strlen($1);
		$$ = (char*)malloc((len+1)*sizeof(char));
		$$ = $1;
	} |
	init_decl_list COMMA init_decl {
		int len1 = strlen($1);
		int len2 = strlen($3);
		$$ = (char*)malloc(((len1+1+len2)+1)*sizeof(char));
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
		$$ = (char*)malloc((len + 1) *sizeof(char));
		$$ = $1;
	}
	;

direct_decl: 
	TOKEN_IDENTIFIER {
		int len = strlen($1);
		$$ = (char *)malloc(len * sizeof(char) + 1);
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
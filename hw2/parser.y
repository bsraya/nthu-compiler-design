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
%token <stringval> STR_PAR CHAR_PAR GRAVE_ACCENT POUND DOLLAR AT_SIGN COLON SEMICOLON COMMA DOT LEFT_SQUARE_BRACKET RIGHT_SQUARE_BRACKET LEFT_BRACKET RIGHT_BRACKET LEFT_CURLY_BRACKET RIGHT_CURLY_BRACKET

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

%type <stringval> init
%type <stringval> expr
%type <stringval> primary_expr
%type <stringval> constant
%type <stringval> variable

//lower precedence
%right ASSIGN_EQUAL 
%left LOGICAL_OR
%left LOGICAL_AND
%left BITWISE_OR
%left BITWISE_XOR
%left BITWISE_AND
%left EQUAL_TO NOT_EQUAL_TO
%left LESS_THAN LESS_EQUAL_THAN GREATER_THAN GREATER_EQUAL_THAN
%left LEFT_SHIFT RIGHT_SHIFT
%left PLUS MINUS
%left MULTIPLE DIVIDE MOD
%right LOGICAL_NOT BITWISE_COMPLEMENT INCREMENT DECREMENT
%left LEFT_BRACKET RIGHT_BRACKET LEFT_SQUARE_BRACKET RIGHT_SQUARE_BRACKET
%nonassoc UMINUS UPLUS
//higher precedence

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
	decl 
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
	} |
	type_spec init_array_list ASSIGN_EQUAL init SEMICOLON {
		int len1 = strlen($1);
		int len2 = strlen($2);
		int len4 = strlen($4);
		$$ = (char*)malloc((len1 + len2+1+len4+1)*sizeof(char) + 1);
		$$[0] = '\0';
		strcat($$, $1);
		strcat($$, $2);
		strncat($$, $3, 1);
		strcat($$, $4);
		strncat($$, $5, 1);
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
	dimension{
		int len = strlen($1);
		$$ = (char*)malloc(len*sizeof(char) + 1);
		strcat($$, $1);
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
		strcat($$, $3);
	}
	;

init:
	expr {
		int len = strlen($1);
		$$ = (char*)malloc(len*sizeof(char) + 1);
		$$ = $1;
	}
	;

expr:
	variable ASSIGN_EQUAL expr {
		int len1 = strlen($1);
		int len3 = strlen($3);
		$$ = (char*)malloc(((len1 + 1 + len3)+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s%s</expr>", $1, $2, $3);
		$$ = $$;
	} |
	expr LOGICAL_OR expr {
		int len1 = strlen($1);
		int len3 = strlen($3);
		$$ = (char*)malloc(((len1 + 1 + len3)+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s%s</expr>", $1, $2, $3);
		$$ = $$;
	} |
	expr LOGICAL_AND expr {
		int len1 = strlen($1);
		int len3 = strlen($3);
		$$ = (char*)malloc(((len1 + 1 + len3)+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s%s</expr>", $1, $2, $3);
		$$ = $$;
	} |
	expr BITWISE_OR expr {
		int len1 = strlen($1);
		int len3 = strlen($3);
		$$ = (char*)malloc(((len1 + 1 + len3)+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s%s</expr>", $1, $2, $3);
		$$ = $$;
	} |
	expr BITWISE_XOR expr {
		int len1 = strlen($1);
		int len3 = strlen($3);
		$$ = (char*)malloc(((len1 + 1 + len3)+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s%s</expr>", $1, $2, $3);
		$$ = $$;
	} |
	expr BITWISE_AND expr {
		int len1 = strlen($1);
		int len3 = strlen($3);
		$$ = (char*)malloc(((len1 + 1 + len3)+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s%s</expr>", $1, $2, $3);
		$$ = $$;
	} |
	expr EQUAL_TO expr {
		int len1 = strlen($1);
		int len3 = strlen($3);
		$$ = (char*)malloc(((len1 + 1 + len3)+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s%s</expr>", $1, $2, $3);
		$$ = $$;
	} |
	expr NOT_EQUAL_TO expr {
		int len1 = strlen($1);
		int len3 = strlen($3);
		$$ = (char*)malloc(((len1 + 1 + len3)+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s%s</expr>", $1, $2, $3);
		$$ = $$;
	} |
	expr LESS_THAN expr {
		int len1 = strlen($1);
		int len3 = strlen($3);
		$$ = (char*)malloc(((len1 + 1 + len3)+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s%s</expr>", $1, $2, $3);
		$$ = $$;
	} |
	expr LESS_EQUAL_THAN expr {
		int len1 = strlen($1);
		int len3 = strlen($3);
		$$ = (char*)malloc(((len1 + 1 + len3)+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s%s</expr>", $1, $2, $3);
		$$ = $$;
	} |
	expr GREATER_THAN expr {
		int len1 = strlen($1);
		int len3 = strlen($3);
		$$ = (char*)malloc(((len1 + 1 + len3)+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s%s</expr>", $1, $2, $3);
		$$ = $$;
	} |
	expr GREATER_EQUAL_THAN expr {
		int len1 = strlen($1);
		int len3 = strlen($3);
		$$ = (char*)malloc(((len1 + 1 + len3)+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s%s</expr>", $1, $2, $3);
		$$ = $$;
	} |
	expr LEFT_SHIFT expr {
		int len1 = strlen($1);
		int len3 = strlen($3);
		$$ = (char*)malloc(((len1 + 1 + len3)+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s%s</expr>", $1, $2, $3);
		$$ = $$;
	} |
	expr RIGHT_SHIFT expr {
		int len1 = strlen($1);
		int len3 = strlen($3);
		$$ = (char*)malloc(((len1 + 1 + len3)+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s%s</expr>", $1, $2, $3);
		$$ = $$;
	} |
	expr PLUS expr {
		int len1 = strlen($1);
		int len3 = strlen($3);
		$$ = (char*)malloc(((len1 + 1 + len3)+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s%s</expr>", $1, $2, $3);
		$$ = $$;
	} |
	expr MINUS expr {
		int len1 = strlen($1);
		int len3 = strlen($3);
		$$ = (char*)malloc(((len1 + 1 + len3)+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s%s</expr>", $1, $2, $3);
		$$ = $$;
	} |
	expr MULTIPLE expr {
		int len1 = strlen($1);
		int len3 = strlen($3);
		$$ = (char*)malloc(((len1 + 1 + len3)+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s%s</expr>", $1, $2, $3);
		$$ = $$;
	} |
	expr DIVIDE expr {
		if($3 == 0) {
			yyerror("Divide 0");
		} else {
			int len1 = strlen($1);
			int len3 = strlen($3);
			$$ = (char*)malloc(((len1 + 1 + len3)+15)*sizeof(char) + 1);
			sprintf($$, "<expr>%s%s%s</expr>", $1, $2, $3);
			$$ = $$;
		}
	} |
	expr MOD expr {
		int len1 = strlen($1);
		int len3 = strlen($3);
		$$ = (char*)malloc(((len1 + 1 + len3)+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s%s</expr>", $1, $2, $3);
		$$ = $$;
	} |
	expr INCREMENT {
		int len1 = strlen($1);
		int len2 = strlen($2);
		$$ = (char*)malloc(((len1 +len2)+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s</expr>", $1, $2);
		$$ = $$;
	} |
	expr DECREMENT {
		int len1 = strlen($1);
		int len2 = strlen($2);
		$$ = (char*)malloc(((len1 +len2)+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s</expr>", $1, $2);
		$$ = $$;
	} |
	INCREMENT expr {
		int len1 = strlen($1);
		int len2 = strlen($2);
		$$ = (char*)malloc(((len1 +len2)+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s</expr>", $1, $2);
		$$ = $$;
	} |
	DECREMENT expr {
		int len1 = strlen($1);
		int len2 = strlen($2);
		$$ = (char*)malloc(((len1 +len2)+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s</expr>", $1, $2);
		$$ = $$;
	} |
	LOGICAL_NOT expr {
		int len1 = strlen($1);
		int len2 = strlen($2);
		$$ = (char*)malloc(((len1 +len2)+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s</expr>", $1, $2);
		$$ = $$;
	} |
	BITWISE_COMPLEMENT expr {
		int len1 = strlen($1);
		int len2 = strlen($2);
		$$ = (char*)malloc(((len1 +len2)+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s</expr>", $1, $2);
		$$ = $$;
	} |
	expr LEFT_BRACKET expr RIGHT_BRACKET {
		int len1 = strlen($1);
		int len3 = strlen($3);
		$$ = (char*)malloc(((len1+len3+2)+15)*sizeof(char) + 1);
		sprintf($$,"<expr>%s(%s)</expr>",$1, $3);
		$$ = $$;
	} |
	expr LEFT_SQUARE_BRACKET expr RIGHT_SQUARE_BRACKET {
		int len1 = strlen($1);
		int len3 = strlen($3);
		$$ = (char*)malloc(((len1+len3+2)+15)*sizeof(char) + 1);
		sprintf($$,"<expr>%s[%s]</expr>",$1, $3);
		$$ = $$;
	} |
	LEFT_BRACKET expr RIGHT_BRACKET {
		int len = strlen($2);
		$$ = (char*)malloc(((len+2)+15)*sizeof(char) + 1);
		sprintf($$,"<expr>(%s)</expr>",$1);
		$$ = $$;
	} |
	primary_expr {
		int len = strlen($1);
		$$ = (char*)malloc((len+15)*sizeof(char) + 1);
		sprintf($$,"<expr>%s</expr>",$1);
		$$ = $$;
	} |
	MINUS expr %prec UMINUS {
		int len1 = strlen($1);
		int len2 = strlen($2);
		$$ = (char*)malloc((len1+len2+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s</expr>", $1,$2);
		$$ = $$;
	} | 
	PLUS expr %prec UPLUS{
		int len1 = strlen($1);
		int len2 = strlen($2);
		$$ = (char*)malloc((len1+len2+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s</expr>", $1,$2);
		$$ = $$;
	}
	;

primary_expr:
	constant {
		int len = strlen($1);
		$$ = (char*)malloc(len*sizeof(char) + 1);
		$$ = $1;
	} |
	variable{
		int len = strlen($1);
		$$ = (char*)malloc(len*sizeof(char) + 1);
		$$ = $1;
	}
	;

variable:
	TOKEN_IDENTIFIER {
		int len = strlen($1);
		$$ = (char*)malloc(len*sizeof(char) + 1);
		$$ = $1;
	} 
	;

constant:
	TOKEN_INTEGER {
		int len = strlen($1);
		$$ = (char*)malloc(len*sizeof(char) + 1);
		$$ = $1;
	} |
	TOKEN_DOUBLE {
		int len = strlen($1);
		$$ = (char*)malloc(len*sizeof(char) + 1);
		$$ = $1;
	} |
	TOKEN_SCI_NOT {
		int len = strlen($1);
		$$ = (char*)malloc(len*sizeof(char) + 1);
		$$ = $1;
	} |
	TOKEN_STRING {
		int len = strlen($1);
		$$ = (char*)malloc(len*sizeof(char) + 1);
		$$ = $1;
	} |
	TOKEN_CHARACTER {
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
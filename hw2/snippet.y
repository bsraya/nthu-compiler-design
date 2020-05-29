// result
// int a = b =c;
// <scalar_decl>inta=<expr><expr>b</expr>=c</expr>;</scalar_decl>

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
%right INCREMENT DECREMENT
%nonassoc UMINUS
//higher precedence

%%

expr:
	expr ASSIGN_EQUAL variable {
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
		int len1 = strlen($1);
		int len3 = strlen($3);
		$$ = (char*)malloc(((len1 + 1 + len3)+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s%s</expr>", $1, $2, $3);
		$$ = $$;
	} |
	expr MOD expr {
		int len1 = strlen($1);
		int len3 = strlen($3);
		$$ = (char*)malloc(((len1 + 1 + len3)+15)*sizeof(char) + 1);
		sprintf($$, "<expr>%s%s%s</expr>", $1, $2, $3);
		$$ = $$;
	} |
	LEFT_BRACKET expr RIGHT_BRACKET {
		int len = strlen($1);
		$$ = (char*)malloc((len+15)*sizeof(char) + 1);
		sprintf($$,"<expr>(%s)</expr>",$1);
		$$ = $$;
	} |
	MINUS expr %prec UMINUS {
		int len = strlen($1);
		$$ = (char*)malloc((len+15)*sizeof(char) + 1);
		sprintf($$,"<expr>-%s</expr>",$2);
		$$ = $$;
	} |
	primary_expr {
		int len = strlen($1);
		$$ = (char*)malloc((len+15)*sizeof(char) + 1);
		sprintf($$,"<expr>%s</expr>",$1);
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
		$$ = (char*)malloc((len+15)*sizeof(char) + 1);
		sprintf($$,"<expr>%s</expr>",$1);
		$$ = $$;
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

%%
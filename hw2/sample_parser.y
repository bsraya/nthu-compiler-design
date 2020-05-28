%{
	#include <stdio.h>
	#include <string.h>
    int yylex();
    int yyerror();
	char tmp[80000];
%}

%union {
	char stringval[10000];
}

%token <stringval> IDENTIFIER CONSTANT STRING_LITERAL
%token <stringval> INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token <stringval> AND_OP OR_OP 

%token <stringval> CHAR INT FLOAT DOUBLE CONST VOID

%token <stringval> CASE DEFAULT IF ELSE SWITCH WHILE DO FOR CONTINUE BREAK RETURN

%type <stringval> func_def 
%type <stringval> jump_stmt
%type <stringval> iter_stmt
%type <stringval> expr_stmt
%type <stringval> stmt_list
%type <stringval> decl_list
%type <stringval> compound_stmt
%type <stringval> labeled_stmt
%type <stringval> stmt
%type <stringval> init_list
%type <stringval> direct_abstract_decl
%type <stringval> ident_list
%type <stringval> para_decl
%type <stringval> para_list
%type <stringval> constant_expr
%type <stringval> expr
%type <stringval> argument_expr_list
%type <stringval> postfix_expr
%type <stringval> primary_expr
%type <stringval> selection_stmt

%type <stringval> and_expr
%type <stringval> equality_expr
%type <stringval> relational_expr
%type <stringval> shift_expr
%type <stringval> additive_expr
%type <stringval> multiplicative_expr
%type <stringval> unary_expr
%type <stringval> logical_and_expr
%type <stringval> inclusive_or_expr
%type <stringval> exclusive_or_expr
%type <stringval> logical_or_expr
%type <stringval> conditional_expr
%type <stringval> assignment_expr
%type <stringval> init
%type <stringval> direct_decl
%type <stringval> init_decl
%type <stringval> init_decl_list
%type <stringval> type_spec
%type <stringval> decl_spec
%type <stringval> decl
%type <stringval> extern_decl
%type <stringval> trans_unit
%type <stringval> program
%start program

%%

primary_expr
	: IDENTIFIER {
		sprintf(tmp, "%s", $1);
		strcpy($$, tmp);
	}
	| CONSTANT {
		sprintf(tmp, "%s", $1);
		strcpy($$, tmp);
	}
	;

postfix_expr
	: primary_expr {
		sprintf(tmp, "%s", $1);
		strcpy($$, tmp);
	}
	;

argument_expr_list
	: assignment_expr {
		sprintf(tmp, "%s", $1);
		strcpy($$, tmp);
	}
	;

unary_expr
	: postfix_expr {
		sprintf(tmp, "%s", $1);
		strcpy($$, tmp);
	}
	;

multiplicative_expr
	: unary_expr {
		sprintf(tmp, "%s", $1);
		strcpy($$, tmp);
	}
	;

additive_expr
	: multiplicative_expr {
		sprintf(tmp, "%s", $1);
		strcpy($$, tmp);
	}
	| additive_expr '+' multiplicative_expr {
		sprintf(tmp, "( %s + %s )", $1, $3);
		strcpy($$, tmp);
	}
	;

shift_expr
	: additive_expr {
		sprintf(tmp, "%s", $1);
		strcpy($$, tmp);
	}
	;

relational_expr
	: shift_expr {
		sprintf(tmp, "%s", $1);
		strcpy($$, tmp);
	}
	;

equality_expr
	: relational_expr {
		sprintf(tmp, "%s", $1);
		strcpy($$, tmp);
	}
	;

and_expr
	: equality_expr {
		sprintf(tmp, "%s", $1);
		strcpy($$, tmp);
	}
	;

exclusive_or_expr
	: and_expr {
		sprintf(tmp, "%s", $1);
		strcpy($$, tmp);
	}
	;

inclusive_or_expr
	: exclusive_or_expr {
		sprintf(tmp, "%s", $1);
		strcpy($$, tmp);
	}
	;

logical_and_expr
	: inclusive_or_expr {
		sprintf(tmp, "%s", $1);
		strcpy($$, tmp);
	}
	;

logical_or_expr
	: logical_and_expr {
		sprintf(tmp, "%s", $1);
		strcpy($$, tmp);
	}
	;

conditional_expr
	: logical_or_expr {
		sprintf(tmp, "%s", $1);
		strcpy($$, tmp);
	}
	;

assignment_expr
	: conditional_expr {
		sprintf(tmp, "%s", $1);
		strcpy($$, tmp);
	}
	| unary_expr '=' assignment_expr {
		sprintf(tmp, "%s = %s", $1, $3);
		strcpy($$, tmp);
	}
	;

init
	: assignment_expr {
		sprintf(tmp, "%s", $1);
		strcpy($$, tmp);
	}
	;

decl
	: decl_spec ';' {
		sprintf(tmp, "( %s ; )", $1);
		strcpy($$, tmp);
	}
	| decl_spec init_decl_list ';' {
		sprintf(tmp, "( %s %s ; )", $1, $2);
		strcpy($$, tmp);
	}
	;

decl_spec
	: type_spec {
		sprintf(tmp, "%s", $1);
		strcpy($$, tmp);
	}
	| type_spec decl_spec {
		sprintf(tmp, "%s %s", $1, $2);
		strcpy($$, tmp);
	}
	;

init_decl_list
	: init_decl {
		sprintf(tmp, "%s", $1);
		strcpy($$, tmp);
	}
	| init_decl_list ',' init_decl {
		sprintf(tmp, "%s , %s", $1, $3);
		strcpy($$, tmp);
	}
	;

init_decl
	: direct_decl {
		sprintf(tmp, "%s", $1);
		strcpy($$, tmp);
	}
	| direct_decl '=' init {
		sprintf(tmp, "%s = %s", $1, $3);
		strcpy($$, tmp);
	}
	;

type_spec
	: INT {
		sprintf(tmp, "%s", $1);
		strcpy($$, tmp);
	}
	;

direct_decl
	: IDENTIFIER {
		sprintf(tmp, "%s", $1);
		strcpy($$, tmp);
	}
	;



program
	: trans_unit {
		sprintf(tmp, "( %s )", $1);
		strcpy($$, tmp);
		printf("%s\n", $$);
	}
	;

trans_unit
	: extern_decl {
		sprintf(tmp, "%s", $1);
		strcpy($$, tmp);
	}
	| trans_unit extern_decl {
		sprintf(tmp, "%s %s", $1, $2);
		strcpy($$, tmp);
	}
	;

extern_decl
	: decl {
		sprintf(tmp, "%s", $1);
		strcpy($$, tmp);
	}
	;

%%



/* This is a simpled gcc grammar */
/* Copyright (C) 1987 Free Software Foundation, Inc. */
/* BISON parser for a simplied C by Jenq-kuen Lee  Sep 20, 1993    */

%{
#include <stdio.h>
#include <stdlib.h>
#include <error.h>
#include <malloc.h>
#include <math.h>
#include <string.h>
#include "code.h"

int yylex();
void err(char *s);

extern int lineno;
extern FILE *f_asm;
int    errcnt=0;
int    errline=0;
char   *install_symbol();
int args = 0;
%}

%start program
%union { 
         int       token ;
         char      charv ;
         char      *ident;
       }
/* all identifiers   that are not reserved words
   and are not declared typedefs in the current block */
%token IDENTIFIER INTEGER FLOAT

/* reserved words that specify storage class.
   yylval contains an IDENTIFIER_NODE which indicates which one.  */
%token SCSPEC

/* reserved words that specify type.
   yylval contains an IDENTIFIER_NODE which indicates which one.  */
%token TYPESPEC ENUM STRUCT UNION

/* reserved words that modify type: "const" or "volatile".
   yylval contains an IDENTIFIER_NODE which indicates which one.  */
%token TYPEMOD

%token CONSTANT

/* String constants in raw form.
   yylval is a STRING_CST node.  */
%token STRING

/* the reserved words */
%token SIZEOF  IF ELSE WHILE DO FOR SWITCH CASE DEFAULT_TOKEN
%token BREAK CONTINUE RETURN GOTO ASM

%type <ident> IDENTIFIER 
%type <token> CONSTANT
%type <token> INTEGER
%type <ident> func_decl, statement, expr_no_comma, argument

%type <charv> '{' 
%type <charv> '}'
%type <charv> '(' 
%type <charv> ')'

/* Define the operator tokens and their precedences.
   The value is an integer because, if used, it is the tree code
   to use in the expression made from the operator.  */
%left  <charv> ';'
%left IDENTIFIER  SCSPEC TYPESPEC TYPEMOD
%left  <charv> ','
%right <charv> '='
%right <token> ASSIGN 
%right <charv> '?' ':'
%left <charv> OROR
%left <charv> ANDAND
%left <charv> '|'
%left <charv> '^'
%left <charv> '&'
%left <token> EQCOMPARE
%left <token> ARITHCOMPARE  '>' '<' 
%left <charv> LSHIFT RSHIFT
%left <charv> '+' '-'
%left <token> '*' '/' '%'
%right <token> UNARY PLUSPLUS MINUSMINUS 
%left HYPERUNARY 
%left <token> POINTSAT '.'


%{
/* external function is defined here */
int TRACEON = 100;
%}     


%%

program: /* empty */
          { if (TRACEON) printf("1\n ");}
	| extdefs
          { if (TRACEON) printf("2\n ");}
	;

extdefs:
          extdef
          { if (TRACEON) printf("3\n ");}
	| extdefs  extdef
          { if (TRACEON) printf("4\n ");}
	;

extdef:
	func_decl {
		cur_scope++;
		set_scope_and_offset_of_param($1);
		fprintf(f_asm, ".global %s\n", $1);
		fprintf(f_asm, "%s:\n", $1);
		fprintf(f_asm, "	// BEGIN PROLOGUE\n");
		fprintf(f_asm, "	// %s is the callee here, so we save callee-saved registers\n", $1);
		fprintf(f_asm, "	sw s0, -4(sp) // save frame pointer\n");
		fprintf(f_asm, "	addi sp, sp, -4\n");
		fprintf(f_asm, "	addi s0, sp, 0 // set new frame\n");
		fprintf(f_asm, "	sw sp, -4(s0)\n");
		fprintf(f_asm, "	sw s1, -8(s0)\n");
		fprintf(f_asm, "	sw s2, -12(s0)\n");
		fprintf(f_asm, "	sw s3, -16(s0)\n");
		fprintf(f_asm, "	sw s4, -20(s0)\n");
		fprintf(f_asm, "	sw s5, -24(s0)\n");
		fprintf(f_asm, "	sw s6, -28(s0)\n");
		fprintf(f_asm, "	sw s7, -32(s0)\n");
		fprintf(f_asm, "	sw s8, -36(s0)\n");
		fprintf(f_asm, "	sw s9, -40(s0)\n");
		fprintf(f_asm, "	sw s10, -44(s0)\n");
		fprintf(f_asm, "	sw s11, -48(s0)\n");
		fprintf(f_asm, "	addi sp, s0, -48 // update stack pointer \n");
		fprintf(f_asm, "	// END PROLOGUE\n\n");
	} 
	'{' 
	statements {
		pop_up_symbol(cur_scope);
		cur_scope--;
		fprintf(f_asm, "	// BEGIN PROLOGUE\n");
		fprintf(f_asm, "	// restore callee-saved registers\n");
		fprintf(f_asm, "	// s0 at this point should be the same in prologue\n");
		fprintf(f_asm, "	lw s11, -48(s0)\n");
		fprintf(f_asm, "	lw s10, -44(s0)\n");
		fprintf(f_asm, "	lw s9, -40(s0)\n");
		fprintf(f_asm, "	lw s8, -36(s0)\n");
		fprintf(f_asm, "	lw s7, -32(s0)\n");
		fprintf(f_asm, "	lw s6, -28(s0)\n");
		fprintf(f_asm, "	lw s5, -24(s0)\n");
		fprintf(f_asm, "	lw s4, -20(s0)\n");
		fprintf(f_asm, "	lw s3, -16(s0)\n");
		fprintf(f_asm, "	lw s2, -12(s0)\n");
		fprintf(f_asm, "	lw s1, -8(s0)\n");
		fprintf(f_asm, "	lw sp, -4(s0)\n");
		fprintf(f_asm, "	addi sp, sp, 4 \n");
		fprintf(f_asm, " 	lw s0, -4(sp)\n");
		fprintf(f_asm, "	// END PROLOGUE\n");
		fprintf(f_asm, "	\n");
		fprintf(f_asm, "	jalr zero, 0(ra) // return");
	}
	'}'
	| func_decl ';' 
	;

func_decl:
	type IDENTIFIER {
		$$ = install_symbol($2);
	} '(' parmlist ')' {
		$$ = $2;
	}
	;

parmlist: 
	/*empty*/
	;

type:
	TYPESPEC | /*empty*/ {} ;

statements:
	statements statement ';' | statement ';'
	;

statement:
	{
		fprintf(f_asm, "	sw ra, -4(sp)\n");  
  		fprintf(f_asm, "	addi sp, sp, -4\n");
	} expr_no_comma 
	{
		fprintf(f_asm, "    addi sp, sp, 4\n");
		fprintf(f_asm, "    \n");
		args = 0;
	} 
	;

arguments:
	arguments ',' argument | argument;

argument:
	CONSTANT {
		$$ = NULL;
		fprintf(f_asm,"    li a%d, %d\n", args, $1);
		args++;
	}
	;

expr_no_comma:
	IDENTIFIER '(' arguments ')' {
		fprintf(f_asm, "    jal ra, %s\n", $1);
		fprintf(f_asm, "	lw ra, 0(sp)\n");
	}
	;

%%

/*
 *	  s - the error message to be printed
 */
void yyerror(char *s)
{
	err(s);
}


void err(char *s)
{
	if (! errcnt++)
		errline = lineno;
         fprintf(stderr,"Error on line %d \n",lineno);
	
	exit(1);
}





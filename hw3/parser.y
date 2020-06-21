
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
%type <ident> func_decl, declaration, parm, statement, expr_no_comma, primary, argument

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
		code_gen_func_header($1);
		fprintf(f_asm, "	// BEGIN PROLOGUE\n");
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
		fprintf(f_asm, "	// END PROLOGUE\n");
	} 
	'{' declarations {
		
		set_local_vars($1);
	} 
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
		code_gen_at_end_of_function_body($1);
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

type:
	TYPESPEC | /*empty*/ {} ;


/* This is what appears inside the parens in a function declarator.
   Is value is represented in the format that grokdeclarator expects.  */
parmlist:  
	/* empty */
		{ if (TRACEON) printf("26 ") ; }	
	| parms
  		{ if (TRACEON) printf("27 ") ;  }
		
	;

/* A nonempty list of parameter declarations or type names.  */
parms:	
	parm | parms ',' parm
	;

parm:
	/*empty*/ {} |
	CONSTANT|
	TYPESPEC IDENTIFIER
  		{ 
			$$ = install_symbol($2);
		}
   ;


declarations:
	declaration ';'
        { if (TRACEON) printf("104 ") ; }
	| declarations declaration ';'
		{ if (TRACEON) printf("106 ") ; }
	;

declaration:	 
	TYPESPEC IDENTIFIER { 
		$$ = install_symbol($2);
	} |
	TYPESPEC IDENTIFIER '=' INTEGER {
		$$ = install_symbol($2);
	} |
	TYPESPEC IDENTIFIER '=' expr_no_comma {
		$$ = install_symbol($2);
	}|
	declaration ',' IDENTIFIER '=' CONSTANT {
		$$ = install_symbol($3);
	}	
	;

statements:
	statements statement ';' | statement ';'
	;

statement:
	expr_no_comma 
	{
		fprintf(f_asm, "        addi sp, sp, 4\n");
		fprintf(f_asm, "   \n");
	} 
	;

arguments:
	arguments ',' argument | argument;

argument:
	CONSTANT | identifiers | expr_no_comma;

expr_no_comma:
	primary
        { 
 			$$ = $1;
        }
	| IDENTIFIER '(' arguments ')' {
		fprintf(f_asm, "        jal ra, %s\n", $1);
		fprintf(f_asm, "	lw ra, 0(sp)\n");
	}
	| '(' expr_no_comma ')' 
	| expr_no_comma '+' expr_no_comma
		{ 
			fprintf(f_asm,"        lw t0, 0(sp)\n");
			fprintf(f_asm,"        addi sp, sp, 4\n");
			fprintf(f_asm,"        lw t1, 0(sp)\n");
			fprintf(f_asm,"        addi sp, sp, 4\n");
			fprintf(f_asm,"        add  t0, t0, t1\n");
			fprintf(f_asm,"        addi sp, sp, -4\n");
			fprintf(f_asm,"        sw t0, 0(sp)\n");
			$$= NULL;
        }
	| expr_no_comma '-' expr_no_comma 
		{
			fprintf(f_asm,"        lw t0, 0(sp)\n");
			fprintf(f_asm,"        addi sp, sp, 4\n");
			fprintf(f_asm,"        lw t1, 0(sp)\n");
			fprintf(f_asm,"        addi sp, sp, 4\n");
			fprintf(f_asm,"        sub  t0, t0, t1\n");
			fprintf(f_asm,"        addi sp, sp, -4\n");
			fprintf(f_asm,"        sw t0, 0(sp)\n");
			$$= NULL;
		}
	| expr_no_comma '=' expr_no_comma
		{ 
			char *s;
			int index;

			if (TRACEON) printf("17 ") ;
			s= $1;
			if (!s) perror("improper expression at LHS");
			index = look_up_symbol(s);
			

			fprintf(f_asm,"        lw  t0, 0(fp) \n");
			fprintf(f_asm,"        addi sp, sp, 4\n");
			fprintf(f_asm,"        lw  t1, 0(fp) \n");
			fprintf(f_asm,"        addi sp, sp, 4\n");
			
			switch(table[index].mode) {
				case ARGUMENT_MODE:
					fprintf(f_asm,"        sw  t0, %d(fp) \n", 
						table[table[index].functor_index].total_locals *(-4)-16 +table[index].offset*(-4)  +(-4));
					fprintf(f_asm,"        addi sp, sp, -4\n");
					fprintf(f_asm,"        sw t0, 0(sp)\n");
					break;

				case LOCAL_MODE:
					fprintf(f_asm,"        sw  t0, %d(fp) \n", table[index].offset*4*(-1)-16);
					fprintf(f_asm,"        addi sp, sp, -4\n");
					fprintf(f_asm,"        sw t0, 0(sp)\n");
					break;

				default: /* Global Vars */
					fprintf(f_asm,"        lui     t2,%%hi(%s)\n", table[index].name);
					fprintf(f_asm,"        sw     t0,%%lo(%s)(t2)\n", table[index].name);
					fprintf(f_asm,"        addi sp, sp, -4\n");
					fprintf(f_asm,"        sw t0, 0(sp)\n");
		}
    }
	| expr_no_comma '*' expr_no_comma
		{
			fprintf(f_asm,"        lw t0, 0(sp)\n");
			fprintf(f_asm,"        addi sp, sp, 4\n");
			fprintf(f_asm,"        lw t1, 0(sp)\n");
			fprintf(f_asm,"        addi sp, sp, 4\n");
			fprintf(f_asm,"        mul  t0, t0, t1\n");
			fprintf(f_asm,"        addi sp, sp, -4\n");
			fprintf(f_asm,"        sw t0, 0(sp)\n");
			$$= NULL;
    	}
	| expr_no_comma '/' expr_no_comma
		{
			fprintf(f_asm,"        lw t0, 0(sp)\n");
			fprintf(f_asm,"        addi sp, sp, 4\n");
			fprintf(f_asm,"        lw t1, 0(sp)\n");
			fprintf(f_asm,"        addi sp, sp, 4\n");
			fprintf(f_asm,"        div  t0, t0, t1\n");
			fprintf(f_asm,"        addi sp, sp, -4\n");
			fprintf(f_asm,"        sw t0, 0(sp)\n");
			$$= NULL;
    	}
	| expr_no_comma ARITHCOMPARE expr_no_comma
		{ 

		}
	;

primary:
    IDENTIFIER {    	  
		int index;
		index = look_up_symbol($1);
		switch(table[index].mode) {
			case ARGUMENT_MODE:
				fprintf(f_asm,"        lw  t0, %d(fp) \n",
					table[table[index].functor_index].total_locals *(-4)-16 +table[index].offset*(-4)  +(-4));
				fprintf(f_asm,"        addi sp, sp, -4\n");
				fprintf(f_asm,"        sw t0, 0(sp)\n");
				break;
			
			case LOCAL_MODE:
				fprintf(f_asm,"        lw  t0, %d(fp) \n",table[index].offset*4*(-1)-16);
				fprintf(f_asm,"        addi sp, sp, -4\n");
				fprintf(f_asm,"        sw t0, 0(sp)\n");
				break;

			default: /* Global Vars */
				fprintf(f_asm,"        lui     t0,%%hi(%s)\n", table[index].name);
				fprintf(f_asm,"        lw     t1, %%lo(%s)(t0)\n", table[index].name);
				fprintf(f_asm,"        addi sp, sp, -4\n");
				fprintf(f_asm,"        sw t1, 0(sp)\n");
		}
		$$=$1;
	}
	| CONSTANT
        { 
			fprintf(f_asm,"        li t0,   %d\n",$1);
			fprintf(f_asm,"        addi sp, sp, -4\n");
			fprintf(f_asm,"        sw t0, 0(sp)\n");
        }
	| STRING
		{ 
		  if (TRACEON) printf("22 ") ;
        }
	| primary PLUSPLUS
		{ 
		  if (TRACEON) printf("23 ") ;
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





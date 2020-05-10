C = gcc
LEX = flex

scanner		: 	lex.yy.c
	     		$(C) lex.yy.c -o scanner
lex.yy.c	: 	scanner.l
				$(LEX) scanner.l
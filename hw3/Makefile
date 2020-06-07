all:
	byacc -vd parser.y
	lex scanner.l
	gcc -c code.c
	gcc lex.yy.c y.tab.c code.c -lfl -o codegen

yacc:
	byacc -vd parser.y
	flex scanner.l

clean:
	rm lex.yy.c
	rm y.tab.h y.tab.c y.output
	rm codegen
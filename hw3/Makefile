all:
	byacc -vd parser.y
	lex scanner.l
	gcc -c code.c
	gcc lex.yy.c y.tab.c code.c -lfl -o codegen

yacc:
	byacc -vd parser.y
	flex scanner.l

clean:
	rm lex.yy.c y.tab.h y.tab.c y.output codegen test.s code.o=

test1:
	./codegen < test1.c
	cat test.s

test2:
	./codegen < test2.c
	cat test.s

test3:
	./codegen < ./test3.c
	cat test.s
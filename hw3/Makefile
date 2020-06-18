all:
	byacc -vd parser.y
	lex ss2.source
	gcc -c code.c
	gcc lex.yy.c y.tab.c code.c -lfl -o codegen

yacc:
	byacc -vd parser.y
	flex ss2.source

clean:
	rm lex.yy.c
	rm y.tab.h y.tab.c y.output
	rm codegen
	rm test.s

test1:
	./codegen < test1.c
	cat test.s
	diff test.s test1_ans.s

test2:
	./codegen < test2.c
	cat test.s
	diff test.s test2_ans.s
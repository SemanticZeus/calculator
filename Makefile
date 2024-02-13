all: calc

calc : lex.yy.calc.c y.tab.c calc_interpreter.c
	gcc -o $@ $^   -ly -g


lex.yy.calc.c: calc.l
	flex -o $@ $<

y.tab.c: calc.y
	yacc -d $<

.PHONY: clean

clean:
	rm y.tab.c y.tab.h lex.yy.calc.c calc




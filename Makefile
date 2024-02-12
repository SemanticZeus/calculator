all: calc.exe

calc.exe : lex.yy.calc.c y.tab.c
	gcc -o $@ $^ -L/usr/lib -lfl -ly


lex.yy.calc.c: calc.l
	flex -o $@ $<

y.tab.c: calc.y
	yacc -d $<

.PHONY: clean

clean:
	rm y.tab.c y.tab.h lex.yy.calc.c calc.exe




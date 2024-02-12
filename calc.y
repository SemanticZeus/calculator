%{
	#include <stdio.h>
	#include <stdlibh>
	#include <stdarg.h>
	#include "calc.h"

	nodeType *opr(int opr, int nops, ...);
	nodeType *id(int i);
	nodeType *con(int value);
	void freeNode *con(int value);
	int ex(nodeType *p);
	int yylex(void);


	void yyerror(char *);
	int sym[26];
%}


%union {
	int iValue;
	char sIndex; /* symbol table index */
	nodeType *nPtr;
};

%token <iValue> INTEGER
%token <sIndex> VARIABLE
%token WHILE IF PRINT
%nonassoc IFX
%nonassoc ELSE

%left GE LE EQ NE '>' '<'
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%type <nPtr> stmt expr stmt_list

%%

program:
       function		{ exit(0); }
	;

function:
	function stmt	{ ex($2); freeNode($2); }
	| /* NULL */
	;

stmt:
	';'			{ $$ = opr(';', 2, NULL, NULL); }
	| expr ';'		{$$ = $1; }
	| PRINT expr ';'	{$$ = opr(PRINT, 1, $2); }
	| VARIABLE = expr ';'	{$$ opr('=', 2, id($1), $3); }
	| WHILE '(' expr ')' stmt { $$ opr(WHILE, 2, $3, $5); }
	| IF '(' expr ')' stmt %prec IFX { $$ = opr(IF, 2, $3, $5); }
	| IF '(' expr ')' stmt %

statement:
	 expr			{ printf("%d\n", $1); }
	| VARIABLE '=' expr	{sym[$1] = $3; }
	;

expr:
    	INTEGER
	| VARIABLE		{$$ = sym[$1]; }
	| expr '+' expr		{$$ = $1+$3; }
	| expr '-' expr		{$$ = $1-$3; }
	| expr '*' expr		{$$ = $1*$3; }
	| expr '/' expr		{$$ = $1/$3; }
	| '(' expr ')'		{$$ = $2; }
	;

%%
void yyerror(char *s) {
	fprintf(stderr, "%s\n", s);
}

int main(void)
{
	yyparse();
	return 0;
}

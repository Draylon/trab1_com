%{

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%union {
	int ival;
	float fval;
}

/* Declaração dos tokens... */

%token <ival> T_INT
%token <fval> T_REAL
%token T_PLUS T_MINUS T_MULTIPLY T_DIVIDE T_LEFT T_RIGHT
%token T_NEWLINE T_QUIT
%token T_SWITCH T_LEFT_BLOCK T_LEFT_PARENTHESES T_RIGHT_BLOCK T_RIGHT_PARENTHESES
%token T_ASSIGN T_CONDICIONAL T_ID T_RESERVED T_RETURN T_LOGIC_OPERATOR T_PRIMITIVO
%token T_SEPARATOR
%left T_PLUS T_MINUS
%left T_MULTIPLY T_DIVIDE

%start if_statement

%%

if_statement: T_CONDICIONAL T_REAL T_LOGIC_OPERATOR T_REAL T_LEFT_BLOCK T_RIGHT_BLOCK 
	;

%%


int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Erro de análise (sintática): %s\n", s);
	exit(1);
}

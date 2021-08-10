

%{

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%%

stmt:
  expr
| if_stmt
;


if_stmt: if_2 | 
  "else" stmt
;

if_2:
  "if" expr "then" stmt;



expr:
  "identifier"
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
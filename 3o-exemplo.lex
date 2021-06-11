/* Linguagem: Pascal-like */

/* ========================================================================== */
/* Abaixo, indicado pelos limitadores "%{" e "%}", as includes necessárias... */
/* ========================================================================== */

%{
/* Para as funções atoi() e atof() */
#include <math.h>
#include <string.h>

int col=0;
int row=0;

%}

/* ========================================================================== */
/* ===========================  Sessão DEFINIÇÔES  ========================== */
/* ========================================================================== */


DIGITO   [0-9]
ID       [a-z][a-z0-9]*
HEX      [a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]


%%

"0x"{HEX} {
    printf("HEXADECIMAL %s",yytext);
}

{DIGITO}+ {
    printf( "Um valor inteiro: ,%s, ,%zu, (%d) encontrado em ( %d : %d )\n", yytext,strlen(yytext),
    atoi( yytext ),row,col );
    col += (int)strlen(yytext);
}

{DIGITO}+"."{DIGITO}* {
    printf( "Um valor real: ,%s, ,%zu, (%g) encontrado em ( %d : %d )\n", yytext,strlen(yytext),
    atof( yytext ),row,col );
    col += (int)strlen(yytext);
}

void|int|float|double|char {
    printf( "Tipo primitivo: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += (int)strlen(yytext);
}

"#include" {
    printf( "Incluindo algo: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += (int)strlen(yytext);
}

"#define" {
    printf( "Definição: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += (int)strlen(yytext);
}


for|while {
    printf( "Laço: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += (int)strlen(yytext);
}

if|else {
    printf( "Estrutura lógica: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += (int)strlen(yytext);
}

{ID} {
    printf( "Um identificador: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += (int)strlen(yytext);
}

"("|")" {
    printf( "Parenteses: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += (int)strlen(yytext);
}

"=="|"!="|"!=="|"<="|">="|"<"|">" {
    printf( "Um sinal lógico: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += (int)strlen(yytext);
}

"=" {
    printf( "Atribuição: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += (int)strlen(yytext);
}

"+"|"-"|"*"|"/" {
    printf( "Um operador: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += (int)strlen(yytext);
}

"{"[^}\n]*"}"     /* Lembre-se... comentários não tem utilidade! */

[ \t] {
        col+=1;
}

[\r\n]+ {
    printf("Quebra de linha\n");
        row+=1;
        col=0;
}

. {
    printf("%d %d\n",row,col);
    printf( "Caracter não reconhecido: %s\n", yytext );
    printf("%d %d\n",row,col);
    col += (int)strlen(yytext);
}

%%



int main( argc, argv )
int argc;
char **argv;
{
	++argv, --argc;
	if ( argc > 0 )
		yyin = fopen( argv[0], "r" );
	else
		yyin = stdin;

	yylex();
    
	return 0;
}

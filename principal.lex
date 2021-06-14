/* Linguagem: Pascal-like */

/* ========================================================================== */
/* Abaixo, indicado pelos limitadores "%{" e "%}", as includes necessárias... */
/* ========================================================================== */

%{
/* Para as funções atoi() e atof() */
#include <math.h>
#include <string.h>

unsigned int col=1;
unsigned int row=1;

%}

/* ========================================================================== */
/* ===========================  Sessão DEFINIÇÔES  ========================== */
/* ========================================================================== */


DIGITO   [0-9]
ID       [A-Za-z_][_A-Za-z0-9]*
HEX      [a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]
TEXTO    [A-Za-z0-9][A-Za-z0-9]*
ARQUIVO  [A-Za-z0-9]*.[A-Za-z0-9]*



%%

{DIGITO}+ {
    printf( "Um valor inteiro: ,%s, ,%zu, (%d) encontrado em ( %d : %d )\n", yytext,strlen(yytext),
    atoi( yytext ),row,col );
    col += strlen(yytext);
}

{DIGITO}+"."{DIGITO}* {
    printf( "Um valor real: ,%s, ,%zu, (%g) encontrado em ( %d : %d )\n", yytext,strlen(yytext),
    atof( yytext ),row,col );
    col += strlen(yytext);
}

void|char|short|int|long|float|double|signed|unsigned {
    printf( "Tipo primitivo: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
}

"#include" {
    printf( "Incluindo algo: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
}

"#define" {
    printf( "Definição: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
}

"<"{ARQUIVO}">" {
    printf( "Biblioteca: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
}

"\""({TEXTO}|.)*"\"" {
    printf( "String: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
}



"("|")" {
    printf( "Parenteses: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
}
"{"|"}" {
    printf( "Bloco de função: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
}
"["|"]" {
    printf( "Índice de ponteiro: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
}

"=="|"!="|"!=="|"<="|">="|"<"|">" {
    printf( "Um sinal lógico: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
}

"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|=" {
    printf( "Atribuição: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
}

";" {
    printf( "Separador: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
}

"+"|"-"|"*"|"/" {
    printf( "Um operador: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
}


return|printf|setlocale {
    printf( "Palavra reservada: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
}

for|while {
    printf( "Laço: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
}

if|else {
    printf( "Estrutura lógica: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
}

{ID} {
    printf( "Um identificador: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
}

" " {
    col+=1;
}

\t {
    col+=4;
}

[\r]+ {
    printf("Carrier Return\n");
    col=1;
}
[\n]+ {
    printf("Quebra de linha\n");
    row+=1;
}

. {
    printf( "Caracter não reconhecido: %s, len: %zu %d\n",yytext,strlen(yytext),(char)yytext );
    col += strlen(yytext);
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

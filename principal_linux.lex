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
int comment=0;



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
    if(comment == 0){
        printf( "Um valor inteiro: ,%s, ,%zu, (%d) encontrado em ( %d : %d )\n", yytext,strlen(yytext),atoi( yytext ),row,col );
    }
    col += strlen(yytext);
}

{DIGITO}+"."{DIGITO}* {
    if(comment == 0){
        printf( "Um valor real: ,%s, ,%zu, (%g) encontrado em ( %d : %d )\n", yytext,strlen(yytext),atof( yytext ),row,col );
    }
    col += strlen(yytext);
}

void|char|short|int|long|float|double|signed|unsigned {
    if(comment == 0){
        printf( "Tipo primitivo: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    }
    col += strlen(yytext);
}

"#include" {
    if(comment == 0){
        printf( "Incluindo algo: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    }
    col += strlen(yytext);
}

"#define" {
    if(comment == 0){
        printf( "Definição: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    }
    col += strlen(yytext);
}

"<"{ARQUIVO}">" {
    if(comment == 0){
        printf( "Biblioteca: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    }
    col += strlen(yytext);
}

"\""({TEXTO}|.)*"\"" {
    if(comment == 0){
        printf( "String: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    }
    col += strlen(yytext);
}



"("|")" {
    if(comment == 0){
        printf( "Parenteses: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    }
    col += strlen(yytext);
}
"{"|"}" {
    if(comment == 0){
        printf( "Bloco de função: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    }
    col += strlen(yytext);
}
"["|"]" {
    if(comment == 0){
        printf( "Índice de ponteiro: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    }
    col += strlen(yytext);
}

"=="|"!="|"!=="|"<="|">="|"<"|">" {
    if(comment == 0){
        printf( "Um sinal lógico: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    }
    col += strlen(yytext);
}

"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|=" {
    if(comment == 0){
        printf( "Atribuição: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    }
    col += strlen(yytext);
}

";"|"," {
    if(comment == 0){
        printf( "Separador: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    }
    col += strlen(yytext);
}

"+"|"-"|"*"|"/" {
    if(comment == 0){
        printf( "Um operador: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    }
    col += strlen(yytext);
}


"//"({TEXTO}|.)* {
    if(comment == 0){
        printf( "Comentario de uma linha: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    }
    col += strlen(yytext);
}

"/*" {
    comment=1;
    col += strlen(yytext);
}
"*/" {
    comment=0;
    col += strlen(yytext);
}


return|printf|setlocale {
    if(comment == 0){
        printf( "Palavra reservada: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    }
    col += strlen(yytext);
}

for|while {
    if(comment == 0){
        printf( "Laço: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    }
    col += strlen(yytext);
}

if|else {
    if(comment == 0){
        printf( "Estrutura lógica: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    }
    col += strlen(yytext);
}

{ID} {
    if(comment == 0){
        printf( "Um identificador: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    }
    col += strlen(yytext);
}

" " {
    col+=1;
}

\t {
    col+=4;
}

[\r]+ {
    if(comment == 0){
        printf("Carrier Return\n");
    }
    col=1;
}
[\n] {
    if(comment == 0){
        printf("Quebra de linha\n");
    }
    col=1;
    row+=1;
}

. {
    if(comment == 0){
        printf( "Caracter não reconhecido: %s, len: %zu encontrado em ( %d : %d )\n",yytext,strlen(yytext),row,col );
    }
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

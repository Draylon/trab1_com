/* Linguagem: Pascal-like */

/* ========================================================================== */
/* Abaixo, indicado pelos limitadores "%{" e "%}", as includes necessárias... */
/* ========================================================================== */

%{
/* Para as funções atoi() e atof() */
#include <math.h>
#include <string.h>
#include "grammar.tab.h"

#define YY_DECL int yylex()


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
    col += strlen(yytext);
    if(comment == 0){
        printf( "Um valor inteiro: ,%s, ,%zu, (%d) encontrado em ( %d : %d )\n", yytext,strlen(yytext),atoi( yytext ),row,col );
        return T_INT;
    }
    return T_STRING;
    
}

{DIGITO}+"."{DIGITO}* {
    col += strlen(yytext);
    if(comment == 0){
        printf( "Um valor real: ,%s, ,%zu, (%g) encontrado em ( %d : %d )\n", yytext,strlen(yytext),atof( yytext ),row,col );
        return T_REAL;
    }
    return T_STRING;
}

void|char|short|int|long|float|double|signed|unsigned {
    col += strlen(yytext);
    if(comment == 0){
        printf( "Tipo primitivo: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_PRIMITIVO;
    }
}

"#include" {
    col += strlen(yytext);
    if(comment == 0){
        printf( "Incluindo algo: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_INCLUDE;
    }
    return T_STRING;
}

"#define" {
    if(comment == 0){
        printf( "Definição: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    }
    col += strlen(yytext);
    return T_DEFINE;
}

"<"{ARQUIVO}">" {
    if(comment == 0){
        printf( "Biblioteca: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    }
    col += strlen(yytext);
    return T_LIBRARY;
}

"\""({TEXTO}|.)*"\"" {
    if(comment == 0){
        printf( "String: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    }
    col += strlen(yytext);
    return T_STRING;
}



"(" {
    col += strlen(yytext);
    if(comment == 0){
        printf( "Abre parenteses: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_LEFT_PARENTHESES;
    }
    return T_STRING;
}

")" {
    col += strlen(yytext);
    if(comment == 0){
        printf( "Abre parenteses: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_RIGHT_PARENTHESES;
    }
    return T_STRING;
}

"{" {
    col += strlen(yytext);
    if(comment == 0){
        printf( "Abre bloco de função: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_LEFT_BLOCK;
    }
    return T_STRING;
}

"}" {
    col += strlen(yytext);
    if(comment == 0){
        printf( "Fecha bloco de função: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_RIGHT_BLOCK;
    }
    return T_STRING;
}

"[" {
    col += strlen(yytext);
    if(comment == 0){
        printf( "Abre colchete: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_LEFT_POINTER;
    }
    return T_STRING;
}

"]" {
    col += strlen(yytext);
    if(comment == 0){
        printf( "Fecha colchete: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_RIGHT_POINTER;
    }
    return T_STRING;
}

"=="|"!="|"!=="|"<="|">="|"<"|">" {
    col += strlen(yytext);
    if(comment == 0){
        printf( "Um sinal lógico: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_LOGIC_OPERATOR;
    }
    return T_STRING;
}

"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|=" {
    col += strlen(yytext);
    if(comment == 0){
        printf( "Atribuição: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_ASSIGN;
    }
}

";" {
    col += strlen(yytext);
    if(comment == 0){
        printf( "Separador: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_SEPARATOR;
    }
    return T_STRING;
}



"+" {
    col += strlen(yytext);
    if(comment == 0){
        printf( "Somaa: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_OP_SUM;
    }
    return T_STRING;
}

"-" {
    col += strlen(yytext);
    if(comment == 0){
        printf( "Um operador: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_OP_SUB;
    }
    return T_STRING;
}

"*" {
    col += strlen(yytext);
    if(comment == 0){
        printf( "Um operador: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_OP_MUL;
    }
    return T_STRING;
}

"+"|"-"|"*"|"/" {
    col += strlen(yytext);
    if(comment == 0){
        printf( "Um operador: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_OP_DIV;
    }
    return T_STRING;
}


"//"({TEXTO}|.)* {
    col += strlen(yytext);
    if(comment == 0){
        printf( "Comentario de uma linha: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_SLC;
    }
    return T_STRING;
}

"/*" {
    comment=1;
    col += strlen(yytext);
    return T_MLC_START;
}
"*/" {
    comment=0;
    col += strlen(yytext);
    return T_MLC_END;
}


printf|setlocale {
    col += strlen(yytext);
    if(comment == 0){
        printf( "Palavra reservada: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_RESERVED;
    }
    return T_STRING;
}

"return" {
    col += strlen(yytext);
    if(comment == 0){
        printf( "Return: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_RETURN;
    }
    return T_STRING;
}



for|while {
    col += strlen(yytext);
    if(comment == 0){
        printf( "Laço: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_LOOP;
    }
    return T_STRING;
}

when {
    col += strlen(yytext);
    if(comment == 0){
        printf( "Laço: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_SWITCH;
    }
    return T_STRING;
}

if {
    col += strlen(yytext);
    if(comment == 0){
        printf( "Estrutura lógica: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_CONDICIONAL;
    }
    return T_STRING;
}

else {
    col += strlen(yytext);
    if(comment == 0){
        printf( "Estrutura lógica: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_CONT_CONDICIONAL;
    }
    return T_STRING;
}






{ID} {
    col += strlen(yytext);
    if(comment == 0){
        printf( "Um identificador: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_ID;
    }
    return T_STRING;
}

" " {
    col+=1;
    return T_EMPTY;
}

\t {
    col+=4;
    return T_TAB;
}

[\r]+ {
    if(comment == 0){
        printf("Carrier Return\n");
    }
    col=1;
    return T_CARRIER;
}
[\n]+ {
    if(comment == 0){
        printf("Quebra de linha\n");
    }
    row+=1;
    return T_NEWLINE;
}

. {
    if(comment == 0){
        printf( "Caracter não reconhecido: %s, len: %zu encontrado em ( %d : %d )\n",yytext,strlen(yytext),row,col );
    }
    col += strlen(yytext);
    return T_UNKNOWN;
}

%%


/*
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
*/
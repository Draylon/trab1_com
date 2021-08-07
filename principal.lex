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
ARQUIVO  [a-zA-Z0-9\/.-]+



%%

{DIGITO}+ {
    col += strlen(yytext);
    
    printf( "Um valor inteiro: ,%s, ,%zu, (%d) encontrado em ( %d : %d )\n", yytext,strlen(yytext),atoi( yytext ),row,col );
        return T_INT;
    
    
}

{DIGITO}+"."{DIGITO}* {
    col += strlen(yytext);
    
    printf( "Um valor real: ,%s, ,%zu, (%g) encontrado em ( %d : %d )\n", yytext,strlen(yytext),atof( yytext ),row,col );
        return T_REAL;
    
}

void|char|short|int|long|float|double|signed|unsigned {
    col += strlen(yytext);
    
    printf( "Tipo primitivo: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_PRIMITIVO;
}

"#include" {
    col += strlen(yytext);
    
    printf( "Incluindo algo: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_INCLUDE;
    
}

"#define" {
    
    printf( "Definição: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
    return T_DEFINE;
}

"<"{ARQUIVO}">" {
    
    printf( "Biblioteca: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
    return T_LIBRARY;
}

"\""({TEXTO}|.)*"\"" {
    printf( "String: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
    return T_STRING;
}



"(" {
    printf( "Abre parenteses: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
    return T_LEFT_PARENTHESES;
    
}

")" {
    col += strlen(yytext);
    printf( "Abre parenteses: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    return T_RIGHT_PARENTHESES;
    
}

"{" {
    col += strlen(yytext);
    
    printf( "Abre bloco de função: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_LEFT_BLOCK;
    
}

"}" {
    col += strlen(yytext);
    printf( "Fecha bloco de função: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    return T_RIGHT_BLOCK;
    
}

"[" {
    col += strlen(yytext);
    
    printf( "Abre colchete: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_LEFT_POINTER;
    
}

"]" {
    col += strlen(yytext);
    
    printf( "Fecha colchete: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_RIGHT_POINTER;
    
}

"=="|"!="|"!=="|"<="|">="|"<"|">" {
    col += strlen(yytext);
    
    printf( "Um sinal lógico: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_LOGIC_OPERATOR;
    
}

"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|=" {
    col += strlen(yytext);
    
    printf( "Atribuição: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_ASSIGN;
}

";" {
    col += strlen(yytext);
    
    printf( "Separador: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_SEPARATOR;
    
}



"+" {
    col += strlen(yytext);
    
    printf( "Somaa: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_OP_SUM;
    
}

"-" {
    col += strlen(yytext);
    
    printf( "Um operador: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_OP_SUB;
    
}

"*" {
    col += strlen(yytext);
    
    printf( "Um operador: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_OP_MUL;
    
}

"+"|"-"|"*"|"/" {
    col += strlen(yytext);
    
    printf( "Um operador: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_OP_DIV;
    
}


"//"(.)* {
printf( "Comentario de uma linha: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
    return T_SLC;
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
    
    printf( "Palavra reservada: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_RESERVED;
    
}

"return" {
    col += strlen(yytext);
    
    printf( "Return: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_RETURN;
    
}



for|while {
    col += strlen(yytext);
    
    printf( "Laço: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_LOOP;
    
}

when {
    col += strlen(yytext);
    
    printf( "Laço: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_SWITCH;
    
}

if {
    col += strlen(yytext);
    
    printf( "Estrutura lógica: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_CONDICIONAL;
    
}

else {
    col += strlen(yytext);
    
    printf( "Estrutura lógica: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_CONT_CONDICIONAL;
    
}






{ID} {
    col += strlen(yytext);
    
    printf( "Um identificador: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
        return T_ID;
    
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
    return T_NEWLINE;
}

. {
    
    printf( "Caracter não reconhecido: %s, len: %zu encontrado em ( %d : %d )\n",yytext,strlen(yytext),row,col );
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
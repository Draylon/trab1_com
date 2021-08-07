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

void check_comment(int s){
    if(comment == 1){
        col+=s;
    }
    return T_STRING;
}

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
    check_comment(strlen(yytext));
    printf( "Um valor inteiro: ,%s, ,%zu, (%d) encontrado em ( %d : %d )\n", yytext,strlen(yytext),atoi( yytext ),row,col );
    col += strlen(yytext);
    return T_INT;
    
    
}

{DIGITO}+"."{DIGITO}* {
    check_comment(strlen(yytext));
    printf( "Um valor real: ,%s, ,%zu, (%g) encontrado em ( %d : %d )\n", yytext,strlen(yytext),atof( yytext ),row,col );
    col += strlen(yytext);
    return T_REAL;
    
}

void|char|short|int|long|float|double|signed|unsigned {
    check_comment(strlen(yytext));
    printf( "Tipo primitivo: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
    return T_PRIMITIVO;
}

"#include" {
    check_comment(strlen(yytext));
    printf( "Incluindo algo: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
    return T_INCLUDE;
    
}

"#define" {
    check_comment(strlen(yytext));
    printf( "Definição: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
    return T_DEFINE;
}

"<"{ARQUIVO}">" {
    check_comment(strlen(yytext));
    printf( "Biblioteca: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
    return T_LIBRARY;
}

"\""({TEXTO}|.)*"\"" {
    check_comment(strlen(yytext));
    printf( "String: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
    return T_STRING;
}



"(" {
    check_comment(strlen(yytext));
    printf( "Abre parenteses: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
    return T_LEFT_PARENTHESES;
}

")" {
    check_comment(strlen(yytext));
    printf( "Abre parenteses: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
    return T_RIGHT_PARENTHESES;
    
}

"{" {
    check_comment(strlen(yytext));
    printf( "Abre bloco de função: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
    return T_LEFT_BLOCK;
}

"}" {
    check_comment(strlen(yytext));
    printf( "Fecha bloco de função: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
    return T_RIGHT_BLOCK;
    
}

"[" {
    check_comment(strlen(yytext));
    printf( "Abre colchete: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
    return T_LEFT_POINTER;
    
}

"]" {
    check_comment(strlen(yytext));
    printf( "Fecha colchete: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
    return T_RIGHT_POINTER;
    
}

"=="|"!="|"!=="|"<="|">="|"<"|">" {
    check_comment(strlen(yytext));
    printf( "Um sinal lógico: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
    return T_LOGIC_OPERATOR;
    
}

"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|=" {
    check_comment(strlen(yytext));
    printf( "Atribuição: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
    return T_ASSIGN;
}

";" {
    check_comment(strlen(yytext));
    printf( "Separador: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
    return T_SEPARATOR;
}



"+" {
    check_comment(strlen(yytext));
    printf( "Somaa: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
    return T_OP_SUM;
    
}

"-" {
    check_comment(strlen(yytext));
    printf( "Um operador: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
    return T_OP_SUB;
}

"*" {
    check_comment(strlen(yytext));
    printf( "Um operador: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
    return T_OP_MUL;
    
}

"+"|"-"|"*"|"/" {
    check_comment(strlen(yytext));
    printf( "Um operador: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),row,col );
    col += strlen(yytext);
    return T_OP_DIV;
}


"//"(.)* {
    check_comment(strlen(yytext));
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
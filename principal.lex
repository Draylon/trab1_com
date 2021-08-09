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
    return T_INT;
    
    
}

{DIGITO}+"."{DIGITO}* {
    

    col += strlen(yytext);
    return T_REAL;
    
}

void|char|short|int|long|float|double|signed|unsigned {
    

    col += strlen(yytext);
    return T_PRIMITIVO;
}

"#include" {
    

    col += strlen(yytext);
    return T_INCLUDE;
    
}

"#define" {
    

    col += strlen(yytext);
    return T_DEFINE;
}

"<"{ARQUIVO}">" {
    

    col += strlen(yytext);
    return T_LIBRARY;
}

"\""({TEXTO}|.)*"\"" {
    

    col += strlen(yytext);
    return T_STRING;
}



"(" {
    

    col += strlen(yytext);
    return T_LEFT_PARENTHESES;
}

")" {
    

    col += strlen(yytext);
    return T_RIGHT_PARENTHESES;
    
}

"{" {
    

    col += strlen(yytext);
    return T_LEFT_BLOCK;
}

"}" {
    

    col += strlen(yytext);
    return T_RIGHT_BLOCK;
    
}

"[" {
    

    col += strlen(yytext);
    return T_LEFT_POINTER;
    
}

"]" {
    

    col += strlen(yytext);
    return T_RIGHT_POINTER;
    
}

"=="|"!="|"!=="|"<="|">="|"<"|">" {
    

    col += strlen(yytext);
    return T_LOGIC_OPERATOR;
    
}

"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|=" {
    

    col += strlen(yytext);
    return T_ASSIGN;
}

";" {
    

    col += strlen(yytext);
    return T_SEPARATOR;
}



"+" {
    

    col += strlen(yytext);
    return T_OP_SUM;
    
}

"-" {
    

    col += strlen(yytext);
    return T_OP_SUB;
}

"*" {
    

    col += strlen(yytext);
    return T_OP_MUL;
    
}

"+"|"-"|"*"|"/" {
    

    col += strlen(yytext);
    return T_OP_DIV;
}


"//"(.)* {
    

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
    

        return T_RESERVED;
    
}

"return" {
    col += strlen(yytext);
    

        return T_RETURN;
    
}



for|while {
    col += strlen(yytext);
    

        return T_LOOP;
    
}

when {
    col += strlen(yytext);
    

        return T_SWITCH;
    
}

if {
    col += strlen(yytext);
    

        return T_CONDICIONAL;
    
}

else {
    col += strlen(yytext);
    

        return T_CONT_CONDICIONAL;
    
}






{ID} {
    col += strlen(yytext);
    

        return T_ID;
    
}

" " {
    col+=1;
}

\t {
    col+=4;
}

[\r]+ {
    

    col=1;
}
[\n]+ {
    

    row+=1;
    return T_NEWLINE;
}

. {
    

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
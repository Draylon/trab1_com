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

int check_comment(int s){
    if(comment == 1){
        col+=s;
        return 1;
    }
    return 0;
}

void parse_print(const char* title,const char* yytext){
    printf( "%s: ,%s, ,%zu, (%d) encontrado em ( %d : %d )\n",title, yytext,strlen(yytext),atoi( yytext ),row,col );
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
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}

    parse_print("Um valor inteiro",yytext);
    col += strlen(yytext);
    return T_INT;
    
    
}

{DIGITO}+"."{DIGITO}* {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Um valor real",yytext);
    col += strlen(yytext);
    return T_REAL;
    
}

const {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Constante",yytext);
    col += strlen(yytext);
    return T_CONST;
}

void|char|short|int|long|float|double|signed|unsigned {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Tipo primitivo",yytext);
    col += strlen(yytext);
    return T_PRIMITIVO;
}

"#include" {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Incluindo algo",yytext);
    col += strlen(yytext);
    return T_INCLUDE;
    
}

"#define" {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Definição",yytext);
    col += strlen(yytext);
    return T_DEFINE;
}

"<"{ARQUIVO}">" {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Biblioteca",yytext);
    col += strlen(yytext);
    return T_LIBRARY;
}

"\""({TEXTO}|.)*"\"" {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("String",yytext);
    col += strlen(yytext);
    return T_STRING;
}



"(" {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Abre parenteses",yytext);
    col += strlen(yytext);
    return T_LEFT_PARENTHESES;
}

")" {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Fecha parenteses",yytext);
    col += strlen(yytext);
    return T_RIGHT_PARENTHESES;
    
}

"{" {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Abre bloco de função",yytext);
    col += strlen(yytext);
    return T_LEFT_BLOCK;
}

"}" {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Fecha bloco de função",yytext);
    col += strlen(yytext);
    return T_RIGHT_BLOCK;
    
}

"[" {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Abre colchete",yytext);
    col += strlen(yytext);
    return T_LEFT_POINTER;
    
}

"]" {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Fecha colchete",yytext);
    col += strlen(yytext);
    return T_RIGHT_POINTER;
    
}

"=="|"!="|"!=="|"<="|">="|"<"|">" {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Um sinal lógico",yytext);
    col += strlen(yytext);
    return T_LOGIC_OPERATOR;
    
}

"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|=" {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Atribuição",yytext);
    col += strlen(yytext);
    return T_ASSIGN;
}

"++"|"--" {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Incremento",yytext);
    col += strlen(yytext);
    return T_INCREMENT;
}

";" {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Separador",yytext);
    col += strlen(yytext);
    return T_SEPARATOR;
}

"," {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Separador",yytext);
    col += strlen(yytext);
    return T_EXPR_SEPARATOR;
}

"->" {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Ponteiro de seta",yytext);
    col += strlen(yytext);
    return T_ARROW_RIGHT;
}



"+" {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Soma",yytext);
    col += strlen(yytext);
    return T_OP_SUM;
    
}

"-" {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Subtracao",yytext);
    col += strlen(yytext);
    return T_OP_SUB;
}

"*" {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Multiplicacao",yytext);
    col += strlen(yytext);
    return T_OP_MUL;
    
}

"+"|"-"|"*"|"/" {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Um operador",yytext);
    col += strlen(yytext);
    return T_OP_DIV;
}


\/\/(.)* {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Comentario de uma linha",yytext);
    col += strlen(yytext);
    return T_SLC;
}

"/*" {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    comment=1;
    parse_print("MLC Start",yytext);
    col += strlen(yytext);
    return T_MLC_START;
}
"*/" {
    comment=0;
    parse_print("MLC End",yytext);
    col += strlen(yytext);
    return T_MLC_END;
}


print|setlocale {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Palavra reservada",yytext);
    col += strlen(yytext);
    return T_RESERVED;
    
}

"return" {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Return",yytext);
    col += strlen(yytext);
    return T_RETURN;
}



for|while {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Laço",yytext);
    col += strlen(yytext);
    return T_LOOP;
    
}

when {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Seletor when",yytext);
    col += strlen(yytext);
    return T_SWITCH;
}

if {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Estrutura lógica",yytext);
    col += strlen(yytext);
    return T_CONDICIONAL;
    
}

else {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Estrutura lógica",yytext);
    col += strlen(yytext);
    return T_CONT_CONDICIONAL;
    
}






{ID} {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Um identificador",yytext);
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
    
    printf("Carrier Return\n");
    col=1;
}
[\n]+ {
    
    printf("Quebra de linha\n");
    row+=1;
    return T_NEWLINE;
}

. {
    if(check_comment(strlen(yytext))){return T_COMMENT_C;}
    parse_print("Caracter não reconhecido",yytext);
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
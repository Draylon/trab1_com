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

%token<ival> T_INT
%token<fval> T_REAL
%token T_PLUS T_MINUS T_MULTIPLY T_DIVIDE T_LEFT T_RIGHT
%token T_NEWLINE T_QUIT
%token T_SWITCH T_LEFT_BLOCK T_LEFT_PARENTHESES T_RIGHT_BLOCK T_RIGHT_PARENTHESES
%token T_ASSIGN T_CONDICIONAL T_ID T_RESERVED T_RETURN T_LOGIC_OPERATOR T_PRIMITIVO
%token T_DEFINE T_SLC T_STRING T_INCLUDE T_LIBRARY T_LEFT_POINTER T_RIGHT_POINTER
%token T_OP_SUM T_OP_SUB T_OP_MUL T_OP_DIV
%token T_MLC_START T_MLC_END T_LOOP T_CONT_CONDICIONAL T_EMPTY
%token T_TAB T_CARRIER T_UNKNOWN T_SEPARATOR
%left T_PLUS T_MINUS
%left T_MULTIPLY T_DIVIDE

%type<ival> expr
%type<fval> mixed_expr

%start start_

%%

start_:	start_2;

start_2: statement T_NEWLINE start_2
	| T_NEWLINE start_2
	| ;

statement: condicional
	| when
	| declaracao
	| comentario
	;







when: T_SWITCH T_LEFT_PARENTHESES T_ID T_RIGHT_PARENTHESES switch_block;

switch_block: T_LEFT_BLOCK switch_statement T_RIGHT_BLOCK;

switch_statement: ;



condicao: T_ID T_LOGIC_OPERATOR T_ID;

condicional: T_CONDICIONAL T_LEFT_PARENTHESES condicao T_RIGHT_PARENTHESES statement { printf("Sintático condicional\n");};


declaracao: T_PRIMITIVO T_ID T_ASSIGN mixed_expr T_SEPARATOR { printf("Sintático atribuição\n");};



comentario: T_SLC T_NEWLINE {printf("Sintatico Comentário unica linha\n");}
	| T_MLC_START comm_ml T_MLC_END {printf("Sintatico Comentário multi-linhas\n");};

comm_ml: T_INT comm_ml | T_REAL comm_ml | T_PLUS comm_ml | T_MINUS comm_ml | T_MULTIPLY comm_ml | T_DIVIDE comm_ml | T_LEFT comm_ml | T_RIGHT comm_ml | T_NEWLINE comm_ml | T_QUIT comm_ml | T_SWITCH comm_ml | T_LEFT_BLOCK comm_ml | T_LEFT_PARENTHESES comm_ml | T_RIGHT_BLOCK comm_ml | T_RIGHT_PARENTHESES comm_ml | T_ASSIGN comm_ml | T_CONDICIONAL comm_ml | T_ID comm_ml | T_RESERVED comm_ml | T_RETURN comm_ml | T_LOGIC_OPERATOR comm_ml | T_PRIMITIVO comm_ml | T_DEFINE comm_ml | T_SLC comm_ml | T_STRING comm_ml | T_INCLUDE comm_ml | T_LIBRARY comm_ml | T_LEFT_POINTER comm_ml | T_RIGHT_POINTER comm_ml | T_OP_SUM comm_ml | T_OP_SUB comm_ml | T_OP_MUL comm_ml | T_OP_DIV comm_ml | T_LOOP comm_ml | T_CONT_CONDICIONAL comm_ml | T_EMPTY comm_ml | T_TAB comm_ml | T_CARRIER comm_ml | T_UNKNOWN comm_ml | T_SEPARATOR comm_ml | T_PLUS comm_ml | T_MINUS comm_ml | T_MULTIPLY comm_ml | T_DIVIDE | ;




mixed_expr: T_REAL							{ $$ = $1; }
	| mixed_expr T_PLUS mixed_expr		{ $$ = $1 + $3; }
	| mixed_expr T_MINUS mixed_expr		{ $$ = $1 - $3; }
	| mixed_expr T_MULTIPLY mixed_expr	{ $$ = $1 * $3; }
	| mixed_expr T_DIVIDE mixed_expr		{ $$ = $1 / $3; }
	| T_LEFT mixed_expr T_RIGHT			{ $$ = $2; }
	| expr T_PLUS mixed_expr				{ $$ = $1 + $3; }
	| expr T_MINUS mixed_expr				{ $$ = $1 - $3; }
	| expr T_MULTIPLY mixed_expr			{ $$ = $1 * $3; }
	| expr T_DIVIDE mixed_expr				{ $$ = $1 / $3; }
	| mixed_expr T_PLUS expr				{ $$ = $1 + $3; }
	| mixed_expr T_MINUS expr				{ $$ = $1 - $3; }
	| mixed_expr T_MULTIPLY expr			{ $$ = $1 * $3; }
	| mixed_expr T_DIVIDE expr				{ $$ = $1 / $3; }
	| expr T_DIVIDE expr						{ $$ = $1 / (float)$3; }
	| expr
	;

expr: T_INT									{ $$ = $1; }
	| expr T_PLUS expr						{ $$ = $1 + $3; }
	| expr T_MINUS expr						{ $$ = $1 - $3; }
	| expr T_MULTIPLY expr					{ $$ = $1 * $3; }
	| T_LEFT expr T_RIGHT					{ $$ = $2; }
	;


%%

/*

funcao: T_ID T_LEFT_PARENTHESES T_RIGHT_PARENTHESES function_block;

block: T_RIGHT_BLOCK T_RESERVED T_LEFT_BLOCK;

function_block: T_RIGHT_BLOCK T_RESERVED T_RETURN T_ID T_LEFT_BLOCK;

line: T_NEWLINE
	| mixed_expr T_NEWLINE					{ printf("\tResultado: %f\n", $1);}
	| expr T_NEWLINE							{ printf("\tResultado: %i\n", $1); }
	| T_QUIT T_NEWLINE						{ printf("Até mais...\n"); exit(0); }
	;

*/

int main( argc, argv )
int argc;
char **argv;
{
	++argv, --argc;
	if ( argc > 0 )
		yyin = fopen( argv[0], "r" );
	else
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

%{

#include <string>
#include <fstream>
#include <iostream>
#include <set>
#include <map>
#include <cstring>
#include <vector>

#include <stdio.h>
#include <unistd.h>

#include "bytecode_inst.h"


extern int yylex();
extern int yyparse();
extern FILE* yyin;


std::ofstream fout("output.j");

void yyerror(const char* s);

std::map<std::string, std::pair<int,type_enum> > symbTab;

%}

%code requires {
	#include <vector>
}

%union {
    int ival;
    float fval;
    char * idval;
    char * aopval;

    struct {
        int sType;
    } expr_type;

    struct {
        std::vector<int> *trueList, *falseList;
    } bexpr_type;

    struct {
        std::vector<int> *nextList;
    } stmt_type;

    int sType;
}

/* Declaração dos tokens... */

%token<ival> T_INT
%token<fval> T_REAL
%token <bval> BOOL
%token <aopval> T_ARITH_OP
%token <idval> T_ID

%token T_DEFINE T_INCLUDE T_LIBRARY
%token T_PLUS T_MINUS T_MULTIPLY T_DIVIDE T_LEFT T_RIGHT
%token T_NEWLINE T_QUIT
%token T_PRIMITIVO T_RESERVED T_CONST
%token T_SEPARATOR T_EXPR_SEPARATOR;
%token T_LEFT_BLOCK T_RIGHT_BLOCK 
%token T_LEFT_PARENTHESES T_RIGHT_PARENTHESES
%token T_SWITCH T_FOR T_WHILE T_DO
%token T_PRINT
%token T_CONDICIONAL
%left T_CONT_CONDICIONAL
%token T_ASSIGN T_INCREMENT T_RETURN T_LOGIC_OPERATOR T_ARROW_RIGHT
%token T_LEFT_POINTER T_RIGHT_POINTER
%left T_OP_SUM T_OP_SUB T_OP_MUL T_OP_DIV
%token T_MLC_START T_MLC_END T_EMPTY
%token T_STRING T_TAB T_CARRIER T_UNKNOWN
%token T_COMMENT_C T_SLC

%type <sType> primitive_type
%type <expr_type> mixed_expr
%type <bexpr_type> b_expr
%type <stmt_type> logico_if
%type <stmt_type> loop_while
%type <stmt_type> loop_for
%type <stmt_type> when
%type <stmt_type> loop_do
%type <stmt_type> print

%type <ival> marker
%type <ival> goto

%start start_

%%

start_: {createHeader();} start_2;

start_2: statement start_2
    | ;

statement_set: statement | statement marker statement_set;

statement: 
    logico_if
	| when
	| declaracao T_SEPARATOR
	| comentario
	| b_expr
	| chamada_funcao
	| incremento T_SEPARATOR
	| loop_while
	| loop_for
	| loop_do
    | print
    ;

marker:{
	$$ = labelsCount;
	writeCode(genLabel() + ":");
};

goto:{
	$$ = codeList.size();
	writeCode("goto ");
};


print: T_PRINT T_LEFT_PARENTHESES mixed_expr T_RIGHT_PARENTHESES T_SEPARATOR
    {
        /* expression is at top of stack now */
        /* save it at the predefined temp syso var */            
        writeCode("istore " + std::to_string(symbTab["int_expr"].first));
        /* call syso */            
        writeCode("getstatic      java/lang/System/out Ljava/io/PrintStream;");
        /*insert param*/
        writeCode("iload " + std::to_string(symbTab["int_expr"].first ));
        /*invoke syso*/
        writeCode("invokevirtual java/io/PrintStream/println(I)V");
    };





function_block: T_LEFT_BLOCK statement_set T_RIGHT_BLOCK | statement;





chamada_funcao: funcao_scope T_LEFT_PARENTHESES funcao_args T_RIGHT_PARENTHESES T_SEPARATOR {printf("\033[0;34mSintático chamada de funcao\033[0m\n");};
funcao_scope: T_RESERVED | T_ID;
funcao_args: | T_STRING | T_ID ;






when: T_SWITCH T_LEFT_PARENTHESES T_ID T_RIGHT_PARENTHESES T_LEFT_BLOCK switch_statement T_RIGHT_BLOCK {printf("\033[0;34mSintático When\033[0m\n");};

switch_statement: T_ID T_ARROW_RIGHT function_block switch_statement
    | mixed_expr T_ARROW_RIGHT function_block switch_statement
    | T_CONT_CONDICIONAL T_ARROW_RIGHT function_block switch_statement
    | ;





loop_while: T_WHILE T_LEFT_PARENTHESES loop_while_cond T_RIGHT_PARENTHESES function_block { printf("\033[0;34mSintático LOOP\033[0m\n");};

loop_while_cond: b_expr loop_while_cond | ;



primitive_type: 
	T_INT {$$ = T_INT; /* não sei pra que exatamente, mais peguei kkkkk */ }
	;



loop_for: T_FOR T_LEFT_PARENTHESES loop_for_cond T_RIGHT_PARENTHESES function_block { printf("\033[0;34mSintático LOOP\033[0m\n");};

loop_for_cond: loop_for_dec T_SEPARATOR loop_for_condicao T_SEPARATOR loop_for_inc;
loop_for_dec: declaracao | ;
loop_for_condicao: b_expr;
loop_for_inc: incremento | ;




loop_do: 
    T_DO function_block T_WHILE 
    T_LEFT_PARENTHESES loop_while_cond T_RIGHT_PARENTHESES T_SEPARATOR {
        printf("\033[0;34mSintático condicional 1\033[0m\n");
    };



b_expr: 
    mixed_expr T_LOGIC_OPERATOR mixed_expr { printf("\033[0;34mSintático condicional 1\033[0m\n");}
  | T_ID T_LOGIC_OPERATOR mixed_expr { printf("\033[0;34mSintático condicional 2\033[0m\n");}
  | mixed_expr T_LOGIC_OPERATOR T_ID { printf("\033[0;34mSintático condicional 3\033[0m\n");}
  | T_ID T_LOGIC_OPERATOR T_ID { printf("\033[0;34mSintático condicional 4\033[0m\n");}
  | T_LEFT_PARENTHESES b_expr T_RIGHT_PARENTHESES { printf("\033[0;34mSintático condicional 5\033[0m\n");};






logico_if: cond_2 { printf("\033[0;34mSintático logico_if sem else\033[0m\n");}
    | T_CONT_CONDICIONAL function_block { printf("\033[0;34mSintático logico_if com else\033[0m\n");}
    ;

cond_2: T_CONDICIONAL T_LEFT_PARENTHESES b_expr T_RIGHT_PARENTHESES function_block;





assign: 
	  T_ID T_ASSIGN mixed_expr { printf("\033[0;34mSintático atribuição sem primitivo\033[0m\n");}
    | T_ID T_ASSIGN b_expr { printf("\033[0;34mSintático atribuição sem primitivo\033[0m\n") }
    ;



declaracao: primitive_type T_ID T_ASSIGN mixed_expr {
    printf("\033[0;34mSintático atribuição\033[0m\n");
    std::string str($2);
    defineVariable(str,1);
};



incremento: T_ID T_INCREMENT {printf("\033[0;34mIncremento\033[0m\n");};




comentario: T_SLC {printf("\033[0;34mSintatico Comentário unica linha\033[0m\n");}
    | T_MLC_START comm_ml T_MLC_END {printf("\033[0;34mSintatico Comentário multi-linhas\033[0m\n");};

comm_ml: T_COMMENT_C comm_ml | ;

mixed_expr: T_INT {
        $$.sType = T_INT;
        writeCode("ldc "+std::to_string($1));
    }
    | mixed_expr T_ARITH_OP mixed_expr {
        arithCast(std::string($2));
    }
    | T_LEFT mixed_expr T_RIGHT      { $$.sType = $2.sType; }
    ;



%%

/*

| expr T_PLUS mixed_expr                { $$ = $1 + $3; }
    | expr T_MINUS mixed_expr                { $$ = $1 - $3; }
    | expr T_MULTIPLY mixed_expr            { $$ = $1 * $3; }
    | expr T_DIVIDE mixed_expr                { $$ = $1 / $3; }
    | mixed_expr T_PLUS expr                { $$ = $1 + $3; }
    | mixed_expr T_MINUS expr                { $$ = $1 - $3; }
    | mixed_expr T_MULTIPLY expr            { $$ = $1 * $3; }
    | mixed_expr T_DIVIDE expr                { $$ = $1 / $3; }
    | expr T_DIVIDE expr                        { $$ = $1 / (float)$3; }


comentario: T_SLC T_NEWLINE {printf("Sintatico Comentário unica linha\n");}
    | T_MLC_START comm_ml T_MLC_END {printf("Sintatico Comentário multi-linhas\n");};

comm_ml: T_INT comm_ml | T_REAL comm_ml | T_PLUS comm_ml | T_MINUS comm_ml | T_MULTIPLY comm_ml | T_DIVIDE comm_ml | T_LEFT comm_ml | T_RIGHT comm_ml | T_NEWLINE comm_ml | T_QUIT comm_ml | T_SWITCH comm_ml | T_LEFT_BLOCK comm_ml | T_LEFT_PARENTHESES comm_ml | T_RIGHT_BLOCK comm_ml | T_RIGHT_PARENTHESES comm_ml | T_ASSIGN comm_ml | T_CONDICIONAL comm_ml | T_ID comm_ml | T_RESERVED comm_ml | T_RETURN comm_ml | T_LOGIC_OPERATOR comm_ml | T_PRIMITIVO comm_ml | T_DEFINE comm_ml | T_SLC comm_ml | T_STRING comm_ml | T_INCLUDE comm_ml | T_LIBRARY comm_ml | T_LEFT_POINTER comm_ml | T_RIGHT_POINTER comm_ml | T_OP_SUM comm_ml | T_OP_SUB comm_ml | T_OP_MUL comm_ml | T_OP_DIV comm_ml | T_LOOP comm_ml | T_CONT_CONDICIONAL comm_ml | T_EMPTY comm_ml | T_TAB comm_ml | T_CARRIER comm_ml | T_UNKNOWN comm_ml | T_SEPARATOR comm_ml | T_PLUS comm_ml | T_MINUS comm_ml | T_MULTIPLY comm_ml | T_DIVIDE | ;

expr: T_INT                                    { $$ = $1; }
    | expr T_PLUS expr                        { $$ = $1 + $3; }
    | expr T_MINUS expr                        { $$ = $1 - $3; }
    | expr T_MULTIPLY expr                    { $$ = $1 * $3; }
    | T_LEFT expr T_RIGHT                    { $$ = $2; }
    ;

funcao: T_ID T_LEFT_PARENTHESES T_RIGHT_PARENTHESES function_block;

block: T_RIGHT_BLOCK T_RESERVED T_LEFT_BLOCK;

function_block: T_RIGHT_BLOCK T_RESERVED T_RETURN T_ID T_LEFT_BLOCK;

line: T_NEWLINE
    | mixed_expr T_NEWLINE                    { printf("\tResultado: %f\n", $1);}
    | expr T_NEWLINE                            { printf("\tResultado: %i\n", $1); }
    | T_QUIT T_NEWLINE                        { printf("Até mais...\n"); exit(0); }
    ;

*/

/* int main( argc, argv )
int argc;
char **argv;
{ */


void printCode(void){
	for ( int i = 0 ; i < codeList.size() ; i++)
	{
		fout<<codeList[i]<<std::endl;
	}
}

void yyerror(const char* s) {
    fprintf(stderr, "Erro de análise (sintática): -- %s --\n", s);
    exit(1);
}


int main (int argv, char * argc[]){
    ++argc, --argv;
    if ( argv > 0 ){
        yyin = fopen( argc[0], "r" );
        outfileName = std::string(argc[1]);
    }else{
        yyin = stdin;
        outfileName = "input_code.txt";
    }
    do {
        yyparse();
    } while(!feof(yyin));
    printCode();

    return 0;
}


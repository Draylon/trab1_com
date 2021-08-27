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

extern int yylex(void);
extern int yyparse(void);
extern FILE* yyin;


std::ofstream fout("output.j");

void yyerror(const char* s);

%}

%code requires {
    #include <vector>
}

%union {
    int ival;
    float fval;
    char * idval;
    char * aopval;
    int bval;

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

%token<ival> INT
%token<fval> FLOAT
%token <bval> BOOL
%token <aopval> T_ARITH_OP
%token <idval> T_ID

%token T_INT
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
%type <expr_type> expression
%type <bexpr_type> b_expression
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

start_: {createHeader();} start_2 {createFooter();};

start_2: statement start_2
    | ;

statement_set: statement | statement marker statement_set;

statement: 
    logico_if
    | when
    | declaracao T_SEPARATOR
    | comentario
    | chamada_funcao
    | incremento T_SEPARATOR
    | loop_while
    | loop_for
    | loop_do
    | print
    | assign
    ;

marker:{
    $$ = labelsCount;
    writeCode(genLabel() + ":");
};

goto:{
    $$ = codeList.size();
    writeCode("goto ");
};


print: T_PRINT T_LEFT_PARENTHESES expression T_RIGHT_PARENTHESES T_SEPARATOR
    {
        writeCode("istore " + std::to_string(lista_simbolos["int_expr"].first));
        writeCode("getstatic      java/lang/System/out Ljava/io/PrintStream;");
        writeCode("iload " + std::to_string(lista_simbolos["int_expr"].first ));
        writeCode("invokevirtual java/io/PrintStream/println(I)V");
    };





function_block: T_LEFT_BLOCK statement_set T_RIGHT_BLOCK | statement;





chamada_funcao: funcao_scope T_LEFT_PARENTHESES funcao_args T_RIGHT_PARENTHESES T_SEPARATOR {printf("\033[0;34mSintático chamada de funcao\033[0m\n");};
funcao_scope: T_RESERVED | T_ID;
funcao_args: | T_STRING | T_ID ;






when: T_SWITCH T_LEFT_PARENTHESES T_ID T_RIGHT_PARENTHESES T_LEFT_BLOCK switch_statement T_RIGHT_BLOCK {printf("\033[0;34mSintático When\033[0m\n");};

switch_statement: T_ID T_ARROW_RIGHT function_block switch_statement
    | expression T_ARROW_RIGHT function_block switch_statement
    | T_CONT_CONDICIONAL T_ARROW_RIGHT function_block switch_statement
    | ;





loop_while: T_WHILE T_LEFT_PARENTHESES loop_while_cond T_RIGHT_PARENTHESES function_block { printf("\033[0;34mSintático LOOP\033[0m\n");};

loop_while_cond: b_expression loop_while_cond | ;



primitive_type: T_INT { $$ = E_INT;};



loop_for: T_FOR T_LEFT_PARENTHESES loop_for_cond T_RIGHT_PARENTHESES function_block { printf("\033[0;34mSintático LOOP\033[0m\n");};

loop_for_cond: loop_for_dec T_SEPARATOR loop_for_condicao T_SEPARATOR loop_for_inc;
loop_for_dec: declaracao | ;
loop_for_condicao: b_expression;
loop_for_inc: incremento | ;




loop_do: 
    T_DO function_block T_WHILE 
    T_LEFT_PARENTHESES loop_while_cond T_RIGHT_PARENTHESES T_SEPARATOR {
        printf("\033[0;34mSintático condicional 1\033[0m\n");
    };



b_expression: 
    expression T_LOGIC_OPERATOR expression { printf("\033[0;34mSintático condicional 1\033[0m\n");}
  | b_expression T_LOGIC_OPERATOR b_expression { printf("\033[0;34mSintático condicional 1\033[0m\n");}
  | T_ID T_LOGIC_OPERATOR expression { printf("\033[0;34mSintático condicional 2\033[0m\n");}
  | expression T_LOGIC_OPERATOR T_ID { printf("\033[0;34mSintático condicional 3\033[0m\n");}
  | T_ID T_LOGIC_OPERATOR T_ID { printf("\033[0;34mSintático condicional 4\033[0m\n");}
  | T_LEFT_PARENTHESES b_expression T_RIGHT_PARENTHESES { printf("\033[0;34mSintático condicional 5\033[0m\n");};






logico_if: cond_2 { printf("\033[0;34mSintático logico_if sem else\033[0m\n");}
    | T_CONT_CONDICIONAL function_block { printf("\033[0;34mSintático logico_if com else\033[0m\n");}
    ;

cond_2: T_CONDICIONAL T_LEFT_PARENTHESES b_expression T_RIGHT_PARENTHESES function_block;





assign: 
    T_ID T_ASSIGN expression {
        printf("\033[0;34mSintático atribuição sem primitivo\033[0m\n");
        std::string str($1);
        if(checkId(str)){
            if($3.sType == E_INT){
                writeCode("istore " + std::to_string(lista_simbolos[str].first));
            }
        }else{
            std::string err = "identifier: "+str+" isn't declared in this scope";
            yyerror(err.c_str());
        }
    };



declaracao: primitive_type T_ID T_ASSIGN expression {
        printf("\033[0;34mSintático atribuição com valor\033[0m\n");
        std::cout << "teste 1" << std::endl;
        std::string str($2);
        std::cout << "teste 2" << std::endl;
        if($1 == E_INT){
            defineVariable(str,E_INT);
            writeCode("istore " + std::to_string(lista_simbolos[str].first));
        }
    }
    | primitive_type T_ID {
        printf("\033[0;34mSintático atribuição\033[0m\n");
        std::string str($2);
        if($1 == E_INT){
            defineVariable(str,E_INT);
        }
    };



incremento: T_ID T_INCREMENT {printf("\033[0;34mIncremento\033[0m\n");};




comentario: T_SLC {printf("\033[0;34mSintatico Comentário unica linha\033[0m\n");}
    | T_MLC_START comm_ml T_MLC_END {printf("\033[0;34mSintatico Comentário multi-linhas\033[0m\n");};

comm_ml: T_COMMENT_C comm_ml | ;

expression: INT {
        $$.sType = E_INT; writeCode("ldc "+std::to_string($1));
    }
    | expression T_ARITH_OP expression {
        arithCast(std::string($2));
    }
    | T_LEFT expression T_RIGHT      { $$.sType = $2.sType; }
    | T_ID {
		std::string str($1);
		if(checkId(str)){
			$$.sType = lista_simbolos[str].second;
			if(lista_simbolos[str].second == E_INT){
				writeCode("iload " + std::to_string(lista_simbolos[str].first));
			}
		}else{
			std::string err = "id: "+str+" fora do escopo";
			yyerror(err.c_str());
		}
	}
    ;



%%

/*

| expr T_PLUS expression                { $$ = $1 + $3; }
    | expr T_MINUS expression                { $$ = $1 - $3; }
    | expr T_MULTIPLY expression            { $$ = $1 * $3; }
    | expr T_DIVIDE expression                { $$ = $1 / $3; }
    | expression T_PLUS expr                { $$ = $1 + $3; }
    | expression T_MINUS expr                { $$ = $1 - $3; }
    | expression T_MULTIPLY expr            { $$ = $1 * $3; }
    | expression T_DIVIDE expr                { $$ = $1 / $3; }
    | expr T_DIVIDE expr                        { $$ = $1 / (float)$3; }

expr: INT                                    { $$ = $1; }
    | expr T_PLUS expr                        { $$ = $1 + $3; }
    | expr T_MINUS expr                        { $$ = $1 - $3; }
    | expr T_MULTIPLY expr                    { $$ = $1 * $3; }
    | T_LEFT expr T_RIGHT                    { $$ = $2; }
    ;

line: T_NEWLINE
    | expression T_NEWLINE                    { printf("\tResultado: %f\n", $1);}
    | expr T_NEWLINE                            { printf("\tResultado: %i\n", $1); }
    | T_QUIT T_NEWLINE                        { printf("Até mais...\n"); exit(0); }
    ;

*/

/* int main( argc, argv )
int argc;
char **argv;
{ */


void printCode(void){
    for ( int i = 0 ; i < codeList.size() ; i++){
        fout<<codeList[i]<<std::endl;
    }
}

void yyerror(const char* s) {
    fprintf(stderr, "Erro de análise (sintática): -- %s --\n", s);
    exit(1);
}


int main (int argc, char * argv[]){
    --argc, ++argv;
    if ( argv > 0 ){
        yyin = fopen( argv[0], "r" );
        outfileName = std::string(argv[0]);
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
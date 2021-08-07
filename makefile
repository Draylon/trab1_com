file_name = if
bison_file = grammar.y
lex_file = principal.lex

all: bison flex gcc 

bison: 
	bison -d -Wcounterexamples $(bison_file) 

flex: 
	flex $(lex_file)

gcc: 
	gcc grammar.tab.c lex.yy.c -o $(file_name) -lm

clean: 
	rm -f $(file_name)  *.c *.h 

all: bison flex gcc

gcc:
	gcc grammar.tab.c lex.yy.c -lm -lfl -o binary

flex:
	flex principal.lex

bison:
	bison -d -v grammar.y

clean:
	rm -rf *.c
	rm -rf *.h
	rm -rf *.dot
	rm -rf *.output
	rm -rf *.tab.*
	rm -rf *.o
	rm -rf *.exe
	rm -rf binary

run: clean all
	./binary ./testes/arquivo.txt

flex_run: clean flex
	gcc lex.yy.c -lfl -lm -o binary

bison_run: clean
	bison -d -g grammar.y
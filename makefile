
all: bison flex gcc

gcc:
	gcc grammar.tab.c lex.yy.c -lm -lfl -o binary

flex:
	flex principal.lex

bison:
	bison -d grammar.y

clean:
	rm -rf *.o
	rm -rf *.exe
	rm -rf binary

run: clean all
	./binary arquivo.txt

flex_run: clean flex
	gcc lex.yy.c -lfl -lm -o binary

all: bison flex gcc

gcc:
	gcc grammar.tab.c -lfl -o binary

flex:
	flex principal.lex

bison:
	bison -d grammar.y

clean:
	rm -rf *.o
	rm -rf *.exe
	rm -rf binary

run: clean all
	./binary codigo-exemplo.c

run: clean all
	./binary codigo-exemplo.c
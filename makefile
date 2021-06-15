
all: flex gcc

gcc:
	gcc lex.yy.c -lfl -o binary

flex:
	flex principal.lex

clean:
	rm -rf *.o
	rm -rf *.exe
	rm -rf binary

run: clean all
	./binary codigo-exemplo.c

run: clean all
	./binary codigo-exemplo.c
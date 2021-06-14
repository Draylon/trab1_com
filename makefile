
all: linux

linux: flex_l main

windows: flex_w main

main:
	gcc lex.yy.c -lfl -o binary

flex_l:
	flex principal_linux.lex

flex_w:
	flex principal_windows.lex

clean:
	rm -rf *.o
	rm -rf *.exe
	rm -rf binary

run_win: clean windows
	./binary codigo-exemplo.c

run_linux: clean linux
	./binary codigo-exemplo.c
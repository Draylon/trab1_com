
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

#========
# jasmin
#========

exec: all
	./a.out

java:
	javac test.java
	javap -c test.class

error: 
	bison --verbose syntax.y

custom_run: all
	./a.out tests/test6
	java -jar ./jasmin-1.1/jasmin.jar output.j
	java test

jasmine_temp:
	java -jar ./jasmin-1.1/jasmin.jar output.j

d_jasmine_temp:
	java.exe -jar ./jasmin-1.1/jasmin.jar output.j

java_run:
	java test

d_java_run:
	javac.exe tests/test.java
	javap.exe -c test.class
	java.exe test

exec_jasm: exec jasmine_temp run

d_exec_jasm: exec d_jasmine_temp d_run

all: bison flex gcc

gcc:
	g++ -std=c++11 grammar.tab.c lex.yy.c -lm -o binary

flex:
	flex principal.lex

bison:
	bison -d -v grammar.y

clean:
	rm -rf *.c
	rm -rf *.dot
	rm -rf *.output
	rm -rf *.tab.*
	rm -rf *.o
	rm -rf *.exe
	rm -rf binary
	rm -rf *.j

run: clean all
	./binary ./testes/arquivo.txt

flex_run: clean flex
	g++ lex.yy.c -lfl -lm -o binary

bison_graph: clean
	bison -d -g grammar.y

#========
# jasmin
#========

exec: all
	./binary

java:
	javac test.java
	javap -c test.class

error: 
	bison --verbose syntax.y

custom_run: all
	./binary tests/test6
	java -jar ./jasmin.jar output.j
	java test

jasmine_temp:
	java -jar ./jasmin.jar output.j

d_jasmine_temp:
	java.exe -jar ./jasmin.jar output.j

java_run:
	java test

d_java_run:
	javac.exe tests/test.java
	javap.exe -c test.class
	java.exe test

d_run:
	java.exe test

exec_jasm: exec jasmine_temp java_run

d_jsm: d_jasmine_temp d_run
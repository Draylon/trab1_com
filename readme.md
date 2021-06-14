# Como funciona:

## Sem make:
```bash
flex principal_linux.lex
ou
flex principal_windows.lex


gcc lex.yy.c -lfl -o binary


./binary codigo-exemplo.c
```

## Com make:
```bash
make run_win

ou

make run_linux
```
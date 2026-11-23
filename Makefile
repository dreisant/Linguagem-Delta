CC = gcc
CFLAGS = -Wall -Wextra
FLEX = flex
BISON = bison
TARGET = delta

.PHONY: all test clean

all: $(TARGET)

parser.tab.c parser.tab.h: parser.y
	$(BISON) -d -v parser.y

lex.yy.c: lexer.l parser.tab.h
	$(FLEX) lexer.l

$(TARGET): parser.tab.c lex.yy.c
	$(CC) $(CFLAGS) -o $(TARGET) parser.tab.c lex.yy.c

test: $(TARGET)
	@echo "=== Executando testes validos ==="
	./$(TARGET) tests/teste_valido.dt
	./$(TARGET) tests/teste_completo.dt
	@echo "=== Executando testes invalidos (devem falhar) ==="
	! ./$(TARGET) tests/erro_lexico.dt
	! ./$(TARGET) tests/erro_sintatico_op.dt
	! ./$(TARGET) tests/erro_sintatico_paren.dt
	@echo "=== Todos os testes passaram ==="

clean:
	rm -f $(TARGET) $(TARGET).exe lex.yy.c parser.tab.c parser.tab.h parser.output

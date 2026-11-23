%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex(void);
extern int yylineno;
extern char *yytext;
extern FILE *yyin;
extern int erros_lexicos;

int erros_sintaticos = 0;

void yyerror(const char *s);
%}

%define parse.error verbose

%token VAL "val"
%token VAR "var"
%token INT "int"
%token FLOAT "float"
%token IF "if"
%token ELSE "else"
%token WHILE "while"
%token PRINT "print"

%token ID "identificador"
%token NUM_INT "numero inteiro"
%token NUM_FLOAT "numero float"

%token OP_SOMA "+"
%token OP_SUB "-"
%token OP_MULT "*"
%token OP_DIV_REAL "/"
%token OP_DIV_INT "//"
%token OP_POT "^"

%token OP_IGUAL "=="
%token OP_DIF "!="
%token OP_MENOR "<"
%token OP_MENOR_IGUAL "<="
%token OP_MAIOR ">"
%token OP_MAIOR_IGUAL ">="

%token OP_ATRIB "="

%token ABRE_PAR "("
%token FECHA_PAR ")"
%token ABRE_CHAVE "{"
%token FECHA_CHAVE "}"
%token DOIS_PONTOS ":"
%token PONTO_VIRGULA ";"

%token ERRO_LEXICO "caractere invalido"

%start programa

%%

programa
    : lista_sentencas
    ;

lista_sentencas
    : lista_sentencas sentenca
    | sentenca
    ;

sentenca
    : declaracao
    | atribuicao
    | comando_condicional
    | comando_repeticao
    | comando_impressao
    ;

declaracao
    : VAL ID DOIS_PONTOS tipo OP_ATRIB expressao PONTO_VIRGULA
    | VAR ID DOIS_PONTOS tipo OP_ATRIB expressao PONTO_VIRGULA
    | VAR ID DOIS_PONTOS tipo PONTO_VIRGULA
    ;

tipo
    : INT
    | FLOAT
    ;

atribuicao
    : ID OP_ATRIB expressao PONTO_VIRGULA
    ;

bloco
    : ABRE_CHAVE lista_sentencas FECHA_CHAVE
    ;

comando_condicional
    : IF ABRE_PAR expressao_relacional FECHA_PAR bloco
    | IF ABRE_PAR expressao_relacional FECHA_PAR bloco ELSE bloco
    ;

comando_repeticao
    : WHILE ABRE_PAR expressao_relacional FECHA_PAR bloco
    ;

comando_impressao
    : PRINT ABRE_PAR expressao FECHA_PAR PONTO_VIRGULA
    ;

expressao_relacional
    : expressao op_relacional expressao
    ;

op_relacional
    : OP_IGUAL
    | OP_DIF
    | OP_MENOR
    | OP_MENOR_IGUAL
    | OP_MAIOR
    | OP_MAIOR_IGUAL
    ;

expressao
    : expressao_if
    | expressao_arit
    ;

expressao_if
    : IF ABRE_PAR expressao_relacional FECHA_PAR expressao ELSE expressao
    ;

expressao_arit
    : expressao_arit OP_SOMA termo
    | expressao_arit OP_SUB termo
    | termo
    ;

termo
    : termo OP_MULT fator_potencia
    | termo OP_DIV_REAL fator_potencia
    | termo OP_DIV_INT fator_potencia
    | fator_potencia
    ;

fator_potencia
    : fator OP_POT fator_potencia
    | fator
    ;

fator
    : ID
    | NUM_INT
    | NUM_FLOAT
    | ABRE_PAR expressao FECHA_PAR
    ;

%%

void yyerror(const char *s) {
    erros_sintaticos++;
    const char *token_atual = (yytext != NULL && yytext[0] != '\0') ? yytext : "EOF";
    fprintf(stderr, "Erro sintatico na linha %d (proximo a '%s'): %s\n",
            yylineno, token_atual, s);
}

int main(int argc, char **argv) {
    int abriu_arquivo = 0;

    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (yyin == NULL) {
            perror(argv[1]);
            return 1;
        }
        abriu_arquivo = 1;
    } else {
        yyin = stdin;
    }

    int resultado = yyparse();

    if (abriu_arquivo && yyin != NULL) {
        fclose(yyin);
    }

    if (resultado == 0 && erros_lexicos == 0 && erros_sintaticos == 0) {
        printf("Analise lexica e sintatica concluida com sucesso.\n");
        return 0;
    }

    fprintf(stderr, "Analise encerrada com falhas (%d erro(s) lexico(s), %d erro(s) sintatico(s)).\n",
            erros_lexicos, erros_sintaticos);
    return 1;
}

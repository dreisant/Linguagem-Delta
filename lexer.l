%option noyywrap
%option yylineno
%option nounput
%option noinput

%{
#include <stdio.h>
#include "parser.tab.h"

int erros_lexicos = 0;
%}

DIGITO   [0-9]
LETRA    [a-zA-Z_]
ID_CHAR  [a-zA-Z0-9_]

%%

[ \t\r\n]+              { /* Ignora espacos em branco e quebras de linha */ }
#[^\n]*                 { /* Ignora comentarios de linha unica */ }

"val"                   { return VAL; }
"var"                   { return VAR; }
"int"                   { return INT; }
"float"                 { return FLOAT; }
"if"                    { return IF; }
"else"                  { return ELSE; }
"while"                 { return WHILE; }
"print"                 { return PRINT; }

{DIGITO}+\.{DIGITO}+    { return NUM_FLOAT; }
{DIGITO}+               { return NUM_INT; }
{LETRA}{ID_CHAR}*       { return ID; }

"//"                    { return OP_DIV_INT; }
"=="                    { return OP_IGUAL; }
"!="                    { return OP_DIF; }
"<="                    { return OP_MENOR_IGUAL; }
">="                    { return OP_MAIOR_IGUAL; }

"+"                     { return OP_SOMA; }
"-"                     { return OP_SUB; }
"*"                     { return OP_MULT; }
"/"                     { return OP_DIV_REAL; }
"^"                     { return OP_POT; }
"<"                     { return OP_MENOR; }
">"                     { return OP_MAIOR; }
"="                     { return OP_ATRIB; }

"("                     { return ABRE_PAR; }
")"                     { return FECHA_PAR; }
"{"                     { return ABRE_CHAVE; }
"}"                     { return FECHA_CHAVE; }
":"                     { return DOIS_PONTOS; }
";"                     { return PONTO_VIRGULA; }

.                       {
                            fprintf(stderr, "Erro lexico na linha %d: caractere nao reconhecido '%s'\n",
                                    yylineno, yytext);
                            erros_lexicos++;
                            return ERRO_LEXICO;
                        }

%%

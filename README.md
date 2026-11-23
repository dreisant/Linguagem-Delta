# Linguagem Delta

**Delta** (extensão `.dt`) é uma linguagem de programação imperativa, estruturada em blocos e de tipagem estática explícita, projetada para prototipagem de algoritmos numéricos, computação científica e cálculos matemáticos sem cerimônias sintáticas de orientação a objetos.

## Principais Características

- **Imutabilidade declarativa nativa**: distinção explícita entre constantes imutáveis (`val`) e variáveis mutáveis (`var`).
- **Potenciação nativa (`^`)**: operador próprio com maior precedência e associatividade à direita.
- **Divisão semântica dupla**:
  - `/` — divisão real, que produz resultado em ponto flutuante (`float`) mesmo entre operandos inteiros.
  - `//` — divisão inteira, restrita a operandos `int` com truncamento do resultado.
- **Condicional orientado a expressões**: além da forma tradicional com blocos, `if (...) <expr> else <expr>` pode ser usado como expressão que retorna valor.
- **Tipagem estática e escopo global**: variáveis e constantes são declaradas explicitamente com tipo `int` (32 bits com sinal) ou `float` (IEEE 754), com promoção segura de `int` para `float`.
- **Comentários sem colisão**: comentários de linha única iniciam com `#`, evitando conflito léxico com o operador `//`.

## Exemplo de Código

```text
# Cálculo numérico e controle de fluxo em Delta

val base: float = 2.0;
val expoente: int = 3;

var passo: int = 2;
var contagem: int;
var divReal: float;
var divInteira: int;
var resultado: float;

divInteira = 7 // passo;
divReal = 7 / passo;
resultado = (base ^ expoente * 10.0) / 4 - (divReal + 1.0);

print(divInteira);
print(divReal);
print(resultado);

if (resultado > 10.0) {
    contagem = divInteira;
    while (contagem > 0) {
        print(contagem);
        contagem = contagem - 1;
    }
} else {
    print(0);
}
```

## Referência Rápida da Sintaxe

- **Palavras reservadas**: `val`, `var`, `int`, `float`, `if`, `else`, `while`, `print`
- **Identificadores**: `[a-zA-Z_][a-zA-Z0-9_]*`
- **Literais**: inteiros (`[0-9]+`) e ponto flutuante (`[0-9]+\.[0-9]+`)
- **Delimitadores**: `(`, `)`, `{`, `}`, `:`, `;`
- **Precedência e associatividade dos operadores** (da maior para a menor):

| Nível | Operadores | Associatividade | Descrição |
| :---: | :--- | :--- | :--- |
| 1 | `^` | Direita | Potenciação |
| 2 | `*`, `/`, `//` | Esquerda | Multiplicação, divisão real e divisão inteira |
| 3 | `+`, `-` | Esquerda | Adição e subtração |
| 4 | `==`, `!=`, `<`, `<=`, `>`, `>=` | Não associativos | Operadores relacionais |

## Estrutura do Projeto

| Caminho | Descrição |
| :--- | :--- |
| `lexer.l` | Analisador léxico em Flex (reconhecimento de tokens, comentários `#`, contagem de linhas e detecção de caracteres inválidos). |
| `parser.y` | Analisador sintático LALR(1) em Bison com gramática livre de conflitos e mensagens de erro detalhadas. |
| `Makefile` | Regras de compilação, testes e limpeza para ambientes Unix-like (`flex`, `bison`, `gcc`). |
| `tests/` | Programas `.dt` válidos e casos inválidos (erros léxicos e sintáticos) para validação da linguagem. |

## Compilação e Uso

### Linux / macOS / WSL / MSYS2

```bash
make
./delta tests/teste_valido.dt
```

Para executar a suíte de testes ou limpar os arquivos gerados:

```bash
make test
make clean
```

Também é possível ler código diretamente pela entrada padrão (`stdin`):

```bash
./delta < tests/teste_valido.dt
```

### Windows (WinFlexBison + MinGW/GCC)

```powershell
win_bison -d -v parser.y
win_flex lexer.l
gcc -Wall -Wextra -o delta.exe parser.tab.c lex.yy.c
.\delta.exe tests\teste_valido.dt
```

## Licença

Este projeto está licenciado sob a licença **MIT** — veja o arquivo [LICENSE](LICENSE) para mais detalhes.

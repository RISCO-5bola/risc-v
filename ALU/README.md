# ALU 
A Unidade Lógica e Aritmética é um componente chave responsável por realizar operações aritméticas e lógicas, além de operações lógicas. É um bloco de construção fundamental do pipeline de execução do processador. A ALU recebe operandos de entrada, e executa várias operações neles, com base na instrução fornecida pela ALU Control. A nossa ALU suporta uma ampla gama de operações, listadas mais abaixo.

### Funcionamento geral da ALU:
1. Operações aritméticas: operações aritméticas básicas como adição e subtração de valores inteiros. 
2. Operações Lógicas: operações lógicas, como AND, OR, XOR e deslocamento de bits.
3. Operações de comparação: compara dois valores e determina sua relação, como igualdade, maior que, menor que, etc. 
4. Manipulação de dados: executa operações de manipulação de dados, incluindo deslocamento de bits para a esquerda ou direita.
5. Sinais de controle: recebe sinais de controle da ALU Control, que a instrui sobre qual operação realizar e como interpretar os operandos de entrada.

### Operações suportadas:
- ADD
- SUB 
- OR 
- AND 
- XOR 
- SET LESS THAN 
- SET LESS THAN UNSIGNED 
- SHIFT LEFT LOGICAL
- SHIFT RIGHT LOGICAL
- SHIFT RIGHT ARITHMETIC
- ADD WORD
- SUB WORD
- SHIFT LEFT LOGICAL WORD
- SHIFT RIGHT LOGICAL WORD
- SHIFT RIGHT ARITHMETIC WORD

#### Abaixo é possível visualizar o circuito sintetizado da ALU:
![ALU](alu.jpg)

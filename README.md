#### Caso esteja acessando através de um .zip, acesse o link https://github.com/RISCO-5bola/risc-v para uma melhor experiência no repositório :)

# RISC-V 64 bits
 Esta é a implementação em Verilog do RISC-V 64 bits do Grupo 3 de Sistemas digitais II.

## Contextualização
 Na disciplina de SDII, o nosso grupo (03) aceitou o desafio de fazer entregas paralelas em relação aos demais grupos da sala. Nas nossas entregas, iremos avançar na codificação do RISC-V de 64 bits em verilog com as extensões de ponto flutuante e implementação em FPGA.

 Essa entrega específica contém o circuito capaz de implementar a soma, a subtração, tanto com valores nos registradores, quanto com immediates (constantes) fornecidas. Além disso, as instruções de mundança de fluxo das instruções (BRANCH) e de salto (J) foram implementadas. A seguir, mostramos melhor quais instruções especificas já estão funcionais no circuito. 

 - Situação do processador: estamos ajustando o fluxo de dados do processador multiciclo RV64I (que será atualizado para RV64F).
 
## Como rodar
 Comando para compilar:
 ``iverilog risc-v.v risc-v_tb.v``
 
 Comando para rodar:
 ``./a.out``

 Comando para visualizar no GTKWave:
 ``gtkwave wave.vcd``
 
 Sistema operacional usado: Linux Mint (Debian/Ubuntu).

## Instruções implementadas
As seguintes instruções foram implementadas:

### Operações básicas aritméticas com registradores: (tipo R):
| Instrução | Função        | Descrição                                                               |
|-----------|---------------|-------------------------------------------------------------------------|
| add       | add           | soma entre valores de dois registradores do banco de registradores      |
| sub       | sub           | subtração entre valores de dois registradores do banco de registradores |


### Operações com immediate: (Tipo I):
| Instrução | Função        | Descrição                                                                   |
|-----------|---------------|-----------------------------------------------------------------------------|
| addi      | add immediate | soma um valor de um registrador com uma dada constante                      |
| subi      | sub immediate | essa instrução é apenas um addi com a constante (immediate) negativa        |
| jalr      | jump link reg | salva em registrador o PC +4 e manda para o PC o valor de um reg + immediate|

### Operações do tipo B (de salto nas instruções):
| Instrução | Função        | Descrição                                                                     |
|-----------|---------------|-------------------------------------------------------------------------------|
| BEQ | branch if equal | compara dois valores e pula para uma instrução específica se os valores forem iguais |
| BNE | branch if not equal | compara dois valores e pula para uma instrução específica se forem diferentes |
| BLT | branch if less than | compara dois valores e pula para uma instrução específica se rs1 for menor que rs2 |
| BGE | branch if greater than or equal to | compara dois valores e soma um valor ao PC, pulando para uma instrução específica se rs1 for maior ou igual do que rs2 |
| BLTU | branch if less than (unsigned) | compara dois valores unsigned e pula para uma instrução específica se rs1 for menor que rs2 |
| BGEU | branch if greater than or equal to(unsigned) | compara dois unsigned valores e pula para uma instrução específica se rs1 for maior que rs2 |

### Operações do tipo J (salto de instruções não condicional):
| Instrução | Função        | Descrição                                                                   |
|-----------|---------------|-----------------------------------------------------------------------------|
|  JAL      | Jump and Link | Salva o valor do PC somado de 4 em um registrador, então salta para uma dada posição da memória - ou seja, incrementa um valor no valor atual do PC e salva no PC.

### Operações do tipo U ():
| Instrução | Função            | Descrição                                                                   |
|-----------|-------------------|-----------------------------------------------------------------------------|
|   AUIPC   |add upper imm to PC|acresce o valor do PC de um immediate e soma em um dado registrador          |

## Datapath
Abaixo está o datapath dessa entrega (baseado no livro Computer Organization and Design The Hardware Software Interface [RISC-V Edition] de David A. Patterson e John L. Hennessy):
![datapath](https://raw.githubusercontent.com/RISCO-5bola/risc-v/main/datapath_patterson.png)

 ### Unidade de controle
 Dentre todos os módulos criados até o momento, o mais complexo é a Unidade de Controle multiciclo. A implementação foi feita usando como referência a máquina de estados do livro de Patterson e Henessy.

 ![controlunit](https://raw.githubusercontent.com/RISCO-5bola/risc-v/main/ControlUnit.jpeg)
 
 Optamos por fazer as funções de próximo estado e de saídas de forma estrutural e em módulos separados, buscando evitar bugs de atraso de clock usando o bloco always. Por outro lado, deixamos tudo comentado para que, cada vez que adicionamos um estado novo, possamos alterar tudo sem muitos problemas.
 
## Ondas analisadas
 Nos comentários do arquivo index_tb.v, são mostradas os valores esperados para os registradores após cada uma das instruções. Sendo assim, a descrição da testagem das instruções implementadas está presente no arquivo citado (index_tb.v)

 As instruções em binário estão no arquivo ./Memory/Memory.v e seguem o Instruction Set oficial do RISC-V. Como os dados e as instruções estão na mesma memória, considerou-se que os dados iniciam na posição 0 da memória e os dados na posição 1023.
 
 Atenção: cada um dos módulos foi testado individualmente e verificado no GTKWave para que tivesse o comportamento esperando. Portanto, os outros testes estão presentes nos arquivos *_tb.v presentes espalhados nas respectivas pastas, sempre próximos do módulo testado.
 
 ## GTKWave
 Deixamos um arquivo chamado waveDoGrupo.vcd com as ondas geradas pelo grupo no último teste realizado e condizente com as instruções implementadas. 
 
 Para rodar, use o comando:
 ``gtkwave waveDoGrupo.vcd``
#### Caso esteja acessando através de um .zip, acesse o link https://github.com/RISCO-5bola/risc-v para uma melhor experiência no repositório :)

# RISC-V 64 bits
 Esta é a implementação em Verilog do RISC-V 64 bits do Grupo 3 de Sistemas digitais II.

## Contextualização
 Na disciplina de SDII, o nosso grupo (03) aceitou o desafio de fazer entregas paralelas em relação aos demais grupos da sala. Nas nossas entregas, iremos avançar na codificação do RISC-V de 64 bits em verilog com as extensões de ponto flutuante e implementação em FPGA.

 Essa entrega específica contém o circuito capaz de implementar a soma, a subtração, tanto com valores nos registradores, quanto com immediates (constantes) fornecidas. Além disso, as instruções de mundança de fluxo das instruções (BRANCH) e de salto (J) foram implementadas. A seguir, mostramos melhor quais instruções especificas já estão funcionais no circuito. 

 - Situação do processador: estamos ajustando o fluxo de dados do processador multiciclo RV64I (que será atualizado para RV64F).
 
## Compilação
 O comando para rodar é:
 ``iverilog risc-v.v risc-v_tb.v``
 
 Sistema operacional usado: Linux Mint (Debian/Ubuntu).

## Instruções implementadas
As seguintes instruções foram implementadas:

### Operações básicas aritméticas: (tipo R e I):
| Instrução | Função        | Descrição                                                               |
|-----------|---------------|-------------------------------------------------------------------------|
| add       | add           | soma entre valores de dois registradores do banco de registradores      |
| sub       | sub           | subtração entre valores de dois registradores do banco de registradores |
| addi      | add immediate | soma um valor de um registrador com uma dada constante                  |
| subi      | sub immediate | essa instrução é apenas um addi com a constante (immediate) negativa    |

### Operações do tipo B (de salto nas instruções):
| Instrução | Função        | Descrição                                                               |
|-----------|---------------|-------------------------------------------------------------------------|
| BEQ | branch if equal | compara dois valores e pula para uma instrução específica se os valores forem iguais |
| BNE | branch if not equal | compara dois valores e pula para uma instrução específica se forem diferentes |
| BLT | branch if less than | compara dois valores e pula para uma instrução específica se rs1 for menor que rs2 |
| BGE | branch if greater than or equal to | compara dois valores e soma um valor ao PC, pulando para uma instrução específica se rs1 for maior ou igual do que rs2 |
| BLTU | branch if less than (unsigned) | compara dois valores unsigned e pula para uma instrução específica se rs1 for menor que rs2 |
| BGEU | branch if greater than or equal to(unsigned) | compara dois unsigned valores e pula para uma instrução específica se rs1 for maior que rs2 |

## Datapath
Abaixo está o datapath dessa entrega:
![datapath](https://raw.githubusercontent.com/RISCO-5bola/risc-v/main/datapath_patterson.png)

Atenção: o papel da Unidade de controle é feito pela testbench.

## Ondas analisadas
 Nos comentários do arquivo index_tb.v, são mostradas os valores esperados para os registradores após cada uma das instruções. Sendo assim, a descrição da testagem das instruções implementadas está presente no arquivo citado (index_tb.v)

 As instruções em binário estão no arquivo ./Memory/InstructionMemory.v e seguem o Instruction Set oficial do RISC-V.
 
 Atenção: cada um dos módulos foi testado individualmente e verificado no GTKWave para que tivesse o comportamento esperando. Portanto, os outros testes estão presentes nos arquivos *_tb.v presentes espalhados nas respectivas pastas, sempre próximos do módulo testado.
 
 Abaixo, uma imagem da análise de sinais:
 ![wave](https://raw.githubusercontent.com/RISCO-5bola/datapath-temporario-riscv/main/wave.png?token=GHSAT0AAAAAACAU3YLC2AR233ZUTEXGXT6GZC3ZQXQ)
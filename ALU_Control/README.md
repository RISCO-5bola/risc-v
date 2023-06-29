# ALU Control

A ALU Control é o circuito responsável pelo controle das operações realizadas pela ALU. Consiste em um bloco combinatório que possui uma entrada de 4 bits e determina qual operação deve ser efetuada, de acordo com a instrução.

### Operacoes:
- 0000: ADD
- 0001: AND
- 0010: OR
- 0011: SUB
- 0100: XOR
- 0101: SET LESS THAN
- 0110: SET LESS THAN IMMEDIATE UNSIGNED
- 0111: SHIFT LEFT LOGICAL
- 1000: SHIFT RIGHT LOGICAL 
- 1001: SHIFT RIGHT ARITHMETICAL
- 1010: ADD WORD
- 1011: SUB WORD
- 1100: SHIFT LEFT LOGICAL WORD
- 1101: SHIFT RIGHT LOGICAL WORD
- 1110: SHIFT RIGHT ARITHMETIC WORD


O circuito sintetizado da ALU Control está disponível abaixo:

![ALUControl](alu_control.jpg)

# Memory
O módulo de memória, é responsável por lidar com operações relacionadas à memória e gerenciar a leitura e escrita de instrução e dados que são gerados pelo processador durante seu funcionamento.

### Data Memory
No nosso processador usamos apenas uma memory, e certas posições serão dedicadas a fazer o papel de Data Memory (Memory[0] até a Memory[1023]) e as demais, para a Instruction Memory. A Data Memory armazena valores de 64 bits, que são escritos na memória com a instrução store.

Exemplo: 
``` verilog
Memory[0] = 8'd0; 
Memory[1] = 8'd0; 
Memory[2] = 8'd0; 
Memory[3] = 8'd0; 
Memory[4] = 8'd0; 
Memory[5] = 8'd0; 
Memory[6] = 8'd0; 
Memory[7] = 8'd8;
```
Armazena a palavra

"00000000_00000000_00000000_00000000_00000000_00000000_00000000_00001000"

### Instruction Memory
A seção da Instruction Memory contém as instruções de 32 bits compatíveis com a arquitetura do RISC-V. A Instruction memory começa na posição definida de Memory[1024]. A parte do controle da memória é setado para começar no 1024 para as instruções. Então não há erros em termos da passagem das instruções e da contagem do program counter. Isto é, a ordem do program counter será respeitada devidamente. Assim, a instrução representada na memoria de Memory[1026] a Memory[1023] é reconhecida como a primeira instrução de fato.

Exemplo: ld x1, 0(x0)
```verilog 
Memory[1026] = 8'b1_0000011; 
Memory[1025] = 8'b0_011_0000; 
Memory[1024] = 8'b0000_0000; 
Memory[1023] = 8'b00000000;
```
Representa uma primeira instrução, aqui no caso, se trata de um load, que salva o primeiro valor salvo na Data Memory lá no primeiro registrador do banco de registradores.
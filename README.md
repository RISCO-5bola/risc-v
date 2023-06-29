#### Caso esteja acessando através de um .zip, acesse o link https://github.com/RISCO-5bola/risc-v para uma melhor experiência no repositório :)

# RISC-V 64 bits - Com extensão I e com operações básicas de floating point :zap:
 Esta é a implementação em Verilog do RISC-V 64 bits do Grupo 3 de Sistemas digitais II.
 O projeto envolve o processador RISC-V de 64 bits que realiza todas as operações do tipo I, além de operações básicas de soma e multiplicação para ponto flutuante. Funcionando com multiplos ciclos e um controle voltado especificamente para a memória.

## Contextualização
Na disciplina de SDII, o nosso grupo (03) aceitou o desafio de fazer entregas paralelas em relação aos demais grupos da sala. Nas nossas entregas, avançamos na codificação do RISC-V de 64 bits em verilog com ponto flutuante.
 
-> o diferencial do nosso projeto é o funcionamento do processador em multiciclo, implementando todas as instruções do 32I e 64I, incluindo o funcionamento de operações com ponto flutuante integrado.

É interessante destacar que a maioria dos módulos criados para o processador são implementados de forma estutural. Porque apesar de ser mais minucioso e relativamente mais trabalhoso, o resultado é claro e confiável.

Todas as instruções do RISC-VI estão implementadas, como pode ser verificado na lista de instruções implementadas abaixo.


## Como rodar o seu código no nosso processador

1 - Vá até o arquivo Memory/Memory.v -> Esse arquivo representa a data memory, e os valores a serem observados na instruction memory primeiro devem ser adicionados aqui.

2 - Você vai codar as instruções na memória, seguindo o padrão abaixo:
*Detalhes:

 - os valores devem ser salvos a cada byte na memory, isso fica mais claro nos exemplos:

 - usamos apenas uma memory, e certas posições serão dedicadas a fazer o papel de Data Memory e as demais, para a Instruction Memory, como fica claro adiante.

a - Na seção "data memory" você adicionará os valores de 64 bits, que você deseja deixar na data memory do processador. Para esses valores serem armazenados no registrador, você deverá usar o store, não esqueça desse detalhe.

*Importante: A Data Memory representa a parcela que vai da Memory[0] até a Memory[1023].

Ex:
     Memory[0] = 8'd0;
     Memory[1] = 8'd0;
     Memory[2] = 8'd0;
     Memory[3] = 8'd0;
     Memory[4] = 8'd0;
     Memory[5] = 8'd0;
     Memory[6] = 8'd0;
     Memory[7] = 8'd8;

Armazena a palavra

"00000000_00000000_00000000_00000000_00000000_00000000_00000000_00001000"

Na DM.

b - Na seção "instruction memory" você adicionará os valores de 32 bits que você deseja colocar na memória de instruções.

*Importante: Note que a Instruction memory começa na posição definida de Memory[1024].

- A parte do controle da memória é setado para começar no 1024 para as instruções. Então não há erros em termos da passagem das instruções e da contagem do program counter. Isto é, a ordem do program counter será respeitada devidamente.

- Assim, a instrução representada na memoria de Memory[1026] a Memory[1023] reconhecida como a primeira instrução de fato.

Ex:
     // ld x1, 0(x0)
     Memory[1026] = 8'b1_0000011;
     Memory[1025] = 8'b0_011_0000;
     Memory[1024] = 8'b0000_0000;
     Memory[1023] = 8'b00000000;

Representa uma primeira instrução, aqui no caso, se trata de um load, que salva o primeiro valor salvo na dm lá no primeiro registrador do banco de registradores. 

c - Setados os valores desejados na data memory e na instruction memory devidamente, agora basta compilar e observar os resultados, segue abaixo:

## Compilando e rodando
 Comando para compilar:
 ``iverilog -c risc-v_comp.txt``
 
 Comando para rodar:
 ``./a.out`` para usuários do Linux 
 ``vvp a.out`` para usuários do Windows

 Comando para visualizar no GTKWave:
 ``gtkwave wave.vcd``
 
## Instruções implementadas
As seguintes instruções foram implementadas:

- [X] LUI 
- [X] AUIPC 
- [X] JAL 
- [X] JALR 
- [X] BEQ 
- [X] BNE 
- [X] BLT 
- [X] BGE 
- [X] BLTU 
- [X] BGEU 
- [X] LB 
- [X] LH 
- [X] LW 
- [X] LBU 
- [X] LHU 
- [X] SB 
- [X] SH 
- [X] SW 
- [X] ADDI 
- [X] SLTI 
- [X] SLTIU 
- [X] XORI 
- [X] ORI 
- [X] ANDI 
- [X] SLLI 
- [X] SRLI 
- [X] SRAI
- [X] ADD 
- [X] SUB 
- [X] SLL 
- [X] SLT 
- [X] SLTU 
- [X] XOR 
- [X] SRL 
- [X] SRA 
- [X] OR 
- [X] AND 
- [ ] FENCE
- [ ] ECALL
- [ ] EBREAK
- [X] LWU 
- [X] LD 
- [X] SD 
- [X] ADDIW 
- [X] SLLIW 
- [x] SRLIW 
- [X] SRAIW 
- [X] ADDW 
- [x] SUBW 
- [X] SLLW 
- [X] SRLW 
- [X] SRAW 

## Descrição das instruções
### Operações básicas aritméticas com registradores: (tipo R):
| Instrução | Função        | Descrição                                                               |
|-----------|---------------|-------------------------------------------------------------------------|
| add | add | soma entre valores de dois registradores do banco de registradores      |
| sub | sub | subtração entre valores de dois registradores do banco de registradores |
| sll | shift left logical | desloca bits para a esquerda por uma quantidade constante especificada por um registrador |
| slt | set less than | compara dois números e se o primeiro for menor que o segundo, define o registrador de destino como 1 |
| sltu | set less than unsigned | faz o mesmo que o slt, mas com inteiros positivos |
| xor | exclusive or | devolve 1 se os os operandos forem diferentes e 0 se forem os mesmo |
| srl | shift right logical | desloca os bits de um operando para a direita por uma quantidade especificado por um registrador |
| sra | shift right arithmetic immediate | desloca um aritimético para a direita e os bits do sinal são copiados nos bits superiores desocupados |
| or | or | devolve 1 se pelo menos um dos operandos for 1 |
| and | and | devolve 1 se todos os operandos forem 1 |
| addw | add word | adiciona dois operandos de 32 bits e armazena em um registrador de 64 bits |
| subw | sub word | subtrai dois operando de 32 bits e armazena em um registrador de 64 bits |
| sllw | shift left logical word | desloca uma palavra de 32 bits para a esquerda e completa os bits com zeros |
| srlw | shift right logical word | desloca uma palavra de 32 bits para a direita e completa os bits com zeros |
| sraw | shift right arithmetic word | desloca os bits de um operando de 32 bits para a direita e copia os bits do sinal e armazena em um registrador de 64 bits |

### Operações com immediate: (Tipo I):
| Instrução | Função        | Descrição                                                                   |
|-----------|---------------|-----------------------------------------------------------------------------|
| addi | add immediate | soma um valor de um registrador com uma dada constante                      |
| subi | sub immediate | essa instrução é apenas um addi com a constante (immediate) negativa        |
| jalr | jump link reg | salva em registrador o PC +4 e manda para o PC o valor de um reg + immediate|
| lb | load btye | carrega uma palavra de 8 bits da memória para um registrador e extende o sinal |
| lh | load half | carrega uma palavra de 16 bits da memória para um registrador e extende o sinal |
| lw | load word | carrega uma palavra de 32 bits da memória para um registrador e extende o sinal |
| lbu | load byte unsinged | carrega uma palavra de 8 bits da memória para um registrador sem sinal |
| lhu | load half unsigned | carrega uma palavra de 16 bits da memória para um registrador sem sinal |
| slti | set less than immediate | compara um operando com um immediato e se o operando for menor, define o registrador destino como 1 |
| sltiu | set less than immediate unsinged | funciona como o slti, mas sem sinal |
| xori | xor immediate | realiza uma operação de xor com um operando e um imediato |
| ori | or imediate | realiza uma operação de or com um operando e um imediato |
| andi | and immediate | realiza uma operação de and com um operando e um imediato |
| slli | shift left logical immediate | desloca os bits de um operando para a esquerda por uma quantidade especificada por um immediate |
| srli | shift right logical immediate | desloca os bits de um operando para a direita por uma quantidade especificada por um immediate |
| srai | shift right arithmetic immediate | desloca o bits de um operando para a direita por uma quantidade especificada por um immediate e copia os bits do sinal para os bits desocupados |
| lwu | load word unsigned | carrega uma palavra de 32 bits da memória para um registrador como se fosse sem sinal |
| ld | load double | carrega uma palavara de 64 bits da memória para um registrador |
| addiw | add immediate word | adiciona um valor de imediato a um registrador |
| slliw | shift left logical immediate word | desloca os bits para a esquerda de um operando de 32 bits |
| srliw | shift right lofical immediate word | desloca os bits para a direita de um operando de 32 bits |
| sraiw | shift right arithmetic immediate word | desloca os bits para a direita de um operando de 32 bits com sinal e armazena em um registrador de 64 bits |

### Operações do tipo S (armazenamento de dados):
| Instrução | Função        | Descrição                                                                   |
|-----------|---------------|-----------------------------------------------------------------------------|
| sb | store byte | armazena uma palavra de 8 bits de um registrador para a memória |
| sh | store half | armazena uma palavra de 16 bits de um registrador para a memória |
| sw | store word | armazena uma palavra de 32 bits de um registrador para a memória |
| sd | store double | armazena uma palavra de 64 bits de um registrador para a memória |

### Operações do tipo B (de salto nas instruções):
| Instrução | Função        | Descrição                                                                     |
|-----------|---------------|-------------------------------------------------------------------------------|
| beq | branch if equal | compara dois valores e pula para uma instrução específica se os valores forem iguais |
| bne | branch if not equal | compara dois valores e pula para uma instrução específica se forem diferentes |
| blt | branch if less than | compara dois valores e pula para uma instrução específica se rs1 for menor que rs2 |
| BGE | branch if greater than or equal to | compara dois valores e soma um valor ao PC, pulando para uma instrução específica se rs1 for maior ou igual do que rs2 |
| bltu | branch if less than (unsigned) | compara dois valores unsigned e pula para uma instrução específica se rs1 for menor que rs2 |
| bgeu | branch if greater than or equal to(unsigned) | compara dois unsigned valores e pula para uma instrução específica se rs1 for maior que rs2 |

### Operações do tipo J (salto de instruções não condicional):
| Instrução | Função        | Descrição                                                                   |
|-----------|---------------|-----------------------------------------------------------------------------|
|  jal      | Jump and Link | Salva o valor do PC somado de 4 em um registrador, então salta para uma dada posição da memória - ou seja, incrementa um valor no valor atual do PC e salva no PC.

### Operações do tipo U ():
| Instrução | Função            | Descrição                                                                   |
|-----------|-------------------|-----------------------------------------------------------------------------|
|   auipc   |add upper imm to PC|acresce o valor do PC de um immediate e soma em um dado registrador          |
| lui | load upper immediate | carrega um valor imediate de 20 bits no 20 bits superiores de um registrador e preenche os 12 bits inferiores com zero |

### Operações com Ponto Flutuante:
| Instrução | Função            | Descrição                                                                  |
|-----------|-------------------|----------------------------------------------------------------------------|
|   fadd    | floating add      | Soma dois valores de ponto flutuante e salva em um registrador             |
|   fmul    | floating mult     | Multiplica dois valores de ponto flutuante e salva em um registrador       |

## Datapath
Abaixo está o datapath dessa entrega (baseado no livro Computer Organization and Design The Hardware Software Interface [RISC-V Edition] de David A. Patterson e John L. Hennessy):
![datapath](https://raw.githubusercontent.com/RISCO-5bola/risc-v/main/datapath_patterson.png)

 ### Unidade de controle
 Dentre todos os módulos criados até o momento, o mais complexo é a Unidade de Controle multiciclo. A implementação foi feita usando como referência a máquina de estados do livro de Patterson e Henessy.
 ![controlunit](https://raw.githubusercontent.com/RISCO-5bola/risc-v/main/ControlUnit.jpeg)
 
 Optamos por fazer as funções de próximo estado e de saídas de forma estrutural e em módulos separados, buscando evitar bugs de atraso de clock usando o bloco always. Por outro lado, deixamos tudo comentado para que, cada vez que adicionamos um estado novo, possamos alterar tudo sem muitos problemas.

 Abaixo, está a representação da máquina de estados da Unidade de Controle multiciclo.
 
 Obs: atualmente essa maquina de estado representada pela imagem está desatualizada, pois alguns estados a mais foram adicionados.
 ![estados](https://raw.githubusercontent.com/RISCO-5bola/risc-v/main/estados_uc.png)
 
## Ponto Flutuante F ()
Foi feito uma unidade apenas para operações com ponto flutuante, esta funciona em conjunto com o processador Risc-V por meio dos sinais de controle da Unidade de Controle. Existe uma complexidade adicional quando se trata de ponto flutuante, as operações são todas em multiciclo e a necessidade de comunicação com flags é muito frequente e importante. 

## Ondas analisadas
 As instruções em binário estão no arquivo ./Memory/Memory.v e seguem o Instruction Set oficial do RISC-V. Como os dados e as instruções estão na mesma memória, considerou-se que os dados iniciam na posição 0 da memória e os dados na posição 1023.
 
 Atenção: cada um dos módulos foi testado individualmente e verificado no GTKWave para que tivesse o comportamento esperando. Portanto, os outros testes estão presentes nos arquivos *_tb.v presentes espalhados nas respectivas pastas, sempre próximos do módulo testado, para compilar e rodar alguma testbench, basta usar o comando:
 ``iverilog -c module_name.txt``
 
 ## GTKWave
 Deixamos um arquivo chamado waveDoGrupo.vcd com as ondas geradas pelo grupo no último teste realizado e condizente com as instruções implementadas. 
 
 Para rodar, use o comando:
 ``gtkwave waveDoGrupo.vcd``

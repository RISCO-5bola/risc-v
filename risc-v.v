// iverilog risc-v.v -I ./Registers/ -I ./ImmediateGenerator/ -I ./ALU/ -I ./ALU/operations/

`include "./Memory/Memory.v"
`include "./Registers/PC.v"
`include "./ControlUnit.v"
`include "./Registers/Registers.v"
`include "./Registers/reg_parametrizado.v"
`include "./ImmediateGenerator/immediateG.v"
`include "./ALU_Control/ALU_Control.v"
`include "./ALU/ALU.v"
`include "./mux/mux_2x1_64bit.v"
`include "./mux/mux_4x1_64bit.v"
`include "./mux/mux_2x1_64bit_S2.v"
`include "./mux/mux_6x1_1b.v"
`include "./Registers/inst_reg.v"
`include "load_choose.v"

/* Este modulo e o risc-v em si, como mostrado no diagrama do readme inicial */

module riscv (
    input reset,
    input clk
);

    initial begin
        $dumpfile("wave.vcd");

        $dumpvars(0, riscv);

    end
    /* 
        Wires especificados. Para localizar exatamente
        as entradas e as saidas, verificar o arquivo
        datapath.png
    */

    /* outputs do control */
    wire PCWrite, PCWriteCond, IorD, IRWrite;
    wire MemtoReg, PCSource1, PCSource0, RegWrite, MemRead;
    wire MemWrite, Branch, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0;
    wire ALUSrcA, RegDst;

    /* sinais do PC e seu MUX */
    wire [63:0] nextPCPosition, PCout, regALUout;
    wire orParaPC;

    /* saida do PC */
    wire [63:0] instructionAddress;

    /* saida da Memory */
    wire [63:0] dataReadFromMemory;

    /* saida do instruction register */
    wire [31:0] instrRegOut;

    /* saida da memory data register */
    wire [63:0] memDataReg;

    /* saida do mux que vai para o registers */
    wire [63:0] dataToWrite;
    /* tratamento dos dados a serem escritos nos registradores */
    wire [63:0] dataChoosenToBeWrittenMux;
    /* conteudo do register lido 2 */
    wire [63:0] dataReadRegister2;

    /* wires entre o registers e a ALU */
    wire [63:0] readData1paraRegA, regAparaMux1, mux1paraALU;
    wire [63:0] readData2paraRegB, regBparaMux2, mux2paraALU;

    /* saida da ALU */
    wire [63:0] ALUResult;
    wire selectedFlag;

    /* saida do immediate generator */
    wire [63:0] immGenParaMux2;

    /* operacao gerada pela ALU Control */
    wire [3:0] ALUOp;

    /* Estado atual */
    wire [3:0] currentState;
    
    /* resultado do and do branch */
    wire andBranch;

    /* flags enviadas pela ALU */
    wire [5:0] flags;
    mux6x1_1b mux6x1_1b (.BEQ(flags[5]), .BNE(flags[4]), .BLT(flags[3]),
                         .BGE(flags[2]), .BLTU(flags[1]), .BGEU(flags[0]),
                         .funct3(instrRegOut[14:12]), .selectedFlag(selectedFlag));
    
    and (andBranch, PCWriteCond, selectedFlag);
    or (orParaPC, andBranch, PCWrite);
    
    PC programCounter (.clk(clk), .load(orParaPC), .in_data(nextPCPosition), .out_data(PCout), .reset(reset));
    mux_2x1_64bit muxPC (.A(PCout), .B(regALUout), .S(IorD), .X(instructionAddress));

    Memory mem (.mem_read(MemRead), .mem_write(MemWrite), .endereco(instructionAddress), 
                .write_data(regBparaMux2), .read_data(dataReadFromMemory), .clk(clk));
    
    inst_reg instrReg (.clk(clk), .load(IRWrite), .in_data(dataReadFromMemory[63:32]),
                                .out_data(instrRegOut));

    reg_parametrizado memDataRegister (.clk(clk), .load(1'b1), .in_data(dataReadFromMemory),
                                        .out_data(memDataReg));

    mux_2x1_64bit muxRegWriteData (.A(regALUout), .B(memDataReg), .S(MemtoReg), .X(dataToWrite));

    ControlUnit control (.op({
        instrRegOut[6],
        instrRegOut[5],
        instrRegOut[4],
        instrRegOut[3],
        instrRegOut[2],
        instrRegOut[1],
        instrRegOut[0]}), .reset(reset),
        .clk(clk), .PCWrite(PCWrite), .PCWriteCond(PCWriteCond), .IorD(IorD),
        .MemRead(MemRead), .MemWrite(MemWrite), .IRWrite(IRWrite), .MemtoReg(MemtoReg),
        .PCSource1(PCSource1), .PCSource0(PCSource0), .ALUOp1(ALUOp1), .ALUOp0(ALUOp0),
        .ALUSrcB1(ALUSrcB1), .ALUSrcB0(ALUSrcB0), .ALUSrcA(ALUSrcA), .RegWrite(RegWrite),
        .RegDst(RegDst), .currentState(currentState));

    ALU_Control aluctrl (.ALUOp1(ALUOp1), .ALUOp0(ALUOp0), 
        .funct({
        instrRegOut[30],
        instrRegOut[25],
        instrRegOut[14],
        instrRegOut[13],
        instrRegOut[12]}),
        .opcode(instrRegOut[6:0]),
        .operation(ALUOp), .currentState(currentState));

    immediateG immgen (.instruction(instrRegOut), .immediate(immGenParaMux2));
    
    load_choose load_choose (.dataReadFromMemory(dataToWrite), .opcode(instrRegOut[6:0]), .funct3(instrRegOut[14:12]), .writeDataReg(dataChoosenToBeWrittenMux));
    Registers regs (
        .readRegister1({
            instrRegOut[19],
            instrRegOut[18],
            instrRegOut[17],
            instrRegOut[16],
            instrRegOut[15]}),
        .readRegister2({
            instrRegOut[24],
            instrRegOut[23],
            instrRegOut[22],
            instrRegOut[21],
            instrRegOut[20]
        }),
        .writeRegister({
            instrRegOut[11],
            instrRegOut[10],
            instrRegOut[9],
            instrRegOut[8],
            instrRegOut[7]
        }),
        .writeData(dataChoosenToBeWrittenMux),
        .regWrite(RegWrite),
        .clk(clk),
        .readData1(readData1paraRegA), 
        .readData2(readData2paraRegB));

    reg_parametrizado regA (.clk(clk), .load(1'b1), .in_data(readData1paraRegA), .out_data(regAparaMux1));
    mux_2x1_64bit mux1ALU (.A(instructionAddress), .B(regAparaMux1), .S(ALUSrcA), .X(mux1paraALU));

    reg_parametrizado regB (.clk(clk), .load(1'b1), .in_data(readData2paraRegB), .out_data(regBparaMux2));
    mux_4x1_64bit mux2ALU (.A(regBparaMux2), .B(64'd4), .C(immGenParaMux2), .D(64'd0), .S({ALUSrcB1, ALUSrcB0}), .X(mux2paraALU));

    ALU alu (.A(mux1paraALU), .B(mux2paraALU), .ALUOp(ALUOp), .result(ALUResult), .equal(flags[5]), .not_equal(flags[4]), .lesser_than(flags[3]), 
             .greater_or_equal(flags[2]), .unsigned_lesser(flags[1]), .unsigned_greater_equal(flags[0]));
    
    reg_parametrizado ALUout (.clk(clk), .load(1'b1), .in_data(ALUResult), .out_data(regALUout));
    mux_2x1_64bit_S2 mux3ALUout (.A(ALUResult), .B(regALUout), .S({PCSource1, PCSource0}), .X(nextPCPosition));
endmodule
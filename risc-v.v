// iverilog risc-v.v -I ./Registers/ -I ./ImmediateGenerator/ -I ./ALU/ -I ./ALU/operations/

`include "./Memory/Memory.v"
`include "./Registers/PC.v"
`include "./ControlUnit.v"
`include "./Registers/Registers.v"
`include "./Registers/reg_parametrizado.v"
`include "./ImmediateGenerator/immediateG.v"
`include "./ALU_Control/ALU_Control_structural.v"
`include "./ALU/ALU.v"
`include "./mux/mux_2x1_64bit.v"
`include "./mux/mux_3x1_64bit.v"
`include "./Registers/inst_reg.v"

/* Este modulo e o risc-v em si, como mostrado no diagrama do readme inicial */

module riscv (
    input reset,
    input clk
);
    initial begin
        $dumpfile("my_dumpfile.vcd"); 
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

    /* conteudo do register lido 2 */
    wire [63:0] dataReadRegister2;

    /* wires entre o registers e a ALU */
    wire [63:0] readData1paraRegA, regAparaMux1, mux1paraALU;
    wire [63:0] readData2paraRegB, regBparaMux2, mux2paraALU;

    /* saida da ALU */
    wire [63:0] ALUResult;
    wire zero;

    /* saida do immediate generator */
    wire [63:0] immGenParaMux2;

    /* operacao gerada pela ALU Control */
    wire [3:0] ALUOp;
    
    /* resultado do and do branch */
    wire andBranch;

    and (andBranch, PCWriteCond, zero);
    or (orParaPC, andBranch, PCWrite);
    
    PC programCounter (.clk(clk), .load(orParaPC), .in_data(nextPCPosition), .out_data(PCout));
    mux_2x1_64bit muxPC (.A(PCout), .B(regALUout), .S(IorD), .X(instructionAddress));

    Memory mem (.mem_read(MemRead), .mem_write(MemWrite), .endereco(instructionAddress), 
                .write_data(regBparaMux2), .read_data(dataReadFromMemory));
    
    inst_reg instrReg (.clk(clk), .load(IRWrite), .in_data(dataReadFromMemory[31:0]),
                                .out_data(instrRegOut));

    reg_parametrizado memDataRegister (.clk(clk), .load(1'b1), .in_data(dataReadFromMemory),
                                        .out_data(memDataReg));

    mux_2x1_64bit muxReg (.A(regALUout), .B(memDataReg), .S(MemtoReg), .X(dataToWrite));

    ControlUnit control (.op({
        instrRegOut[6],
        instrRegOut[5],
        instrRegOut[4],
        instrRegOut[3],
        instrRegOut[2],
        instrRegOut[1],
        instrRegOut[0]}),
        .clk(clk), .PCWrite(PCWrite), .PCWriteCond(PCWriteCond), .IorD(IorD),
        .MemRead(MemRead), .MemWrite(MemWrite), .IRWrite(IRWrite), .MemtoReg(MemtoReg),
        .PCSource1(PCSource1), .PCSource0(PCSource0), .ALUOp1(ALUOp1), .ALUOp0(ALUOp0),
        .ALUSrcB1(ALUSrcB1), .ALUSrcB0(ALUSrcB0), .ALUSrcA(ALUSrcA), .RegWrite(RegWrite),
        .RegDst(RegDst));

    ALU_Control aluctrl (.ALUOp1(ALUOp1), .ALUOp0(ALUOp0), 
        .funct({
        instrRegOut[30],
        instrRegOut[14],
        instrRegOut[13],
        instrRegOut[12]}), 
        .operation(ALUOp));

    immediateG immgen (.inst(instrRegOut), .imm(immGenParaMux2));
    
    Memory datamem (.clk(clk), .mem_read(MemRead), .mem_write(MemWrite), .endereco(ALUResult), 
                    .write_data(dataReadRegister2), .read_data(dataReadFromMemory));

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
        .writeData(dataToWrite),
        .regWrite(RegWrite),
        .clk(clk),
        .readData1 (readData1paraRegA), 
        .readData2(dataReadRegister2));

    reg_parametrizado regA (.clk(clk), .load(1'b1), .in_data(readData1paraRegA), .out_data(regAparaMux1));
    mux_2x1_64bit mux1ALU (.A(instructionAddress), .B(regAparaMux1), .S(ALUSrcA), .X(mux1paraALU));

    reg_parametrizado regB (.clk(clk), .load(1'b1), .in_data(readData2paraRegB), .out_data(regBparaMux2));
    mux_3x1_64bit mux2ALU (.A(regBparaMux2), .B(64'd4), .C(immGenParaMux2), .S({ALUSrcB0, ALUSrcB1}), .X(mux2paraALU));

    ALU alu (.A(mux1paraALU), .B(mux2paraALU), .ALUOp(ALUOp), .result(ALUResult), .zero(zero));

    reg_parametrizado ALUout (.clk(clk), .load(1'b1), .in_data(ALUResult), .out_data(regALUout));
    mux_2x1_64bit mux3ALUout (.A(ALUResult), .B(regALUout), .S(PCSource0), .X(nextPCPosition));
endmodule
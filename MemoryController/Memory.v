module Memory(input clk,      
              input mem_read,
              input mem_write,
              input [19:0] endereco, //saida da ula
              input [7:0] write_data, //data out b
              output [7:0] read_data // write data
             );
   reg [19:0] endereco_atual;
   reg [7:0] Memory [2047:0];

   /*
    Memoria 64x32
    Neste caso, foi instanciado em bytes, por isso sao 256 posicoes
   */
   initial begin
     /*
      Data Memory
     */
     Memory[0] = 8'd0;
     Memory[1] = 8'd0;
     Memory[2] = 8'd0;
     Memory[3] = 8'd0;
     Memory[4] = 8'd0;
     Memory[5] = 8'd0;
     Memory[6] = 8'd0;
     Memory[7] = 8'd8;
     
     Memory[8] = 8'd0;
     Memory[9] = 8'd0;
     Memory[10] = 8'd0;
     Memory[11] = 8'd0;
     Memory[12] = 8'd0;
     Memory[13] = 8'd0;
     Memory[14] = 8'd0;
     Memory[15] = 8'd6;
     
     Memory[16] = 8'd0;
     Memory[17] = 8'd0;
     Memory[18] = 8'd0;
     Memory[19] = 8'd0;
     Memory[20] = 8'd0;
     Memory[21] = 8'd0;
     Memory[22] = 8'd0;
     Memory[23] = 8'd16;

     Memory[24] = 8'd0;
     Memory[25] = 8'd0;
     Memory[26] = 8'd0;
     Memory[27] = 8'd0;
     Memory[28] = 8'd0;
     Memory[29] = 8'd0;
     Memory[30] = 8'd0;
     Memory[31] = 8'd16;

     /* Para testes de load unsigned */
     Memory[32] = 8'b10000000;
     Memory[33] = 8'b01000000;
     Memory[34] = 8'b00100000;
     Memory[35] = 8'b00010000;
     Memory[36] = 8'b00001000;
     Memory[37] = 8'b00000100;
     Memory[38] = 8'b00000010;
     Memory[39] = 8'b00000001;

     /* Para testes de load signed */
     Memory[40] = 8'b10000000;
     Memory[41] = 8'b11000000;
     Memory[42] = 8'b10100000;
     Memory[43] = 8'b10010000;
     Memory[44] = 8'b10001000;
     Memory[45] = 8'b10000100;
     Memory[46] = 8'b10000010;
     Memory[47] = 8'b10000001;

     /* testes para extensao RV64I */
     Memory[48] = 8'b10000000;
     Memory[49] = 8'b11000000;
     Memory[50] = 8'b10100000;
     Memory[51] = 8'b10010000;
     Memory[52] = 8'b01001000;
     Memory[53] = 8'b10000100;
     Memory[54] = 8'b10000010;
     Memory[55] = 8'b10000001;
    
     /* 
      Instruction Memory
      */
      /* teste load da memoria, reg x1 deve valer 8  */
     // ld x1, 0(x0)
     Memory[1026] = 8'b1_0000011;
     Memory[1025] = 8'b0_011_0000;
     Memory[1024] = 8'b0000_0000;
     Memory[1023] = 8'b00000000;
     
      /* teste load da memoria, reg x2 deve valer 6  */
     // ld x2, 8(x0)
     Memory[1030] = 8'b0_0000011;
     Memory[1029] = 8'b0_011_0001;
     Memory[1028] = 8'b1000_0000;
     Memory[1027] = 8'b00000000;

      /* teste soma entre regs, reg x3 deve valer 14  */
     // add x3, x2, x1
     Memory[1034] = 8'b1_0110011;
     Memory[1033] = 8'b1_000_0001;
     Memory[1032] = 8'b0010_0000;
     Memory[1031] = 8'b0000000_0;

     /* teste subtracao entre regs, reg x4 deve valer 6  */
     // sub x4, x3, x1
     Memory[1038] = 8'b0_0110011;
     Memory[1037] = 8'b1_000_0010;
     Memory[1036] = 8'b0001_0001;
     Memory[1035] = 8'b0100000_0;

     /* teste de storage na memoria, posicao 24 da memoria de dados
        deve valer 14  */
     // sw x3, 24(x0)
     Memory[1042] = 8'b0_0100011;
     Memory[1041] = 8'b0_010_1100;
     Memory[1040] = 8'b0011_0000;
     Memory[1039] = 8'b0000000_0;

     /* recupera o valor do storage anterior no registrador 8,
        que deve valer 14 agora  */
     // ld x8, 24(x0)
     Memory[1046] = 8'b0_0000011;
     Memory[1045] = 8'b0_011_0100;
     Memory[1044] = 8'b1000_0000;
     Memory[1043] = 8'b00000001;

     /* Nos testes do tipo B, faz-se as comparacoes desejadas e saltam 8 posicoes
        na memoria */
     // x imm[12|10:5] x4 x2 000 imm[4:1|11] 1100011 BEQ imm = 8
     Memory[1050] = 8'b0_1100011; 
     Memory[1049] = 8'b0_000_0100;
     Memory[1048] = 8'b0100_0001;
     Memory[1047] = 8'b0000000_0;

     // x imm[12|10:5] x1 x0 001 imm[4:1|11] 1100011 BNE imm = 8
     Memory[1058] = 8'b0_1100011;
     Memory[1057] = 8'b0_001_0100;
     Memory[1056] = 8'b0001_0000;
     Memory[1055] = 8'b0000000_0; 
      // imm[12|10:5] x1 x0 100 imm[4:1|11] 1100011 BLT imm = 8
     Memory[1066] = 8'b0_1100011;
     Memory[1065] = 8'b0_100_0100;
     Memory[1064] = 8'b0001_0000;
     Memory[1063] = 8'b0000000_0; 
      // x imm[12|10:5] x0 x1 101 imm[4:1|11] 1100011 BGE imm = 8
     Memory[1074] = 8'b0_1100011;
     Memory[1073] = 8'b1_101_0100;
     Memory[1072] = 8'b0000_0000;
     Memory[1071] = 8'b0000000_0;
      // x imm[12|10:5] x1 x0 110 imm[4:1|11] 1100011 BLTU imm = 8
     Memory[1082] = 8'b0_1100011; 
     Memory[1081] = 8'b0_110_0100;
     Memory[1080] = 8'b0001_0000;
     Memory[1079] = 8'b0000000_0;
      // x imm[12|10:5] x0 x1 111 imm[4:1|11] 1100011 BGEU imm = 8
     Memory[1090] = 8'b0_1100011;  
     Memory[1089] = 8'b1_111_0100; 
     Memory[1088] = 8'b0000_0000;
     Memory[1087] = 8'b0000000_0;
     
     /* Agora, os testes para o tipo J */
     /* com esta instrucao JAL, coloca o PC de 1095 para 1095 + 16
        registrador x5 deve valer 1099 */
     // imm[20|10:1|11|19:12] rd 1101111 JAL rd = x5 imm = 16
     Memory[1098] = 8'b1_1101111;  
     Memory[1097] = 8'b0000_0010; 
     Memory[1096] = 8'b000_0_0000;
     Memory[1095] = 8'b0_0000001;

     /* com esta instrucao do tipo JALR, coloca o PC para x5 (que vale 1099)
        + o immediate (0), ou seja, retorna para 1099
        registrador x5 deve valer 1115 */
     // imm[11:0] rs1 000 rd 1100111 JALR rs1 = x5 rd = x5
     Memory[1114] = 8'b1_1100111;  
     Memory[1113] = 8'b1_000_0010; 
     Memory[1112] = 8'b0000_0010;
     Memory[1111] = 8'b00000000;
    
     /* Testa soma com immediate (negativo para garantir que subi tambem funciona) */
     // imm[11:0] rs1 000 rd 0010011 imm = -2 rd = x6 rs = x3 "SUBI"
     /* reg x6 deve valer x3 - 2 = 12 */
     Memory[1102] = 8'b0_0010011;  
     Memory[1101] = 8'b1_000_0011; 
     Memory[1100] = 8'b1110_0001;
     Memory[1099] = 8'b11111111;

     // imm[31:12] rd 0010111 AUIPC imm -8 rd = x5
     /* este este foi so para verificar se o AUIPC estava funcionando
       com complemento de dois também, então o registrador x6 deve valer -31665
       NAO FAZ SENTIDO EM TERMOS DE MEMORIA, E SO UM TESTE */
      Memory[1106] = 8'b0_0010111;  
      Memory[1105] = 8'b1000_0011; 
      Memory[1104] = 8'b11111111;
      Memory[1103] = 8'b11111111;
      
     /* Da um jump para sair da instrucao 11111, que ja foi setada anteriormente */
      // imm[20|10:1|11|19:12] rd 1101111 JAL rd = x5 imm = 16
      Memory[1110] = 8'b1_1101111;  
      Memory[1109] = 8'b0000_0010; 
      Memory[1108] = 8'b100_0_0000;
      Memory[1107] = 8'b0_0000000;

     /* 
      Testes deluxe: uma nova sessão para instrucoes que nao sao as basicas
      implementadas em sala
      */
      /* 0000000 rs2 rs1 111 rd 0110011 AND rs2 = x5 rs1 = x6 rd = x7 
         realiza and entre x5 e x6, guardando 1095 em x7*/
      Memory[1118] = 8'b1_0110011;  
      Memory[1117] = 8'b1_111_0011; 
      Memory[1116] = 8'b0110_0010;
      Memory[1115] = 8'b0000000_0;

      /* imm[11:0] rs1 111 rd 0010011 ANDI rs1 = x3 rd = x7 
         realiza andi entre x3 e 3, guardando 2 em x7*/
      Memory[1122] = 8'b1_0010011;  
      Memory[1121] = 8'b1_111_0011; 
      Memory[1120] = 8'b0011_0001;
      Memory[1119] = 8'b00000000;

       /* 0000000 rs2 rs1 110 rd 0110011 OR rs2 = x5 rs1 = x6 rd = x7 
         realiza and entre x5 e x6, guardando -31649 em x7*/
      Memory[1126] = 8'b1_0110011;  
      Memory[1125] = 8'b1_110_0011; 
      Memory[1124] = 8'b0110_0010;
      Memory[1123] = 8'b0000000_0;

      /* imm[11:0] rs1 110 rd 0010011 ORI rs1 = x3 rd = x7 
         realiza andi entre x3 e 3, guardando 15 em x7*/
      Memory[1130] = 8'b1_0010011;  
      Memory[1129] = 8'b1_110_0011; 
      Memory[1128] = 8'b0011_0001;
      Memory[1127] = 8'b00000000;


      /* Testes com a memoria */
      /* imm[11:0] rs1 000 rd 0000011 LB rd = x9 rs1 = x0 im = 32
         da load de 1 byte com sinal em x9, x9 deve valer 1 */
      Memory[1134] = 8'b1_0000011;  
      Memory[1133] = 8'b0_000_0100; 
      Memory[1132] = 8'b0000_0000;
      Memory[1131] = 8'b00000010;

      /* imm[11:0] rs1 000 rd 0000011 LB rd = x9 rs1 = x0 im = 40
         da load de 1 byte com sinal em x9, x9 deve valer -127 */
      Memory[1138] = 8'b1_0000011;  
      Memory[1137] = 8'b0_000_0100; 
      Memory[1136] = 8'b1000_0000;
      Memory[1135] = 8'b00000010;

      /* imm[11:0] rs1 100 rd 0000011 LBU rd = x9 rs1 = x0 im = 32
         da load de 1 byte sem sinal em x9, x9 deve valer 1 */
      Memory[1142] = 8'b1_0000011;  
      Memory[1141] = 8'b0_100_0100; 
      Memory[1140] = 8'b0000_0000;
      Memory[1139] = 8'b00000010;

      /* imm[11:0] rs1 100 rd 0000011 LBU rd = x9 rs1 = x0 im = 40
         da load de 1 byte sem sinal em x9, x9 deve valer 129 */
      Memory[1146] = 8'b1_0000011;  
      Memory[1145] = 8'b0_100_0100; 
      Memory[1144] = 8'b1000_0000;
      Memory[1143] = 8'b00000010;

      /* imm[11:0] rs1 001 rd 0000011 LH rd = x9 rs1 = x0 im = 32
         da load de 2 bytes com sinal em x9, x9 deve valer 513 */
      Memory[1150] = 8'b1_0000011;  
      Memory[1149] = 8'b0_001_0100; 
      Memory[1148] = 8'b0000_0000;
      Memory[1147] = 8'b00000010;

      /* imm[11:0] rs1 001 rd 0000011 LH rd = x9 rs1 = x0 im = 40
         da load de 2 bytes com sinal em x9, x9 deve valer -32127 */
      Memory[1154] = 8'b1_0000011;  
      Memory[1153] = 8'b0_001_0100; 
      Memory[1152] = 8'b1000_0000;
      Memory[1151] = 8'b00000010;

      /* imm[11:0] rs1 101 rd 0000011 LHU rd = x9 rs1 = x0 im = 32
         da load de 2 bytes sem sinal em x9, x9 deve valer 513 */
      Memory[1158] = 8'b1_0000011;  
      Memory[1157] = 8'b0_101_0100; 
      Memory[1156] = 8'b0000_0000;
      Memory[1155] = 8'b00000010;

      /* imm[11:0] rs1 101 rd 0000011 LHU rd = x9 rs1 = x0 im = 40
         da load de 2 bytes sem sinal em x9, x9 deve valer 33409 */
      Memory[1162] = 8'b1_0000011;  
      Memory[1161] = 8'b0_101_0100; 
      Memory[1160] = 8'b1000_0000;
      Memory[1159] = 8'b00000010;

      /* imm[11:0] rs1 010 rd 0000011 LW rd = x9 rs1 = x0 im = 32
         da load de 4 bytes com sinal em x9, x9 deve valer 134480385 */
      Memory[1166] = 8'b1_0000011;  
      Memory[1165] = 8'b0_010_0100; 
      Memory[1164] = 8'b0000_0000;
      Memory[1163] = 8'b00000010;

      /* imm[11:0] rs1 010 rd 0000011 LW rd = x9 rs1 = x0 im = 40
         da load de 4 bytes com sinal em x9, x9 deve valer -2004581759 */
      Memory[1170] = 8'b1_0000011;  
      Memory[1169] = 8'b0_010_0100; 
      Memory[1168] = 8'b1000_0000;
      Memory[1167] = 8'b00000010;

      /* imm[11:0] rs1 110 rd 0000011 LWU rd = x9 rs1 = x0 im = 32
         da load de 4 bytes sem sinal em x9, x9 deve valer 134480385 */
      Memory[1174] = 8'b1_0000011;  
      Memory[1173] = 8'b0_110_0100; 
      Memory[1172] = 8'b0000_0000;
      Memory[1171] = 8'b00000010;

      /* imm[11:0] rs1 110 rd 0000011 LWU rd = x9 rs1 = x0 im = 40
         da load de 4 bytes sem sinal em x9, x9 deve valer 2290385537 */
      Memory[1178] = 8'b1_0000011;  
      Memory[1177] = 8'b0_110_0100; 
      Memory[1176] = 8'b1000_0000;
      Memory[1175] = 8'b00000010;

      /* Teste XOR */
      /* 0000000 rs2 rs1 100 rd 0110011 XOR rs2 = x1 rs1 = x3 rd = x10
         xor entre registradores x1 e x3, gravando 6 no registrador x10 */
      Memory[1182] = 8'b0_0110011;  
      Memory[1181] = 8'b1_100_0101; 
      Memory[1180] = 8'b0001_0001;
      Memory[1179] = 8'b0000000_0;

      /* Teste XORI */
      /* imm[11:0] rs1 100 rd 0010011  XORI rs1 = x3 rd = x10 im = 010
         xor entre o registrador x3 e 2, gravando 12 no registrador x10 */
      Memory[1186] = 8'b0_0010011;  
      Memory[1185] = 8'b1_100_0101; 
      Memory[1184] = 8'b0010_0001;
      Memory[1183] = 8'b00000000;

      /* Teste SLT */
      /* 0000000 rs2 rs1 010 rd 0110011 SLT rs2 = x4 rs1 = x6 rd = x11
         como rs1 < rs2, x11 deve valer 1 */
      Memory[1190] = 8'b1_0110011;  
      Memory[1189] = 8'b0_010_0101; 
      Memory[1188] = 8'b0100_0011;
      Memory[1187] = 8'b0000000_0;

      /* 0000000 rs2 rs1 010 rd 0110011 SLT rs2 = x6 rs1 = x4 rd = x11
         como rs1 > rs2, x11 deve valer 0 */
      Memory[1194] = 8'b1_0110011;  
      Memory[1193] = 8'b0_010_0101; 
      Memory[1192] = 8'b0110_0010;
      Memory[1191] = 8'b0000000_0;

      /* Teste SLTU */
      /* 0000000 rs2 rs1 010 rd 0110011 SLTU rs2 = x4 rs1 = x6 rd = x11
         como rs1 > rs2, x11 deve valer 0 */
      Memory[1198] = 8'b1_0110011;  
      Memory[1197] = 8'b0_011_0101; 
      Memory[1196] = 8'b0100_0011;
      Memory[1195] = 8'b0000000_0;

      /* 0000000 rs2 rs1 010 rd 0110011 SLTU rs2 = x6 rs1 = x4 rd = x11
         como rs1 < rs2, x11 deve valer 1 */
      Memory[1202] = 8'b1_0110011;  
      Memory[1201] = 8'b0_011_0101; 
      Memory[1200] = 8'b0110_0010;
      Memory[1199] = 8'b0000000_0;

      /* Teste SLTI */
      /* imm[11:0] rs1 010 rd 0010011 SLTI rs1 = x6 rd = x11 imm = 3
         como rs1 < 3, x11 deve valer 1 */
      Memory[1206] = 8'b1_0010011;  
      Memory[1205] = 8'b0_010_0101; 
      Memory[1204] = 8'b0011_0011;
      Memory[1203] = 8'b00000000;

      /* imm[11:0] rs1 010 rd 0010011 SLTI rs1 = x4 rd = x11 imm = 3
         como rs1 > 3, x11 deve valer 0 */
      Memory[1210] = 8'b1_0010011;  
      Memory[1209] = 8'b0_010_0101; 
      Memory[1208] = 8'b0011_0010;
      Memory[1207] = 8'b00000000;

      /* Teste SLTIU */
      /* imm[11:0] rs1 011 rd 0010011 SLTIU rs1 = x6 rd = x11 imm = 3
         como rs1 > 3, x11 deve valer 0 */
      Memory[1214] = 8'b1_0010011;  
      Memory[1213] = 8'b0_011_0101; 
      Memory[1212] = 8'b0011_0011;
      Memory[1211] = 8'b00000000;

      /* imm[11:0] rs1 011 rd 0010011 SLTIU rs1 = x4 rd = x11 imm = 15
         como rs1 < 3, x11 deve valer 1 */
      Memory[1218] = 8'b1_0010011;  
      Memory[1217] = 8'b0_011_0101; 
      Memory[1216] = 8'b1111_0010;
      Memory[1215] = 8'b00000000;

      /* Testes com storage */
      /* imm[11:5] rs2 rs1 000 imm[4:0] 0100011 SB imm = 40 rs2 = x6 rs1 = x0  */
      Memory[1222] = 8'b0_0100011;  
      Memory[1221] = 8'b0_000_0100; 
      Memory[1220] = 8'b0110_0000;
      Memory[1219] = 8'b0000001_0;

      // ld x1, 0(x0)
      // reg x1 = 79
      Memory[1226] = 8'b1_0000011;
      Memory[1225] = 8'b0_011_0000;
      Memory[1224] = 8'b1000_0000;
      Memory[1223] = 8'b00000010;
      
      /* imm[11:5] rs2 rs1 001 imm[4:0] 0100011 SB imm = 40 rs2 = x6 rs1 = x0  */
      Memory[1230] = 8'b0_0100011;  
      Memory[1229] = 8'b0_001_0100; 
      Memory[1228] = 8'b0110_0000;
      Memory[1227] = 8'b0000001_0;

      // ld x1, 0(x0)
      // reg x1 = 33871
      Memory[1234] = 8'b1_0000011;
      Memory[1233] = 8'b0_011_0000;
      Memory[1232] = 8'b1000_0000;
      Memory[1231] = 8'b00000010;

      /* imm[11:5] rs2 rs1 001 imm[4:0] 0100011 SB imm = 40 rs2 = x6 rs1 = x0  */
      Memory[1238] = 8'b0_0100011;  
      Memory[1237] = 8'b0_010_0100; 
      Memory[1236] = 8'b0110_0000;
      Memory[1235] = 8'b0000001_0;

      // ld x1, 0(x0)
      // reg x1 = 4294935631
      Memory[1242] = 8'b1_0000011;
      Memory[1241] = 8'b0_011_0000;
      Memory[1240] = 8'b1000_0000;
      Memory[1239] = 8'b00000010;

      /* Testes com SHIFTs */
      /* Reseta registrador x12 para x6 */
      // 000000 shamt rs1 001 rd 0010011 SLLI rd = x12 rs1 = x6 shamt = 0
      // x12 = -31665
      Memory[1246] = 8'b0_0010011;
      Memory[1245] = 8'b0_001_0110;
      Memory[1244] = 8'b0000_0011;
      Memory[1243] = 8'b000000_00;

      // 000000 shamt rs1 001 rd 0010011 SLLI rd = x12 rs1 = x6 shamt = 3
      // x12 = -253320
      Memory[1250] = 8'b0_0010011;
      Memory[1249] = 8'b0_001_0110;
      Memory[1248] = 8'b0011_0011;
      Memory[1247] = 8'b000000_00;

      /* Reseta registrador */
      // 000000 shamt rs1 001 rd 0010011 SLLI rd = x12 rs1 = x6 shamt = 0
      // x12 = -31665
      Memory[1254] = 8'b0_0010011;
      Memory[1253] = 8'b0_001_0110;
      Memory[1252] = 8'b0000_0011;
      Memory[1251] = 8'b000000_00;

      // 000000 shamt rs1 001 rd 0010011 SRLI rd = x12 rs1 = x6 shamt = 3
      // x12 = 230584300921369993
      Memory[1258] = 8'b0_0010011;
      Memory[1257] = 8'b0_101_0110;
      Memory[1256] = 8'b0011_0011;
      Memory[1255] = 8'b000000_00;
      
      /* Reseta registrador */
      // 000000 shamt rs1 001 rd 0010011 SLLI rd = x12 rs1 = x6 shamt = 0
      // x12 = -31665
      Memory[1262] = 8'b0_0010011;
      Memory[1261] = 8'b0_001_0110;
      Memory[1260] = 8'b0000_0011;
      Memory[1259] = 8'b000000_00;

      // 010000 shamt rs1 101 rd 0010011 SRAI rd = x12 rs1 = x6 shamt = 3
      // x12 = -3959
      Memory[1266] = 8'b0_0010011;
      Memory[1265] = 8'b0_101_0110;
      Memory[1264] = 8'b0011_0011;
      Memory[1263] = 8'b010000_00;

      // 0100000 shamt rs1 101 rd 0010011 SRAI rd = x12 rs1 = x1 shamt = 3
      // x12 = 536866953
      Memory[1270] = 8'b0_0010011;
      Memory[1269] = 8'b1_101_0110;
      Memory[1268] = 8'b0011_0000;
      Memory[1267] = 8'b010000_00;

      /* Reseta registrador */
      // 000000 shamt rs1 001 rd 0010011 SLLI rd = x12 rs1 = x6 shamt = 0
      // x12 = -31665
      Memory[1274] = 8'b0_0010011;
      Memory[1273] = 8'b0_001_0110;
      Memory[1272] = 8'b0000_0011;
      Memory[1271] = 8'b000000_00;

      // 0000000 rs2 rs1 001 rd 0110011 SLL rd = x12 rs1 = x6 rs2 = x2
      // x12 = -2026560
      Memory[1278] = 8'b0_0110011;
      Memory[1277] = 8'b0_001_0110;
      Memory[1276] = 8'b0010_0011;
      Memory[1275] = 8'b000000_00;

      /* Reseta registrador */
      // 000000 shamt rs1 001 rd 0010011 SLLI rd = x12 rs1 = x6 shamt = 0
      // x12 = -31665
      Memory[1282] = 8'b0_0010011;
      Memory[1281] = 8'b0_001_0110;
      Memory[1280] = 8'b0000_0011;
      Memory[1279] = 8'b000000_00;
      
      // 0000000 rs2 rs1 101 rd 0110011 SRL rd = x12 rs1 = x6 rs2 = x2
      // x12 = 288230376151711249
      Memory[1286] = 8'b0_0110011;
      Memory[1285] = 8'b0_101_0110;
      Memory[1284] = 8'b0010_0011;
      Memory[1283] = 8'b000000_00;

      /* Reseta registrador */
      // 000000 shamt rs1 001 rd 0010011 SLLI rd = x12 rs1 = x6 shamt = 0
      // x12 = -31665
      Memory[1290] = 8'b0_0010011;
      Memory[1289] = 8'b0_001_0110;
      Memory[1288] = 8'b0000_0011;
      Memory[1287] = 8'b000000_00;
      
      // 0100000 rs2 rs1 101 rd 0110011 SRA rd = x12 rs1 = x6 rs2 = x2
      // x12 = -495
      Memory[1294] = 8'b0_0110011;
      Memory[1293] = 8'b0_101_0110;
      Memory[1292] = 8'b0010_0011;
      Memory[1291] = 8'b010000_00;

      /* extensao RV64I */
      // imm[11:0] rs1 000 rd 0011011 ADDIW rs1 = x6 rd = x14 imm = 1
      // x14 = -31664
      Memory[1298] = 8'b0_0011011;
      Memory[1297] = 8'b0_000_0111;
      Memory[1296] = 8'b0001_0011;
      Memory[1295] = 8'b00000000;

      // imm[11:0] rs1 000 rd 0011011 ADDIW rs1 = x6 rd = x14 imm = -1
      // x14 = -31666
      Memory[1302] = 8'b0_0011011;
      Memory[1301] = 8'b0_000_0111;
      Memory[1300] = 8'b1111_0011;
      Memory[1299] = 8'b11111111;

      // ld x6, 0(x0)
      // reg x6 = -9169152299773951359
      Memory[1306] = 8'b0_0000011;
      Memory[1305] = 8'b0_011_0011;
      Memory[1304] = 8'b0000_0000;
      Memory[1303] = 8'b00000011;

      // imm[11:0] rs1 000 rd 0011011 ADDIW rs1 = x6 rd = x14 imm = 1
      // x14 = 1216643714
      Memory[1310] = 8'b0_0011011;
      Memory[1309] = 8'b0_000_0111;
      Memory[1308] = 8'b0001_0011;
      Memory[1307] = 8'b00000000;

      // 0000000 shamt rs1 001 rd 0011011 SLLIW rs1 = x6 rd = x14 imm = 3
      // x14 = 1143215112
      Memory[1314] = 8'b0_0011011;
      Memory[1313] = 8'b0_001_0111;
      Memory[1312] = 8'b0011_0011;
      Memory[1311] = 8'b0000000_0;

      // 0000000 shamt rs1 101 rd 0011011 SRLIW rs1 = x6 rd = x14 imm = 3
      // x14 = 152080464
      Memory[1318] = 8'b0_0011011;
      Memory[1317] = 8'b0_101_0111;
      Memory[1316] = 8'b0011_0011;
      Memory[1315] = 8'b0000000_0;

      // 0100000 shamt rs1 101 rd 0011011 SRAIW rs1 = x6 rd = x14 imm = 3
      // x14 = 152080464
      Memory[1322] = 8'b0_0011011;
      Memory[1321] = 8'b0_101_0111;
      Memory[1320] = 8'b0011_0011;
      Memory[1319] = 8'b0100000_0;

      // 0100000 shamt rs1 101 rd 0011011 SRAIW rs1 = x1 rd = x14 imm = 3
      // x14 = -3959
      Memory[1326] = 8'b0_0011011;
      Memory[1325] = 8'b1_101_0111;
      Memory[1324] = 8'b0011_0000;
      Memory[1323] = 8'b0100000_0;

      // 0000000 rs2 rs1 000 rd 0111011 ADDW rd = x15 rs1 = x1 rs2 = x3 
      // x15 = -31651
      Memory[1330] = 8'b1_0111011;
      Memory[1329] = 8'b1_000_0111;
      Memory[1328] = 8'b0011_0000;
      Memory[1327] = 8'b0000000_0;

      // 0100000 rs2 rs1 000 rd 0111011 SUBW rd = x15 rs1 = x1 rs2 = x3 
      // x15 = -31679
      Memory[1334] = 8'b1_0111011;
      Memory[1333] = 8'b1_000_0111;
      Memory[1332] = 8'b0011_0000;
      Memory[1331] = 8'b0100000_0;

      // 0000000 rs2 rs1 001 rd 0111011 SLLW rd = x15 rs1 = x1 rs2 = x3 
      // x15 = -518799360
      Memory[1338] = 8'b1_0111011;
      Memory[1337] = 8'b1_001_0111;
      Memory[1336] = 8'b0011_0000;
      Memory[1335] = 8'b0000000_0;

      // 0000000 rs2 rs1 101 rd 0111011 SRLW rd = x15 rs1 = x1 rs2 = x3 
      // x15 = 262142
      Memory[1342] = 8'b1_0111011;
      Memory[1341] = 8'b1_101_0111;
      Memory[1340] = 8'b0011_0000;
      Memory[1339] = 8'b0000000_0;

      // 0100000 rs2 rs1 101 rd 0111011 SRAW rd = x15 rs1 = x1 rs2 = x3 
      // x15 = -2
      Memory[1346] = 8'b1_0111011;
      Memory[1345] = 8'b1_101_0111;
      Memory[1344] = 8'b0011_0000;
      Memory[1343] = 8'b0100000_0;

      /* Teste LUI */
      // imm[31:12] rd 0110111 rd = x16 imm = 1
      // x16 = 4096
      Memory[1350] = 8'b0_0110111;
      Memory[1349] = 8'b0001_1000;
      Memory[1348] = 8'b00000000;
      Memory[1347] = 8'b00000000;

      // imm[31:12] rd 0110111 rd = x16 imm = 2
      // x16 = 8192
      Memory[1354] = 8'b0_0110111;
      Memory[1353] = 8'b0010_1000;
      Memory[1352] = 8'b00000000;
      Memory[1351] = 8'b00000000;
      
      /*
         Simulando código em C:
         int main () {
            int a = 2;
            int b = 1;
            int c = a + b;
            return 0;
         }

         Assembly gerado sem pseudo instrucoes:
         0000000000000000 <main>:
            0:	fe010113          	addi	sp,sp,-32
            4:	00813c23          	sd	s0,24(sp)
            8:	02010413          	addi	s0,sp,32
            c:	00200793          	addi	a5,zero,2
         10:	fef42223          	sw	a5,-28(s0)
         14:	00100793          	addi	a5,zero,1
         18:	fef42423          	sw	a5,-24(s0)
         1c:	fe442783          	lw	a5,-28(s0)
         20:	00078713          	addi	a4,a5,0
         24:	fe842783          	lw	a5,-24(s0)
         28:	00f707bb          	addw	a5,a4,a5
         2c:	fef42623          	sw	a5,-20(s0)
         30:	00000793          	addi	a5,zero,0
         34:	00078513          	addi	a0,a5,0
         38:	01813403          	ld	s0,24(sp)
         3c:	02010113          	addi	sp,sp,32
         40:	00008067          	jalr	zero,0(ra)

         Assembly compilado para rodar aqui no RISC-V com sp = x1
         
         addi x1,x1,-32
         sd	x0,24(x1)
         addi x0,x1,32
         addi x5,x0,2
         sw	x5,-28(x0)
         addi x5,x0,1
         sw	x5,-24(x0)
         lw	x5,-28(x0)
         addi x4,x5,0
         lw	x5,-24(x0)
         addw x5,x4,x5
         sw	x5,-20(x0)
         addi x5,x0,0
         addi x0,x5,0
         ld x0,24(x1)
         addi x1,x1,32
         jalr x0,0(ra)

      */

      Memory[1358] = 8'b10010011;
      Memory[1357] = 8'b10000000;
      Memory[1356] = 8'b00000000;
      Memory[1355] = 8'b11111110;

      Memory[1362] = 8'b00100011;
      Memory[1361] = 8'b10111000;
      Memory[1360] = 8'b00000000;
      Memory[1359] = 8'b00000010;

      Memory[1366] = 8'b00010011;
      Memory[1365] = 8'b10000000;
      Memory[1364] = 8'b00000000;
      Memory[1363] = 8'b00000010;

      Memory[1370] = 8'b10010011;
      Memory[1369] = 8'b00000010;
      Memory[1368] = 8'b00100000;
      Memory[1367] = 8'b00000000;

      Memory[1374] = 8'b10100011;
      Memory[1373] = 8'b00100100;
      Memory[1372] = 8'b01010000;
      Memory[1371] = 8'b11111100;

      Memory[1378] = 8'b10100011;
      Memory[1377] = 8'b00100100;
      Memory[1376] = 8'b01010000;
      Memory[1375] = 8'b11111100;

      Memory[1382] = 8'b00000000;
      Memory[1381] = 8'b00010000;
      Memory[1380] = 8'b00000010;
      Memory[1379] = 8'b10010011;

      Memory[1386] = 8'b11111100;
      Memory[1385] = 8'b01010000;
      Memory[1384] = 8'b00101000;
      Memory[1383] = 8'b10100011;

      Memory[1390] = 8'b11111110;
      Memory[1389] = 8'b01000000;
      Memory[1388] = 8'b00100010;
      Memory[1387] = 8'b10000011;

      Memory[1394] = 8'b00000000;
      Memory[1393] = 8'b00000010;
      Memory[1392] = 8'b10000010;
      Memory[1391] = 8'b00010011;

      Memory[1398] = 8'b11111110;
      Memory[1397] = 8'b10000000;
      Memory[1396] = 8'b00100010;
      Memory[1395] = 8'b10000011;

      Memory[1402] = 8'b00000000;
      Memory[1401] = 8'b01010010;
      Memory[1400] = 8'b00000010;
      Memory[1399] = 8'b10111011;

      Memory[1406] = 8'b11111100;
      Memory[1405] = 8'b01010000;
      Memory[1404] = 8'b00101100;
      Memory[1403] = 8'b10100011;

      Memory[1410] = 8'b00000000;
      Memory[1409] = 8'b00000000;
      Memory[1408] = 8'b00000010;
      Memory[1407] = 8'b10010011;

      Memory[1414] = 8'b00000000;
      Memory[1413] = 8'b00000010;
      Memory[1412] = 8'b10000000;
      Memory[1411] = 8'b00010011;

      Memory[1418] = 8'b00000001;
      Memory[1417] = 8'b10000000;
      Memory[1416] = 8'b10110000;
      Memory[1415] = 8'b00000011;

      Memory[1422] = 8'b00000010;
      Memory[1421] = 8'b00000000;
      Memory[1420] = 8'b10000000;
      Memory[1419] = 8'b10010011;

      Memory[1426] = 8'b00000000;
      Memory[1425] = 8'b00000000;
      Memory[1424] = 8'b00000000;
      Memory[1423] = 8'b11100111;


   end
   
   assign read_data = Memory[endereco]; 

   // sincrono
   always @(posedge clk) begin        
        if (mem_write == 1) begin
          Memory[endereco] <= write_data;
        end
   end      
endmodule


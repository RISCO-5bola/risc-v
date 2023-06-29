module Distancer (
    input [63:0] doubleWord,
    output [63:0] distance
);
    //distance is positive (first bit 1 to the left)
    //the bit 1 will show you where is the distance
    //ex: bit 36: distance is 36.
    wire [36:0]positiveDistance;
    //ex: bit 27: distance is 27
    wire [27:0]negativeDistance;

    wire bitVinteESeteEhUm;
    assign bitVinteESeteEhUm = doubleWord[27];

    assign positiveDistance[36] = doubleWord[63];
    assign positiveDistance[35] = (~positiveDistance[36] & doubleWord[62]);
    assign positiveDistance[34] = (~positiveDistance[35] & doubleWord[61]);
    assign positiveDistance[33] = (~positiveDistance[34] & doubleWord[60]);
    assign positiveDistance[32] = (~positiveDistance[33] & doubleWord[59]);
    assign positiveDistance[31] = (~positiveDistance[32] & doubleWord[58]);
    assign positiveDistance[30] = (~positiveDistance[31] & doubleWord[57]);
    assign positiveDistance[29] = (~positiveDistance[30] & doubleWord[56]);
    assign positiveDistance[28] = (~positiveDistance[29] & doubleWord[55]);
    assign positiveDistance[27] = (~positiveDistance[28] & doubleWord[54]);
    assign positiveDistance[26] = (~positiveDistance[27] & doubleWord[53]);
    assign positiveDistance[25] = (~positiveDistance[26] & doubleWord[52]);
    assign positiveDistance[24] = (~positiveDistance[25] & doubleWord[51]);
    assign positiveDistance[23] = (~positiveDistance[24] & doubleWord[50]);
    assign positiveDistance[22] = (~positiveDistance[23] & doubleWord[49]);
    assign positiveDistance[21] = (~positiveDistance[22] & doubleWord[48]);
    assign positiveDistance[20] = (~positiveDistance[21] & doubleWord[47]);
    assign positiveDistance[19] = (~positiveDistance[20] & doubleWord[46]);
    assign positiveDistance[18] = (~positiveDistance[19] & doubleWord[45]);
    assign positiveDistance[17] = (~positiveDistance[18] & doubleWord[44]);
    assign positiveDistance[16] = (~positiveDistance[17] & doubleWord[43]);
    assign positiveDistance[15] = (~positiveDistance[16] & doubleWord[42]);
    assign positiveDistance[14] = (~positiveDistance[15] & doubleWord[41]);
    assign positiveDistance[13] = (~positiveDistance[14] & doubleWord[40]);
    assign positiveDistance[12] = (~positiveDistance[13] & doubleWord[39]);
    assign positiveDistance[11] = (~positiveDistance[12] & doubleWord[38]);
    assign positiveDistance[10] = (~positiveDistance[11] & doubleWord[37]);
    assign positiveDistance[9] = (~positiveDistance[10] & doubleWord[36]);
    assign positiveDistance[8] = (~positiveDistance[9] & doubleWord[35]);
    assign positiveDistance[7] = (~positiveDistance[8] & doubleWord[34]);
    assign positiveDistance[6] = (~positiveDistance[7] & doubleWord[33]);
    assign positiveDistance[5] = (~positiveDistance[6] & doubleWord[32]);
    assign positiveDistance[4] = (~positiveDistance[5] & doubleWord[31]);
    assign positiveDistance[3] = (~positiveDistance[4] & doubleWord[30]);
    assign positiveDistance[2] = (~positiveDistance[3] & doubleWord[29]);
    assign positiveDistance[1] = (~positiveDistance[2] & doubleWord[28]);

    //Now for the negative distances.

    assign negativeDistance[1] = (~positiveDistance[1] & doubleWord[26]);
    assign negativeDistance[2] = (~negativeDistance[1] & doubleWord[25]);
    assign negativeDistance[3] = (~negativeDistance[2] & doubleWord[24]);
    assign negativeDistance[4] = (~negativeDistance[3] & doubleWord[23]);
    assign negativeDistance[5] = (~negativeDistance[4] & doubleWord[22]);
    assign negativeDistance[6] = (~negativeDistance[5] & doubleWord[21]);
    assign negativeDistance[7] = (~negativeDistance[6] & doubleWord[20]);
    assign negativeDistance[8] = (~negativeDistance[7] & doubleWord[19]);
    assign negativeDistance[9] = (~negativeDistance[8] & doubleWord[18]);
    assign negativeDistance[10] = (~negativeDistance[9] & doubleWord[17]);
    assign negativeDistance[11] = (~negativeDistance[10] & doubleWord[16]);
    assign negativeDistance[12] = (~negativeDistance[11] & doubleWord[15]);
    assign negativeDistance[13] = (~negativeDistance[12] & doubleWord[14]);
    assign negativeDistance[14] = (~negativeDistance[13] & doubleWord[13]);
    assign negativeDistance[15] = (~negativeDistance[14] & doubleWord[12]);
    assign negativeDistance[16] = (~negativeDistance[15] & doubleWord[11]);
    assign negativeDistance[17] = (~negativeDistance[16] & doubleWord[10]);
    assign negativeDistance[18] = (~negativeDistance[17] & doubleWord[9]);
    assign negativeDistance[19] = (~negativeDistance[18] & doubleWord[8]);
    assign negativeDistance[20] = (~negativeDistance[19] & doubleWord[7]);
    assign negativeDistance[21] = (~negativeDistance[20] & doubleWord[6]);
    assign negativeDistance[22] = (~negativeDistance[21] & doubleWord[5]);
    assign negativeDistance[23] = (~negativeDistance[22] & doubleWord[4]);
    assign negativeDistance[24] = (~negativeDistance[23] & doubleWord[3]);
    assign negativeDistance[25] = (~negativeDistance[24] & doubleWord[2]);
    assign negativeDistance[26] = (~negativeDistance[25] & doubleWord[1]);
    assign negativeDistance[27] = (~negativeDistance[26] & doubleWord[0]);
    //Alright, now we know were to consult the distance. But we need to pass a number as output
    //no problem, the most crucial part we have, now is for the GOLD:

    
    wire [63:0]positiveDistanceFinale;
    assign positiveDistanceFinale[63:7] = 56'b0;

    assign positiveDistanceFinale[0] = (
    positiveDistance[1] | positiveDistance[3] | positiveDistance[5] |
    positiveDistance [7] | positiveDistance [9] | positiveDistance[11] | positiveDistance[13] | positiveDistance[15] |
    positiveDistance [17] | positiveDistance [19] | positiveDistance [21] | positiveDistance[23] | positiveDistance[25]|
    positiveDistance[27] | positiveDistance[29] | positiveDistance[31] | positiveDistance[33] | positiveDistance [35]);

    assign positiveDistanceFinale[1] = (
    positiveDistance[2] | positiveDistance[3] | positiveDistance[6] |
    positiveDistance [7] | positiveDistance [10] | positiveDistance[11] | positiveDistance[14] | positiveDistance[15] |
    positiveDistance [18] | positiveDistance [19] | positiveDistance [22] | positiveDistance[23] | positiveDistance[26]|
    positiveDistance[27] | positiveDistance[30] | positiveDistance[31] | positiveDistance[34] | positiveDistance [35]);
 
    assign positiveDistanceFinale[2] = (
    positiveDistance[4] | positiveDistance[5] | positiveDistance[6] |
    positiveDistance [7] | positiveDistance [12] | positiveDistance[13] | positiveDistance[14] | positiveDistance[15] |
    positiveDistance [20] | positiveDistance [21] | positiveDistance [22] | positiveDistance[23] | positiveDistance[28]|
    positiveDistance[29] | positiveDistance[30] | positiveDistance[31] | positiveDistance [36]);
    
    assign positiveDistanceFinale[3] = (
    positiveDistance[8] | positiveDistance[9] | positiveDistance[10] |
    positiveDistance [11] | positiveDistance [12] | positiveDistance[13] | positiveDistance[14] | positiveDistance[15] |
    positiveDistance [24] | positiveDistance [25] | positiveDistance [26] | positiveDistance[27] | positiveDistance[28]|
    positiveDistance[29] | positiveDistance[30] | positiveDistance[31]);

    assign positiveDistanceFinale[4] = (
    positiveDistance[16] | positiveDistance[17] | positiveDistance[18] |
    positiveDistance [19] | positiveDistance [20] | positiveDistance[21] | positiveDistance[22] | positiveDistance[23] |
    positiveDistance [24] | positiveDistance [25] | positiveDistance [26] | positiveDistance[27] | positiveDistance[28]|
    positiveDistance[29] | positiveDistance[30] | positiveDistance[31]);

    assign positiveDistanceFinale[5] = (
    positiveDistance[16] | positiveDistance[17] | positiveDistance[18] |
    positiveDistance [19] | positiveDistance [20] | positiveDistance[21] | positiveDistance[22] | positiveDistance[23] |
    positiveDistance [24] | positiveDistance [25] | positiveDistance [26] | positiveDistance[27] | positiveDistance[28]|
    positiveDistance[29] | positiveDistance[30] | positiveDistance[31]);

    assign positiveDistanceFinale[6] = (
    positiveDistance[32] | positiveDistance[33] | positiveDistance[34] |
    positiveDistance [35] | positiveDistance [36]);

    //distancia positiva formada!

    //distancia negativa:
    wire [63:0]negativeDistanceFinale;
    assign negativeDistanceFinale[63:5] = 59'b11111111_11111111_11111111_11111111_11111111_11111111_11111111_111;
    //0 to 4
    assign negativeDistanceFinale[0] = (
    negativeDistance[27] | negativeDistance[25] | negativeDistance[23] | negativeDistance[21] |
    negativeDistance[19] | negativeDistance[17] | negativeDistance[15] | negativeDistance[13] |
    negativeDistance[11] | negativeDistance[9] | negativeDistance[7] | negativeDistance[5] |
    negativeDistance[3] | negativeDistance[1]);

    assign negativeDistanceFinale[1] = (
    negativeDistance[26] | negativeDistance[25] | negativeDistance[22] | negativeDistance[21] |
    negativeDistance[18] | negativeDistance[17] | negativeDistance[14] | negativeDistance[13] |
    negativeDistance[10] | negativeDistance[9] | negativeDistance[6] | negativeDistance[5] |
    negativeDistance[2] | negativeDistance[1]);

    assign negativeDistanceFinale[2] = (
    negativeDistance[27] | negativeDistance[26] | negativeDistance[25] |
    negativeDistance[20] | negativeDistance[19] | negativeDistance[18] | negativeDistance[17] |
    negativeDistance[12] | negativeDistance[11] | negativeDistance[10] | negativeDistance[9] |
    negativeDistance[4] | negativeDistance[3] | negativeDistance[2] | negativeDistance[1]);

    assign negativeDistanceFinale[3] = (
    negativeDistance[24] | negativeDistance[23] | negativeDistance[22] | negativeDistance[21] |
    negativeDistance[20] | negativeDistance[19] | negativeDistance[18] | negativeDistance[17] |
    negativeDistance[8] | negativeDistance[7] | negativeDistance[6] | negativeDistance[5] |
    negativeDistance[4] | negativeDistance[3] | negativeDistance[2] | negativeDistance[1] );

    assign negativeDistanceFinale[4] = (
    negativeDistance[16] | negativeDistance[15] | negativeDistance[14] | negativeDistance[13] |
    negativeDistance[12] | negativeDistance[11] | negativeDistance[10] | negativeDistance[9] |
    negativeDistance[8] | negativeDistance[7] | negativeDistance[6] | negativeDistance[5] |
    negativeDistance[4] | negativeDistance[3] | negativeDistance[2] | negativeDistance[1] );

    //Finalizado a contabilização com a distância negativa.

    /*Calculado os dois valores, decidir qual vai ser aquele a ser passado, a distância 
    negativa ou a positiva. Veja que se a distancia for positiva, negativeDistance = 0. e vice-versa,
    usaremos isso para decidir
    */ 
    
    wire distanceIsNegative;

    assign distanceIsNegative = (negativeDistance[27]| negativeDistance[26] | negativeDistance[25] | negativeDistance [24]|
    negativeDistance[23]| negativeDistance[22] | negativeDistance[21] | negativeDistance [20]|
    negativeDistance[19]| negativeDistance[18] | negativeDistance[17] | negativeDistance [16]|
    negativeDistance[15]| negativeDistance[14] | negativeDistance[13] | negativeDistance [12]|
    negativeDistance[11]| negativeDistance[10] | negativeDistance[9] | negativeDistance [8]|
    negativeDistance[7]| negativeDistance[6] | negativeDistance[5] | negativeDistance [4]|
    negativeDistance[3]| negativeDistance[2] | negativeDistance[1]);

    wire distanceIsPositive;
    assign distanceIsPositive = |positiveDistanceFinale;

    wire negOrBitTwentySeven;
    assign negOrBitTwentySeven = ((negativeDistance || bitVinteESeteEhUm) & distanceIsPositive);

    mux_2x1_64bit muxB (.A(negativeDistanceFinale), .B(64'b0), 
                         .S(bitVinteESeteEhUm), .X(MuxBToMuxA));

    wire [63:0] MuxBToMuxA;

    mux_2x1_64bit muxA1 (.A(positiveDistanceFinale), .B(MuxBToMuxA), 
                         .S(negOrBitTwentySeven), .X(distance)); 

endmodule
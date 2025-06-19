`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2025 09:32:14 AM
// Design Name: 
// Module Name: rom
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rom (
    input logic [11:0] addr, 
    output logic [31:0] inst
);

   logic [31:0] rom [0:127];

initial  $readmemh("fib_inst.mem",rom);
 
                                                  // fibonacci with delay -- for fpga 
                                                  
 //Time= 102,402,500 cycles/100,000,000 Hz  =1.024 seconds
 
// assign rom[0]  = 32'h00000293; // addi x5, x0, 0         ; x5 = a = 0
// assign rom[1]  = 32'h00100313; // addi x6, x0, 1         ; x6 = b = 1

// assign rom[2]  = 32'h200001B7; // lui x3, 0x20000        ; x3 = 0x20000000
// assign rom[3]  = 32'h10818113; // addi x2, x3, 0x108     ; x2 = 0x20000108
// assign rom[4]  = 32'hFFF00213; // addi x4, x0, -1        ; x4 = 0xFFFFFFFF
// assign rom[5]  = 32'h00412023; // sw x4, 0(x2)           ; write 0xFFFFFFFF to 0x20000108 (enable out)

// assign rom[6]  = 32'h10418113; // addi x2, x3, 0x104     ; x2 = 0x20000104 (data output address)
// assign rom[7]  = 32'h00512023; // sw x5, 0(x2)           ; write Fibonacci value to GPIO
//// ====== delay loop =======
// assign rom[8]  = 32'h4E200393; // addi x7, x0, 1250      ; outer loop counter (x7 = 1250)
// assign rom[9]  = 32'h00002E37; // lui x28, 0xA           ; x28 = 0x000A000 = 40960
// //assign rom[10] = 32'h410E0E13; // addi x28, x28, 1040    ; x28 = 40960 + 1040 = 42000 (inner loop)

// assign rom[11] = 32'hFFFE0E13; // addi x28, x28, -1      ; inner loop: x28--
// assign rom[12] = 32'hFE0E1EE3; // bne x28, x0, -4        ; if x28 != 0, repeat inner loop

// assign rom[13] = 32'hFFF38393; // addi x7, x7, -1        ; outer loop: x7--
// assign rom[14] = 32'hFE0396E3; // bne x7, x0, -8         ; if x7 != 0, repeat outer loop
//// ====== delay ends here ====== 
// assign rom[15] = 32'h00628F33; // add x30, x5, x6        ; x30 = a + b
// assign rom[16] = 32'h00030293; // addi x5, x6, 0         ; a = b
// assign rom[17] = 32'h000F0313; // addi x6, x30, 0        ; b = sum

// assign rom[18] = 32'hFD5FF06F; // jal x0, -44            ; jump back to rom[7] (infinite loop)

// assign rom[19] = 32'h00000013;
// assign rom[20] = 32'h00000013;


            
                                               // lw and sw test 
//0x01000313  addi x6 x0 4
//0x00000393  addi x7 x0 0
//0x00032283  lw x5 0(x6)
//0x0053A023  sw x5 0(x7)
//0x0000006F	jal x0 0
//0x00000013	addi x0 x0 0	nop
//0x00000013	addi x0 x0 0	nop

//assign rom[1] = 32'h00000393; // addi x7, x0, 0
//assign rom[2] = 32'h00032303; // lw   x5, 0(x6)
//assign rom[3] = 32'h0053A023; // sw   x5, 0(x7)
//assign rom[4] = 32'h0000006F; // jal  x0, 0 (infinite loop)
//assign rom[5] = 32'h00000013;
//assign rom[6] = 32'h00000013;
//assign rom[7] = 32'h00000013;




                                                  //simple fibonacci series 
//// 0x00000293  addi x5 x0 0
//// 0x00100313  addi x6 x0 1
//// 0x00028513  addi x10 x5 0  .. jump here 
//// 0x006283B3  add x7 x5 x6
//// 0x00030293  addi x5 x6 0
//// 0x00038313  addi x6 x7 0
//// 0xFF1FF06F  jal x0 -16

//        assign rom[0]    = 32'h00000293;
//        assign rom[1]    = 32'h00100313;
//        assign rom[2]    = 32'h00028513;
//        assign rom[3]    = 32'h006283B3;
//        assign rom[4]    = 32'h00030293 ;
//        assign rom[5]    = 32'h00038313;
//        assign rom[6]    = 32'hFF1FF06F;
////nop        
//assign rom[7] = 32'h00000013;
//assign rom[8] = 32'h00000013;

 
 

                                              // fibonacci with delay removed for sim
                                  
       // Fibonacci with GPIO output loop
//       assign rom[0]  = 32'h00000293; // addi x5, x0, 0        ; a = 0
//       assign rom[1]  = 32'h00100313; // addi x6, x0, 1        ; b = 1
       
//       assign rom[2]  = 32'h200001B7; // lui x3, 0x20000       ; x3 = 0x20000000
//       assign rom[3]  = 32'h10818113; // addi x2, x3, 0x108    ; x2 = 0x20000108
//       assign rom[4]  = 32'hFFF00213; // addi x4, x0, -1       ; x4 = 0xFFFFFFFF
//       assign rom[5]  = 32'h00412023; // sw x4, 0(x2)          ; store 0xFFFFFFFF to 0x20000108 (enable out)
       
//       assign rom[6]  = 32'h10418113; // addi x2, x3, 0x104    ; x2 = 0x20000104 (output address)
//       assign rom[7]  = 32'h00512023; // sw x5, 0(x2)          ; store Fibonacci value to output
       
//       assign rom[8]  = 32'h00628F33; // add x30, x5, x6       ; sum = a + b
//       assign rom[9]  = 32'h00030293; // addi x5, x6, 0        ; a = b
//       assign rom[10] = 32'h000F0313; // addi x6, x30, 0       ; b = sum
       
//       assign rom[11] = 32'hFF1FF06F; // jal x0, -16           ; infinite loop back to rom[7]

//        assign rom[12] = 32'h00000013;
//        assign rom[13] = 32'h00000013;
        
        
                                // ROM Initialization with add and addi 
//assign rom[0]  = 32'h00100093;
//   assign rom[1]  = 32'h00200113;
//   assign rom[2]  = 32'h00300193;
//   assign rom[3]  = 32'h00400213;
//   assign rom[4]  = 32'h00500293;
//   assign rom[5]  = 32'h00600313;
//   assign rom[6]  = 32'h00700393;
//   assign rom[7]  = 32'h00800413;
//   assign rom[8]  = 32'h00900493;
//   assign rom[9]  = 32'h00A00513;
//   assign rom[10] = 32'h002085B3;
//   assign rom[11] = 32'h00418633;
//   assign rom[12] = 32'h006286B3;
//   assign rom[13] = 32'h00838733;
//   assign rom[14] = 32'h00A487B3;
//   assign rom[15] = 32'h00C58833;
//   assign rom[16] = 32'h00E688B3;
//   assign rom[17] = 32'h01180933;
//   assign rom[18] = 32'h012789B3;
//   assign rom[19] = 32'h00198A33;
//   assign rom[20] = 32'h00B00A93;
//   assign rom[21] = 32'h00C00B13;
//   assign rom[22] = 32'h00D00B93;
//   assign rom[23] = 32'h00E00C13;
//   assign rom[24] = 32'h00F00C93;
//   assign rom[25] = 32'h01000D13;
//   assign rom[26] = 32'h01100D93;
//   assign rom[27] = 32'h01200E13;
//   assign rom[28] = 32'h01300E93;
//   assign rom[29] = 32'h01400F13;
//   assign rom[30] = 32'h016A8FB3;
//   assign rom[31] = 32'h018B82B3;
//   assign rom[32] = 32'h01AC8333;
//   assign rom[33] = 32'h01CD83B3;
//   assign rom[34] = 32'h01EE8433;
//   assign rom[35] = 32'h005F84B3;
//   assign rom[36] = 32'h00730533;
//   assign rom[37] = 32'h009405B3;
//   assign rom[38] = 32'h00B50633;
//   assign rom[39] = 32'h001606B3;
//   assign rom[40] = 32'h00568713;
//   assign rom[41] = 32'hFFD70793;
//   assign rom[42] = 32'h00778813;
//   assign rom[43] = 32'hFFE80893;
//   assign rom[44] = 32'h00988913;
//   assign rom[45] = 32'hFFF90993;
//   assign rom[46] = 32'h00498A13;
//   assign rom[47] = 32'hFFCA0A93;
//   assign rom[48] = 32'h003A8B13;
//   assign rom[49] = 32'hFFDB0B93;




//        assign rom[0]    = 32'h1FC00113;
//        assign rom[1]    = 32'h00000413;
//        assign rom[2]    = 32'h20000493;
//        assign rom[3]    = 32'h00000317;
//        assign rom[4]    = 32'h0B4300E7;
//        assign rom[5]    = 32'h00000317;
//        assign rom[6]    = 32'h130300E7;
//        assign rom[7]    = 32'h100009B7;
//        assign rom[8]    = 32'h00098993;
//        assign rom[9]    = 32'h008989B3;
//        assign rom[10]   = 32'h00A98023;
//        assign rom[11]   = 32'h00A40023;
//        assign rom[12]   = 32'h0009C503;
//        assign rom[13]   = 32'h00044583;
//        assign rom[14]   = 32'h00851513;
//        assign rom[15]   = 32'h00B56533;
//        assign rom[16]   = 32'h00000317;
//        assign rom[17]   = 32'h0E4300E7;
//        assign rom[18]   = 32'h00140413;   
//        assign rom[19]   = 32'hFC9410E3;
//        assign rom[20]   = 32'h0000B537;
//        assign rom[21]   = 32'hAAA50513;
//        assign rom[22]   = 32'h00000317;
//        assign rom[23]   = 32'h0CC300E7;
//        assign rom[24]   = 32'h00000317;
//        assign rom[25]   = 32'h100300E7;
//        assign rom[26]   = 32'h00005537;
//        assign rom[27]   = 32'h55550513;
//        assign rom[28]   = 32'h00000317;
//        assign rom[29]   = 32'h0B4300E7;
//        assign rom[30]   = 32'h00000317;
//        assign rom[31]   = 32'h0E8300E7;
//        assign rom[32]   = 32'h0000B537;
//        assign rom[33]   = 32'hAAA50513;
//        assign rom[34]   = 32'h00000317;
//        assign rom[35]   = 32'h09C300E7;
//        assign rom[36]   = 32'h00000317;
//        assign rom[37]   = 32'h0D0300E7;
//        assign rom[38]   = 32'h00005537;
//        assign rom[39]   = 32'h55550513;
//        assign rom[40]   = 32'h00000317;
//        assign rom[41]   = 32'h084300E7;
//        assign rom[42]   = 32'h00000317;
//        assign rom[43]   = 32'h0B8300E7;
//        assign rom[44]   = 32'h100002B7;
//        assign rom[45]   = 32'h00028293;
//        assign rom[46]   = 32'h00028067;
//        assign rom[47]   = 32'h00000063;
//        assign rom[48]   = 32'h200002B7;
//        assign rom[49]   = 32'h00028293;
//        assign rom[50]   = 32'h08000313;
//        assign rom[51]   = 32'h00628623;
//        assign rom[52]   = 32'h01B00313;
//        assign rom[53]   = 32'h00628023;
//        assign rom[54]   = 32'h00306313;
//        assign rom[55]   = 32'h00036313;
//        assign rom[56]   = 32'h00036313;
//        assign rom[57]   = 32'h00628623;
//        assign rom[58]   = 32'h00106313;
//        assign rom[59]   = 32'h00036313;
//        assign rom[60]   = 32'h08036313;
//        assign rom[61]   = 32'h00236313;
//        assign rom[62]   = 32'h00436313;
//        assign rom[63]   = 32'h00628423;
//        assign rom[64]   = 32'h00028223;
//        assign rom[65]   = 32'h00008067;
//        assign rom[66]   = 32'h20000337;
//        assign rom[67]   = 32'h00030313;
//        assign rom[68]   = 32'h01430283;
//        assign rom[69]   = 32'h0202F293;
//        assign rom[70]   = 32'hFE0288E3;
//        assign rom[71]   = 32'h00A30023;
//        assign rom[72]   = 32'h00008067;
//        assign rom[73]   = 32'h200002B7;
//        assign rom[74]   = 32'h10028293;
//        assign rom[75]   = 32'h00010337;
//        assign rom[76]   = 32'hFFF30313;
//        assign rom[77]   = 32'h0062A423;
//        assign rom[78]   = 32'h00A2A223;
//        assign rom[79]   = 32'h0002A583;
//        assign rom[80]   = 32'h00008067;
//        assign rom[81]   = 32'h20000337;
//        assign rom[82]   = 32'h00030313;
//        assign rom[83]   = 32'h01430283; 
//        assign rom[84]   = 32'h0012F293;
//        assign rom[85]   = 32'hFE0288E3;
//        assign rom[86]   = 32'h00030503;
//        assign rom[87]   = 32'h00008067;
//        assign rom[88]   = 32'h00000293;
//        assign rom[89]   = 32'h00989337;
//        assign rom[90]   = 32'h68030313;
//        assign rom[91]   = 32'h00128293;
//        assign rom[92]   = 32'hFE629EE3;
//        assign rom[93]   = 32'h00008067;
//        assign rom[94]   = 32'h00000593;
//        assign rom[95]   = 32'h00008913;
//        assign rom[96]   = 32'h00000317;
//        assign rom[97]   = 32'hFE0300E7;
//        assign rom[98]   = 32'h00158593;
//        assign rom[99]   = 32'hFEA59AE3;
//        assign rom[100]  = 32'h00090093;
//        assign rom[101]  = 32'h00008067;
//        assign rom[102]  = 32'h00090093;
//        assign rom[103]  = 32'h00008067;
//        assign rom[104]  = 32'h00090093;
//        assign rom[105]  = 32'h00008067;
//        assign rom[106]  = 32'h00000293;
//        assign rom[107]  = 32'h01C9C337;
//        assign rom[108]  = 32'h38030313;
//        assign rom[109]  = 32'h00128293;
//        assign rom[110]  = 32'hFE629EE3;
//        assign rom[111]  = 32'h00008067;
//        assign rom[112]  = 32'h00000000;
//        assign rom[113]  = 32'h00000000;
//        assign rom[114]  = 32'h00000000;
//        assign rom[115]  = 32'h00000000;
//        assign rom[116]  = 32'h00000000;
//        assign rom[117]  = 32'h00000000;
//        assign rom[118]  = 32'h00000000;
//        assign rom[119]  = 32'h00000000;
//        assign rom[120]  = 32'h00000000;
//        assign rom[121]  = 32'h00000000;
//        assign rom[122]  = 32'h00000000;
//        assign rom[123]  = 32'h00000000;
//        assign rom[124]  = 32'h00000000;
//        assign rom[125]  = 32'h00000000;
//        assign rom[126]  = 32'h00000000;
//        assign rom[127]  = 32'h00000000;

    assign inst = rom[addr >> 2];
endmodule
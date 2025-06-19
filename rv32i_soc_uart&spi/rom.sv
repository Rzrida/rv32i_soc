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

initial  $readmemh("uart_io.mem",rom);
 

    assign inst = rom[addr >> 2];
endmodule
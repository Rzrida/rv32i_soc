`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2025 09:29:51 AM
// Design Name: 
// Module Name: program_counter
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


module program_counter #(
    parameter MAX_LIMIT = 8000 // ignored in the current implementation
)(
    input logic clk, 
    input logic reset_n, 
    input logic en,
    input logic [31:0] next_pc_if1, 
    output logic [31:0] current_pc_if1
);

    always_ff @(posedge clk, negedge reset_n) 
    begin 
        if(~reset_n)
            current_pc_if1 <= 32'hfffff000; // base address of boot rom
        else if (en)
            current_pc_if1 <=  next_pc_if1;
    end
    
endmodule

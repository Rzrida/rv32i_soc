`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2025 09:29:12 AM
// Design Name: 
// Module Name: pipeline_controller
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


module pipeline_controller (
    input logic load_hazard,
    input logic branch_hazard,
    input logic stall_pipl,

    output logic if_id_reg_clr, 
    output logic id_exe_reg_clr,
    output logic exe_mem_reg_clr,
    output logic mem_wb_reg_clr,

    output logic if_id_reg_en, 
    output logic id_exe_reg_en,
    output logic exe_mem_reg_en,
    output logic mem_wb_reg_en,
    output logic pc_reg_en
);

    assign if_id_reg_clr = branch_hazard;
    assign id_exe_reg_clr = branch_hazard | load_hazard;
    assign exe_mem_reg_clr = branch_hazard;
    assign mem_wb_reg_clr = 1'b0; // never clear

    assign if_id_reg_en = ~(stall_pipl | load_hazard);
    assign id_exe_reg_en = ~stall_pipl;
    assign exe_mem_reg_en = ~stall_pipl;
    assign mem_wb_reg_en = ~stall_pipl;
    assign pc_reg_en = ~(stall_pipl | load_hazard);

endmodule 

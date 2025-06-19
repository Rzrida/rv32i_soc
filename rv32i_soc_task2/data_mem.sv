`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2025 09:24:41 AM
// Design Name: 
// Module Name: data_mem
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

module data_mem #(
    parameter DEPTH = 1024
)(
    input  wire        clk_i,
    input  wire        rst_i,
    input  wire        cyc_i,
    input  wire        stb_i,
    input  wire [31:0] adr_i,
    input  wire        we_i,
    input  wire [3:0]  sel_i,
    input  wire [31:0] dat_i,
    output wire [31:0] dat_o,
    output wire        ack_o
);

    logic wb_acc;
    logic mem_write;
    logic [6:0] word_addr;
    logic [31:0] dmem [0:DEPTH - 1];
    logic [31:0] mem_rdata, data_o_reg;

    assign wb_acc    = cyc_i & stb_i;
    assign mem_write = wb_acc & we_i;
    assign ack_o     = wb_acc;
    assign word_addr = adr_i[8:2];
    assign mem_rdata = dmem[word_addr];
    assign dat_o     = data_o_reg;

    always_ff @(posedge clk_i) begin
        if (mem_write) begin
            if (sel_i[0]) dmem[word_addr][7:0]   <= dat_i[7:0];
            if (sel_i[1]) dmem[word_addr][15:8]  <= dat_i[15:8];
            if (sel_i[2]) dmem[word_addr][23:16] <= dat_i[23:16];
            if (sel_i[3]) dmem[word_addr][31:24] <= dat_i[31:24];
        end
    end

    n_bit_reg #(.n(32)) data_o_reg_inst (
        .clk     (clk_i),
        .reset_n (~rst_i),
        .data_i  (mem_rdata),
        .data_o  (data_o_reg),
        .wen     (1'b1)
    );

    initial begin
    dmem[0]  = 32'h12345678;
    dmem[1]  = 32'hdeadbeef;
    dmem[2]  = 32'h0badcafe;
    dmem[3]  = 32'h0000a0a0;

    dmem[4]  = 32'h00000001;
    dmem[5]  = 32'h00000002;
    dmem[6]  = 32'h00000003;
    dmem[7]  = 32'h00000004;
    dmem[8]  = 32'h00000005;
    dmem[9]  = 32'h00000006;
    dmem[10] = 32'h00000007;
    dmem[11] = 32'h00000008;
    dmem[12] = 32'h00000009;
    dmem[13] = 32'h00000000;
    dmem[14] = 32'h00000000;
    dmem[15] = 32'h00000000;

    dmem[16] = 32'h00000004;
    dmem[17] = 32'h00000005;

    dmem[18] = 32'h00000000;
    dmem[19] = 32'h00000000;
    dmem[20] = 32'h00000000;
    dmem[21] = 32'h00000000;
    dmem[22] = 32'h00000000;
    dmem[23] = 32'h00000000;
    dmem[24] = 32'h00000000;
    dmem[25] = 32'h00000000;
    dmem[26] = 32'h00000000;
    dmem[27] = 32'h00000000;
    dmem[28] = 32'h00000000;
    dmem[29] = 32'h00000000;
    dmem[30] = 32'h00000000;
    dmem[31] = 32'h00000000;
end

    
   

endmodule



//module data_mem #(
//    parameter DEPTH = 1024
//)(
//  // 8bit WISHBONE bus slave interface
//  input  wire        clk_i,         // clock
//  input  wire        rst_i,         // reset (synchronous active high)
//  input  wire        cyc_i,         // cycle
//  input  wire        stb_i,         // strobe
//  input  wire [31:0] adr_i,         // address
//  input  wire        we_i,          // write enable
//  input  wire [3:0]  sel_i,
//  input  wire [31:0] dat_i,         // data input
//  output reg  [31:0] dat_o,         // data output
//  output reg         ack_o         // normal bus termination

//);
    
       
//logic wb_acc;
//logic mem_write, mem_read;

//assign wb_acc = cyc_i & stb_i;
//assign mem_write = wb_acc &  we_i;
//assign mem_read  = wb_acc & ~we_i;

//assign ack_o = wb_acc;


//logic [6:0] word_addr;
//assign word_addr = adr_i[8:2];

//// inst memory here 
//logic [31:0] dmem [0:DEPTH - 1];

//always_ff @(posedge clk_i) begin 
//    if(mem_write) begin 
//        if(sel_i[0]) dmem[word_addr][7:0]   <= dat_i[7:0];
//        if(sel_i[1]) dmem[word_addr][15:8]  <= dat_i[15:8];
//        if(sel_i[2]) dmem[word_addr][23:16] <= dat_i[23:16];
//        if(sel_i[3]) dmem[word_addr][31:24] <= dat_i[31:24];
//    end
//end

//logic [31:0] data_o_reg, mem_rdata;

//assign mem_rdata = dmem[word_addr];
//n_bit_reg #(
//    .n(32)
//) data_o_reg_inst (
//    .clk(clk_i),
//    .reset_n (~rst_i     ),
//    .data_i  (mem_rdata  ),
//    .data_o  (data_o_reg ),
//    .wen     (1'b1       )
//);

//assign dat_o = data_o_reg;


//endmodule






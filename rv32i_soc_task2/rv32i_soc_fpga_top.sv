`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2025 12:45:36 PM
// Design Name: 
// Module Name: rv32i_soc_fpga_top
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

module clk_div_by_2 (
    input logic reset_n,
    input logic clk_i, 
    output logic clk_o
);
    always @(posedge clk_i, negedge reset_n)
    begin 
        if(~reset_n)    clk_o <= 0;
        else            clk_o <= ~clk_o;
    end
endmodule 

module rv32i_soc_fpag_top (
    input  logic        CLK100MHZ,
    input  logic        CPU_RESETN,
    input  logic [15:0] SW,
    output logic [15:0] LED,
    output logic [6:0]  Seg,
    output logic [7:0]  an
);

    // Clock and Reset
    logic reset_n;
    logic clk;

    assign reset_n = ~CPU_RESETN;

    // Clock divider instance (Divide 100 MHz by 2 to get 50 MHz)
    clk_div_by_2 gen_core_clk (
        .clk_i(CLK100MHZ),
        .clk_o(clk),
        .reset_n(~CPU_RESETN)
    );

    // IO Data wire (connected to GPIO in rv32i_soc)
    wire [31:0] io_data;

    // LED outputs from lower 16 bits of io_data
    assign LED = io_data[15:0];        // Output to LEDs
    assign io_data[31:16] = SW;        // Input from switches

    // Digits for 7-segment display
    logic [3:0] digits [7:0];

    assign digits[0] = io_data[ 3 :  0];
    assign digits[1] = io_data[ 7 :  4];
    assign digits[2] = io_data[11 : 8];
    assign digits[3] = io_data[15 :12];
    assign digits[4] = io_data[19 :16];
    assign digits[5] = io_data[23 :20];
    assign digits[6] = io_data[27 :24];
    assign digits[7] = io_data[31 :28];

    // Seven Segment Controller
    sev_seg_controller ssc (
        .clk(clk),
        .resetn(reset_n),
        .digits(digits),
        .Seg(Seg),
        .AN(an)
    );

    // SoC Instance
    rv32i_soc #(
    ) soc_inst (
        .clk(clk),
        .reset_n(reset_n),
        .io_data(io_data)
        // Add other connections as needed (e.g., UART, interrupts)
    );

endmodule : rv32i_soc_fpag_top


//module clk_div_by_2 (
//    input logic reset_n,
//    input logic clk_i, 
//    output logic clk_o
//);
//    always @(posedge clk_i, negedge reset_n)
//    begin 
//        if(~reset_n)    clk_o <= 0;
//        else            clk_o <= ~clk_o;
//    end
//endmodule 


//module rv32i_soc_fpag_top (
//    input logic CLK100MHZ, 
//    input logic CPU_RESETN, 
    
//    // FPGA core signals 
////    output logic        o_uart_tx,
////    input  logic        i_uart_rx,
////    output logic        o_flash_cs_n,
////    output logic        o_flash_mosi,
////    input  logic        i_flash_miso,


//    input logic [15:0] SW,
//    output logic [15:0] LED
//);  

//    parameter DMEM_DEPTH = 128;
//    parameter IMEM_DEPTH = 128;
    
    
//    logic        o_flash_sclk;
//    STARTUPE2 STARTUPE2
//        (
//        .CFGCLK    (),
//        .CFGMCLK   (),
//        .EOS       (),
//        .PREQ      (),
//        .CLK       (1'b0),
//        .GSR       (1'b0),
//        .GTS       (1'b0),
//        .KEYCLEARB (1'b1),
//        .PACK      (1'b0),
//        .USRCCLKO  (o_flash_sclk),
//        .USRCCLKTS (1'b0),
//        .USRDONEO  (1'b1),
//        .USRDONETS (1'b0));

//    // soc core instance 

//    // spi signals here 
//         // serial clock output
//         // slave select (active low)
//         // MasterOut SlaveIN
//         // MasterIn SlaveOut    

//    // uart signals


//    // gpio signals

//    // wire [31:0]   io_data;
//    // assign io_data[31:16] = SW;
//    // assign LED = io_data[15:0];

//    logic reset_n;
//    logic clk;

//    assign reset_n = CPU_RESETN;

//    clk_div_by_2 gen_core_clk (
//        .clk_i(CLK100MHZ),
//        .clk_o(clk),
//        .reset_n(CPU_RESETN)
//    );

//    rv32i_soc #(
//        .DMEM_DEPTH(DMEM_DEPTH),
//        .IMEM_DEPTH(IMEM_DEPTH)
//    ) soc_inst (
//        .*,
//        .io_data({SW, LED})
//    );

//endmodule : rv32i_soc_fpag_top


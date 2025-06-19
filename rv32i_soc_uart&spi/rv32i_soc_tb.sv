//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2025
// Design Name: 
// Module Name: tb_loopback
// Project Name: RVSoC Loopback Demo
// Target Devices: 
// Tool Versions: 
// Description: 
//   Testbench for RVSoC loopback-mode UART demo. 
//   Loads the firmware (with internal loopback) into instruction memory,
//   toggles clock/reset, and runs simulation to let the core send and
//   receive a byte all in software.  Monitors UART TX activity.
//
// Dependencies: rv32i_soc (with a memory-init for your assembled hex)
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module rv32i_soc_tb;
    logic clk;
    logic reset_n;
    logic o_flash_sclk;
    logic o_flash_cs_n;
    logic o_flash_mosi;
    logic i_flash_miso;
    logic o_uart_tx;
    logic i_uart_rx;

    wire [31:0] io_data;




    // Dut instantiation
    rv32i_soc DUT(
        .*
    );

    // Clock generator 
    initial clk = 0;
    always #5 clk = ~clk;

    // signal geneartion here
    initial begin 
        reset_n = 0;
        repeat(2) @(negedge clk);
        reset_n = 1; // dropping reset after two clk cycles
        
        i_uart_rx = "1";
        
        #200
        
        i_uart_rx = "0";
        
        
        
        
    end


  
initial begin
  $dumpfile("waveform.vcd");
  $dumpvars(0, DUT);
//   $dumpvars(0, DUT.data_mem_inst);
//   $dumpvars(0, DUT.inst_mem_inst);
end

// initial begin
//   // Enable VCD file dumping
//   $dumpfile("waveform.vcd");
  
//   // Force signals for data memory
//   $dumpvars(0, DUT.data_mem_inst);  // Force signals inside data_mem_inst
  
//   // Force signals for instruction memory
//   $dumpvars(0, DUT.inst_mem_inst);  // Force signals inside inst_mem_inst
  
//   // Optionally force other internal signals if needed
//   $dumpvars(0, DUT.wb_m2s_dmem_adr, DUT.wb_m2s_dmem_dat, DUT.wb_s2m_dmem_dat);
//   $dumpvars(0, DUT.wb_m2s_imem_adr, DUT.wb_m2s_imem_dat, DUT.wb_s2m_imem_dat);
// end

endmodule


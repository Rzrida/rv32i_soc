`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2025 09:34:44 AM
// Design Name: 
// Module Name: rv32i_soc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Revision:// Dependencies: 
// 

// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module rv32i_soc #(
    parameter DMEM_DEPTH = 128,
    parameter IMEM_DEPTH = 128
) (
    input logic clk, 
    input logic reset_n,

    // spi signals to the spi-flash

    // uart signals

    // gpio signals
    inout wire [31:0]   io_data
);

    // Memory bus signals
    logic [31:0] mem_addr_mem;
    logic [31:0] mem_wdata_mem; 
    logic        mem_write_mem;
    logic [2:0]  mem_op_mem;
    logic [31:0] mem_rdata_mem;
    logic        mem_read_mem;

    logic [31:0] rom_inst, rom_inst_ff;
    
    logic [31:0] current_pc;
    logic stall_pipl;
    logic if_id_reg_en;
    
    logic  [31:0] wb_adr_o;
    logic  [31:0] wb_dat_o;
    logic  [3:0]  wb_sel_o;
    logic         wb_we_o;
    logic         wb_cyc_o;
    logic         wb_stb_o;
    logic [31:0]  wb_dat_i_cpu; 
    logic         wb_ack_i_cpu;
  
    wire [31:0] inst;
    
    
      logic [31:0] wb_m2s_imem_dat;
      logic [3:0] wb_m2s_imem_sel;
      logic   wb_m2s_imem_we;
      logic  wb_m2s_imem_cyc;
      logic   wb_m2s_imem_stb;
      logic [31:0] wb_s2m_imem_dat; 
      logic   wb_s2m_imem_ack;
  
      logic [31:0] wb_m2s_gpio_adr_i;
      logic [3:0] wb_m2s_gpio_sel_i;
      logic [31:0] wb_m2s_gpio_dat_i;
      logic   wb_m2s_gpio_we_i;
      logic  wb_m2s_gpio_cyc_i;
      logic   wb_m2s_gpio_stb_i;
      
  
      logic [31:0] wb_m2s_dmem_adr_o;
      logic [31:0] wb_m2s_dmem_dat_o;
      logic [3:0]  wb_m2s_dmem_sel_o;
      logic        wb_m2s_dmem_we_o;
      logic        wb_m2s_dmem_cyc_o;
      logic        wb_m2s_dmem_stb_o;
 
      wire [31:0] wb_s2m_dat_i_dmem;
      wire        wb_s2m_ack_i_dmem;
      wire [31:0] wb_dat_i_gpio;
      wire        wb_ack_i_gpio;
  
      reg sel_boot_rom_ff;

      logic [31:0] en_gpio;
      logic [31:0] o_gpio;
      wire [31:0] i_gpio;

      
      logic [31:0] wb_m2s_imem_adr;

      logic [31:0] imem_inst;
      logic [31:0] imem_addr;
      
      wire sel_boot_rom;
      

    
    // ============================================
    //          Processor Core Instantiation
    // ============================================

    rv32i rv32i_inst(
      .clk (clk),
      .reset_n (reset_n),
      .mem_addr_mem(mem_addr_mem),
      .mem_wdata_mem(mem_wdata_mem),
      .mem_write_mem(mem_write_mem),
      .mem_op_mem(mem_op_mem),
      .mem_rdata_mem(mem_rdata_mem),
      .mem_read_mem(mem_read_mem),
      .current_pc(current_pc),
      .inst(inst),
      .stall_pipl(stall_pipl),
      .if_id_reg_en(if_id_reg_en)
    );

    // ============================================
    //                 Wishbone Master 
    // ============================================
    
    wishbone_controller wishbone_master (
        .clk        (clk),
        .rst        (~reset_n),
        .proc_addr  (mem_addr_mem),
        .proc_wdata (mem_wdata_mem),
        .proc_write (mem_write_mem),
        .proc_read  (mem_read_mem),
        .proc_op    (mem_op_mem),
        .proc_rdata (mem_rdata_mem), //check signal 
        .proc_stall_pipl(stall_pipl),
        .wb_adr_o   (wb_adr_o),
        .wb_dat_o   (wb_dat_o),
        .wb_sel_o   (wb_sel_o),
        .wb_we_o    (wb_we_o),
        .wb_cyc_o   (wb_cyc_o),
        .wb_stb_o   (wb_stb_o),
        .wb_dat_i   (wb_dat_i_cpu),//check signal 
        .wb_ack_i   (wb_ack_i_cpu)
    );

  
  
    // ============================================
    //             Wishbone Interconnect 
    // ============================================
    
    
    wb_intercon wb_intercon_inst (
        .wb_clk_i(clk),
        .wb_rst_i(~reset_n),

        .wb_io_adr_i   (wb_adr_o),
        .wb_io_dat_i   (wb_dat_o),
        .wb_io_sel_i   (wb_sel_o),
        .wb_io_we_i    (wb_we_o),
        .wb_io_cyc_i   (wb_cyc_o),
        .wb_io_stb_i   (wb_stb_o),
        .wb_io_cti_i   (3'b000),
        .wb_io_bte_i   (2'b00),
        .wb_io_dat_o   (wb_dat_i_cpu),  //check signal 
        .wb_io_ack_o   (wb_ack_i_cpu), 

        .wb_dmem_adr_o (wb_m2s_dmem_adr_o),
        .wb_dmem_dat_o (wb_m2s_dmem_dat_o),
        .wb_dmem_sel_o (wb_m2s_dmem_sel_o),
        .wb_dmem_we_o  (wb_m2s_dmem_we_o),
        .wb_dmem_cyc_o (wb_m2s_dmem_cyc_o),
        .wb_dmem_stb_o (wb_m2s_dmem_stb_o),
        .wb_dmem_cti_o (),
        .wb_dmem_bte_o (),
        .wb_dmem_dat_i (wb_s2m_dat_i_dmem),
        .wb_dmem_ack_i (wb_s2m_ack_i_dmem),
        .wb_dmem_err_i (1'b0),
        .wb_dmem_rty_i (1'b0),

        .wb_imem_adr_o (wb_m2s_imem_adr),
        .wb_imem_dat_o (wb_m2s_imem_dat),
        .wb_imem_sel_o (wb_m2s_imem_sel),
        .wb_imem_we_o  (wb_m2s_imem_we),
        .wb_imem_cyc_o (wb_m2s_imem_cyc),
        .wb_imem_stb_o (wb_m2s_imem_stb),
        .wb_imem_cti_o (),
        .wb_imem_bte_o (),
        .wb_imem_dat_i (wb_s2m_imem_dat),
        .wb_imem_ack_i (wb_s2m_imem_ack),
        .wb_imem_err_i (1'b0),
        .wb_imem_rty_i (1'b0),

        .wb_gpio_adr_o   (wb_m2s_gpio_adr_i),
        .wb_gpio_dat_o   (wb_m2s_gpio_dat_i),
        .wb_gpio_sel_o   (wb_m2s_gpio_sel_i),
        .wb_gpio_we_o    (wb_m2s_gpio_we_i),
        .wb_gpio_cyc_o   (wb_m2s_gpio_cyc_i),
        .wb_gpio_stb_o   (wb_m2s_gpio_stb_i),
        .wb_gpio_cti_o   (),
        .wb_gpio_bte_o   (),
        .wb_gpio_dat_i   (wb_dat_i_gpio),
        .wb_gpio_ack_i   (wb_ack_i_gpio),
        .wb_gpio_err_i   (1'b0),
        .wb_gpio_rty_i   (1'b0)
    );


    // ============================================
    //                   Peripherals 
    // ============================================
    // Instantate the peripherals here

    // Here is the tri state buffer logic for setting iopin as input or output based
    // on the bits stored in the en_gpio register


genvar i;
generate
    for (i = 0; i < 32; i = i + 1) begin: gpio_gen_loop
        bidirec gpio1 (
            .oe   (en_gpio[i]),
            .inp  (o_gpio[i]),
            .outp (i_gpio[i]),
            .bidir(io_data[i])
        );
    end
endgenerate
    // ============================================
    //                 GPIO Instantiation
    // ============================================

    logic [7:0] wb_m2s_gpio_adr_i_8;
    assign wb_m2s_gpio_adr_i_8 =  wb_m2s_gpio_adr_i[7:0];
    
    gpio_top #(
        .dw(32),
        .aw(`GPIO_ADDRHH + 1),
        .gw(`GPIO_IOS)
    ) gpio_inst (
        .wb_clk_i   (clk),
        .wb_rst_i   (~reset_n),
        .wb_cyc_i   (wb_m2s_gpio_cyc_i),
        .wb_adr_i   (wb_m2s_gpio_adr_i_8),
        .wb_dat_i   (wb_m2s_gpio_dat_i),
        .wb_sel_i   (wb_m2s_gpio_sel_i),
        .wb_we_i    (wb_m2s_gpio_we_i),
        .wb_stb_i   (wb_m2s_gpio_stb_i),
        .wb_dat_o   (wb_dat_i_gpio),
        .wb_ack_o   (wb_ack_i_gpio),
        .wb_err_o   (),
        .i_gpio     (i_gpio),
        .o_gpio     (o_gpio),
        .en_gpio    (en_gpio)
    );


    // ============================================
    //             Data Memory Instance
    // ============================================
    
    data_mem #(.DEPTH(DMEM_DEPTH)) data_mem_inst (
        .clk_i(clk),
        .rst_i(~reset_n),
        .cyc_i(wb_m2s_dmem_cyc_o),
        .stb_i(wb_m2s_dmem_stb_o),
        .adr_i(wb_m2s_dmem_adr_o),
        .we_i (wb_m2s_dmem_we_o),
        .sel_i(wb_m2s_dmem_sel_o),
        .dat_i(wb_m2s_dmem_dat_o),
        .dat_o(wb_s2m_dat_i_dmem),
        .ack_o(wb_s2m_ack_i_dmem)
    );

    
    assign imem_addr = sel_boot_rom ? wb_m2s_imem_adr : current_pc;

    // ============================================
    //          Instruction Memory Instance
    // ============================================
    
    data_mem #(.DEPTH(IMEM_DEPTH)
    ) inst_mem_inst (
        .clk_i       (clk),
        .rst_i       (~reset_n),
        .cyc_i       (wb_m2s_imem_cyc), 
        .stb_i       (wb_m2s_imem_stb),
        .adr_i       (imem_addr),
        .we_i        (wb_m2s_imem_we),
        .sel_i       (wb_m2s_imem_sel),
        .dat_i       (wb_m2s_imem_dat),
        .dat_o       (wb_s2m_imem_dat),
        .ack_o       (wb_s2m_imem_ack)
    );

    assign imem_inst = wb_s2m_imem_dat;

    rom rom_instance(
        .addr     (current_pc[11:0]),
        .inst     (rom_inst)
    );
    
    // register after boot rom (to syncronize with the pipeline and inst mem)
    n_bit_reg #(.n(32)) rom_inst_reg (
        .clk(clk),
        .reset_n(reset_n),
        .data_i(rom_inst),
        .data_o(rom_inst_ff),
        .wen(if_id_reg_en)
    );

assign sel_boot_rom = current_pc[31:28] == 4'hF; 
    always @(posedge clk) sel_boot_rom_ff <= sel_boot_rom;

    // Inst selection mux
    mux2x1 #(.n(32)) rom_imem_inst_sel_mux (
        .in0    (imem_inst),
        .in1    (rom_inst_ff),
        .sel    (sel_boot_rom_ff),
        .out    (inst)
    );

endmodule : rv32i_soc


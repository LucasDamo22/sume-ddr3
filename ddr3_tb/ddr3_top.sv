module top(
    input logic FPGA_SYSCLK_N,
    input logic FPGA_SYSCLK_P,
    input logic reset,

    output wire init_calib_complete
);

logic clock_ref;
clk_wiz_0 magodoclock (
    // Clock out ports
    .clk_out1(clock_ref),     // output clk_out1
   // Clock in ports
    .clk_in1_p(FPGA_SYSCLK_P),    // input clk_in1_p
    .clk_in1_n(FPGA_SYSCLK_N)    // input clk_in1_n
);

logic [29:0] app_addr;
logic [2:0] app_cmd;
logic       app_en;
logic [255:0] app_wdf_data;
logic         app_wdf_end;
logic         app_wdf_wren;
logic [255:0] app_rd_data;
logic         app_rd_data_end;
logic         app_rd_data_valid;
logic         app_rdy;
logic         app_wdf_rdy;
logic         app_sr_req;
logic         app_ref_req;
logic         app_zq_req;
logic         app_sr_active;
logic         app_ref_ack;
logic         app_zq_ack;
logic         ui_clk;
logic         ui_clk_sync_rst;
logic [31:0]  app_wdf_mask;

wire logic [15:0] ddr3_addr;
wire logic [2:0] ddr3_ba;
wire logic  ddr3_cas_n;
wire logic  ddr3_ck_n;
wire logic  ddr3_ck_p;
wire logic  ddr3_cke;
wire logic  ddr3_ras_n;
wire logic  ddr3_reset_n;
wire logic  ddr3_we_n;
wire logic [63:0] ddr3_dq;
wire logic [7:0] ddr3_dqs_n;
wire logic [7:0] ddr3_dqs_p;

wire logic ddr3_cs_n;
wire logic [7:0]ddr3_dm;
wire logic ddr3_odt;


assign app_addr = '0;
assign app_cmd = '0;
assign app_en = '0;
assign app_wdf_data = '0;
assign app_wdf_end = '0;
assign app_wdf_wren = '0;
assign app_sr_req = '0;
assign app_ref_req = '0;
assign app_zq_req = '0;
assign app_wdf_mask = '0;


mig_7series_0 u_mig_7series_0 (

    // Memory interface ports
    .ddr3_addr                      (ddr3_addr),  // output [15:0]		ddr3_addr
    .ddr3_ba                        (ddr3_ba),  // output [2:0]		ddr3_ba
    .ddr3_cas_n                     (ddr3_cas_n),  // output			ddr3_cas_n
    .ddr3_ck_n                      (ddr3_ck_n),  // output [0:0]		ddr3_ck_n
    .ddr3_ck_p                      (ddr3_ck_p),  // output [0:0]		ddr3_ck_p
    .ddr3_cke                       (ddr3_cke),  // output [0:0]		ddr3_cke
    .ddr3_ras_n                     (ddr3_ras_n),  // output			ddr3_ras_n
    .ddr3_reset_n                   (ddr3_reset_n),  // output			ddr3_reset_n
    .ddr3_we_n                      (ddr3_we_n),  // output			ddr3_we_n
    .ddr3_dq                        (ddr3_dq),  // inout [63:0]		ddr3_dq
    .ddr3_dqs_n                     (ddr3_dqs_n),  // inout [7:0]		ddr3_dqs_n
    .ddr3_dqs_p                     (ddr3_dqs_p),  // inout [7:0]		ddr3_dqs_p
    .init_calib_complete            (init_calib_complete),  // output			init_calib_complete
      
	.ddr3_cs_n                      (ddr3_cs_n),  // output [0:0]		ddr3_cs_n
    .ddr3_dm                        (ddr3_dm),  // output [7:0]		ddr3_dm
    .ddr3_odt                       (ddr3_odt),  // output [0:0]		ddr3_odt
    // Application interface ports
    .app_addr                       (app_addr),  // input [29:0]		app_addr
    .app_cmd                        (app_cmd),  // input [2:0]		app_cmd
    .app_en                         (app_en),  // input				app_en
    .app_wdf_data                   (app_wdf_data),  // input [511:0]		app_wdf_data
    .app_wdf_end                    (app_wdf_end),  // input				app_wdf_end
    .app_wdf_wren                   (app_wdf_wren),  // input				app_wdf_wren
    .app_rd_data                    (app_rd_data),  // output [511:0]		app_rd_data
    .app_rd_data_end                (app_rd_data_end),  // output			app_rd_data_end
    .app_rd_data_valid              (app_rd_data_valid),  // output			app_rd_data_valid
    .app_rdy                        (app_rdy),  // output			app_rdy
    .app_wdf_rdy                    (app_wdf_rdy),  // output			app_wdf_rdy
    .app_sr_req                     (app_sr_req),  // input			app_sr_req
    .app_ref_req                    (app_ref_req),  // input			app_ref_req
    .app_zq_req                     (app_zq_req),  // input			app_zq_req
    .app_sr_active                  (app_sr_active),  // output			app_sr_active
    .app_ref_ack                    (app_ref_ack),  // output			app_ref_ack
    .app_zq_ack                     (app_zq_ack),  // output			app_zq_ack
    .ui_clk                         (ui_clk),  // output			ui_clk
    .ui_clk_sync_rst                (ui_clk_sync_rst),  // output			ui_clk_sync_rst
    .app_wdf_mask                   (app_wdf_mask),  // input [63:0]		app_wdf_mask
    // System Clock Ports
    .sys_clk_p                       (sys_clk_p),  // input				sys_clk_p
    .sys_clk_n                       (sys_clk_n),  // input				sys_clk_n
    // Reference Clock Ports
    .clk_ref_i                      (clock_ref),
    .sys_rst                        (!reset) // input sys_rst
    );

endmodule
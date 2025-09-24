`timescale 1ps/1ps

module ddr3_tb (

);


logic sys_clk_n, sys_clk_p; 
logic clk_ref_n, clk_ref_p;

logic reset;

logic clk_ref_i;

initial begin
    sys_clk_n = 0;
    sys_clk_p = 1;
    clk_ref_n = 0;
    clk_ref_p = 1;
end

initial begin
    reset = 1;
    #3000ns reset = 0;
end

always begin
    #(2500ps) clk_ref_n = !clk_ref_n; 
    #(2500ps) clk_ref_n = !clk_ref_n; 
end

always begin
    #(2500ps) clk_ref_p = !clk_ref_p; 
    #(2500ps) clk_ref_p = !clk_ref_p; 
end


always begin
    #(2145ps) sys_clk_n = !sys_clk_n; 
    #(2145ps) sys_clk_n = !sys_clk_n; 
end

always begin
    #(2145ps) sys_clk_p = !sys_clk_p; 
    #(2145ps) sys_clk_p = !sys_clk_p; 
end


wire [63:0]  ddr3_dq;
wire [7:0]   ddr3_dqs_n;
wire [7:0]   ddr3_dqs_p;
wire [15:0] ddr3_addr;
wire [2:0]  ddr3_ba;
wire        ddr3_ras_n;
wire        ddr3_cas_n;
wire        ddr3_we_n;
wire        ddr3_reset_n;
wire [0:0]  ddr3_ck_p;
wire [0:0]  ddr3_ck_n;
wire [0:0]  ddr3_cke;
wire [0:0]  ddr3_cs_n;
wire [7:0]  ddr3_dm;
wire [0:0]  ddr3_odt;
logic init_calib_complete;

top dut (

    .sys_clk_p(sys_clk_p),
    .sys_clk_n(sys_clk_n),
    .clk_ref_p(clk_ref_p),
    .clk_ref_n(clk_ref_n),
    .reset(reset),

    .ddr3_dq(ddr3_dq),
    .ddr3_dqs_n(ddr3_dqs_n),
    .ddr3_dqs_p(ddr3_dqs_p),
    .ddr3_addr(ddr3_addr),
    .ddr3_ba(ddr3_ba),
    .ddr3_ras_n(ddr3_ras_n),
    .ddr3_cas_n(ddr3_cas_n),
    .ddr3_we_n(ddr3_we_n),
    .ddr3_reset_n(ddr3_reset_n),
    .ddr3_ck_p(ddr3_ck_p),
    .ddr3_ck_n(ddr3_ck_n),
    .ddr3_cke(ddr3_cke),
    .ddr3_cs_n(ddr3_cs_n),
    .ddr3_dm(ddr3_dm),
    .ddr3_odt(ddr3_odt),
    .init_calib_complete(init_calib_complete)
    
);


    for (genvar i = 0; i < 8; i = i + 1) begin: gen_mem
        ddr3_model u_comp_ddr3
          (
           .rst_n   (ddr3_reset_n),
           .ck      (ddr3_ck_p),
           .ck_n    (ddr3_ck_n),
           .cke     (ddr3_cke),
           .cs_n    (ddr3_cs_n),
           .ras_n   (ddr3_ras_n),
           .cas_n   (ddr3_cas_n),
           .we_n    (ddr3_we_n),
           .dm_tdqs (ddr3_dm[i]),
           .ba      (ddr3_ba),
           .addr    (ddr3_addr),
           .dq      (ddr3_dq[8*(i+1)-1:8*(i)]),
           .dqs     (ddr3_dqs_p[i]),
           .dqs_n   (ddr3_dqs_n[i]),
           .tdqs_n  (),
           .odt     (ddr3_odt)
           );
      end

endmodule
module top(
    // System Clocks and Reset
    input logic sys_clk_p,
    input logic sys_clk_n,
    input logic clk_ref_p,
    input logic clk_ref_n,
    input logic reset, // the board has an active high connected, but the mig is active low

    // DDR3 Physical Interface
    inout wire [63:0]  ddr3_dq,
    inout wire [7:0]   ddr3_dqs_n,
    inout wire [7:0]   ddr3_dqs_p,
    output wire [15:0] ddr3_addr,
    output wire [2:0]  ddr3_ba,
    output wire        ddr3_ras_n,
    output wire        ddr3_cas_n,
    output wire        ddr3_we_n,
    output wire        ddr3_reset_n,
    output wire [0:0]  ddr3_ck_p,
    output wire [0:0]  ddr3_ck_n,
    output wire [0:0]  ddr3_cke,
    output wire [0:0]  ddr3_cs_n,
    output wire [7:0]  ddr3_dm,
    output wire [0:0]  ddr3_odt,

    // Status Outputs
    output logic init_calib_complete,
    output logic test_pass
);
localparam ROM_SIZE = 32;

// MIG User Interface Signals
logic [29:0]  app_addr;
// app cmd 000 write / 001 read
logic [2:0]   app_cmd;
logic         app_en;
logic [511:0] app_wdf_data;
logic         app_wdf_wren_end;
logic         app_wdf_wren;
logic [511:0] app_rd_data;
logic         app_rd_data_end;
logic         app_rd_data_valid;
logic         app_rdy;
logic         app_wdf_rdy;
logic         ui_clk;
logic         ui_clk_sync_rst;
logic [63:0]  app_wdf_mask;


// State machine definition
typedef enum logic [7:0] {
    S_IDLE,
    S_WRITE_DATA,
    S_GET_ROM_DATA,
    S_WAIT_ROM_DATA,
    S_WAIT_GAP,
    S_READ_DATA,
    S_ZERO_COUNTER,
    S_GET_ROM_DATA_READ,
    S_ZERO_COUNTER_2,
    S_READ_REQ,
    S_VERIFY,
    S_PASS,
    S_FAIL
} state_t;

state_t current_state, next_state;

localparam BURST_LEN   = 16; 
localparam TEST_ADDR   = 30'h0000_1000;

logic [511:0] rom_data_o;
logic [511:0] compare_data;
//logic [29:0] addr_reg;
logic [4:0] rom_addr;
logic [15:0] op_counter;

// State Register: All logic driven by ui_clk and ui_clk_sync_rst from MIG
always_ff @(posedge ui_clk) begin
    if (ui_clk_sync_rst) begin
        current_state <= S_IDLE;
    end else begin
        current_state <= next_state;
    end
end

// always_ff @(posedge ui_clk) begin
//     if (ui_clk_sync_rst) begin
       
//     end else begin
       
//     end
// end

assign test_pass = (current_state == S_PASS);

assign app_wdf_mask = '0;
assign app_wdf_wren = (current_state == S_WRITE_DATA) && app_rdy;
assign app_wdf_wren_end = (current_state == S_WRITE_DATA) && app_rdy;

assign app_cmd = (current_state == S_READ_REQ)   ? 3'b001 : 3'b000;

assign app_en = (current_state == S_WRITE_DATA) || (current_state == S_READ_REQ);

always_ff@(posedge ui_clk) begin
    if(ui_clk_sync_rst) begin
        app_addr <= '0;
    end else begin
        unique case(current_state)
            S_IDLE:         app_addr <= '0;
            S_GET_ROM_DATA: app_addr <= app_addr + 30'd8;
            S_WAIT_GAP:     app_addr <= '0;
            S_ZERO_COUNTER: app_addr <= '0;
            S_GET_ROM_DATA_READ: app_addr <= app_addr + 30'd8;
            default: ;
        endcase
    end
end

always_ff@(posedge ui_clk) begin 
    if(ui_clk_sync_rst) begin
        rom_addr <= '0;
    end else begin
        unique case (current_state)
            S_IDLE:         rom_addr <= '0;
            S_GET_ROM_DATA: rom_addr <= rom_addr + 1'b1;
            S_WAIT_GAP:     rom_addr <= '0;
            S_ZERO_COUNTER: rom_addr <= '0;
            S_GET_ROM_DATA_READ: rom_addr <= rom_addr + 1'b1;
            default: ;
        endcase
    end
end

always_ff@(posedge ui_clk) begin 
    if(ui_clk_sync_rst) begin
        op_counter <= '0;
    end else begin
        unique case (current_state)
            S_IDLE:         op_counter <= '0;
            S_GET_ROM_DATA: op_counter <= op_counter + 1'b1;
            S_ZERO_COUNTER: op_counter <= '0;
            S_ZERO_COUNTER_2: op_counter <= '0;
            S_WAIT_GAP:     op_counter <= op_counter + 1'b1;
            S_GET_ROM_DATA_READ: op_counter <= op_counter + 1'b1;
            default: ;
        endcase
    end
end

always_ff@(posedge ui_clk) begin
    if(ui_clk_sync_rst) begin
        compare_data <='0;
    end else begin
        unique case(current_state)
            S_READ_DATA: compare_data <= app_rd_data;
            default: ;
        endcase 
    end
end

logic current_fail;
assign current_fail = (rom_data_o != compare_data);

logic prev_fail;
always_ff@(posedge ui_clk) begin
    if(ui_clk_sync_rst) begin
        prev_fail <= '0;
    end else begin 
        unique case(current_state)
            S_VERIFY: prev_fail <= current_fail;
            default: ;
        endcase 
    end
end
logic fail;
assign fail = (prev_fail || current_fail);

// Combinational Logic: State transitions and MIG interface control
always_comb begin
    case(current_state)
        S_IDLE: begin
            if(init_calib_complete)
                next_state = S_WRITE_DATA;
            else
                next_state = S_IDLE;
        end
        S_WRITE_DATA: begin
            if(app_rdy && app_wdf_rdy) begin
                if(op_counter >= (ROM_SIZE-1))
                    next_state = S_WAIT_GAP;
                else
                    next_state = S_GET_ROM_DATA;
            end else begin
                next_state = S_WRITE_DATA;
            end
        end
        S_GET_ROM_DATA: begin
            next_state = S_WAIT_ROM_DATA;
        end
        S_WAIT_ROM_DATA: next_state = S_WRITE_DATA;

        
        S_ZERO_COUNTER: begin
            next_state = S_WAIT_GAP;
        end
        S_WAIT_GAP: begin
            if(op_counter > 16'd500)
                next_state = S_ZERO_COUNTER_2;
            else 
                next_state = S_WAIT_GAP;
        end
        S_ZERO_COUNTER_2: begin
            next_state = S_READ_REQ;
        end
        S_READ_REQ: begin
            if(app_rdy)
                next_state = S_READ_DATA;
            else
                next_state = S_READ_REQ;
        end
        S_READ_DATA: begin
            if(app_rd_data_valid) begin
                next_state = S_VERIFY;
            end else
                next_state = S_READ_DATA;
        end
        S_VERIFY: begin
            if(fail) begin
                next_state = S_FAIL;
            end else if (op_counter >= (ROM_SIZE-1)) begin
                next_state = S_PASS;
            end else
                next_state = S_GET_ROM_DATA_READ;
        end
        S_GET_ROM_DATA_READ: begin
            next_state = S_READ_REQ;
        end
        S_PASS:
            next_state = S_PASS;
        S_FAIL:
            next_state = S_IDLE;

        default: next_state = S_IDLE;
    endcase
end

rom rom(
    .clk(ui_clk),
    .reset(!reset),
    .addr(rom_addr),
    .data_o(rom_data_o)
);

// MIG Instantiation
mig_7series_0 u_mig_7series_0 (
    // Memory interface ports
  .ddr3_addr                      (ddr3_addr),
  .ddr3_ba                        (ddr3_ba),
  .ddr3_cas_n                     (ddr3_cas_n),
  .ddr3_ck_n                      (ddr3_ck_n),
  .ddr3_ck_p                      (ddr3_ck_p),
  .ddr3_cke                       (ddr3_cke),
  .ddr3_ras_n                     (ddr3_ras_n),
  .ddr3_reset_n                   (ddr3_reset_n),
  .ddr3_we_n                      (ddr3_we_n),
  .ddr3_dq                        (ddr3_dq),
  .ddr3_dqs_n                     (ddr3_dqs_n),
  .ddr3_dqs_p                     (ddr3_dqs_p),
  .init_calib_complete            (init_calib_complete),
  .ddr3_cs_n                      (ddr3_cs_n),
  .ddr3_dm                        (ddr3_dm),
  .ddr3_odt                       (ddr3_odt),
    
    // Application interface ports
  .app_addr                       (app_addr),  // input [29:0]		app_addr
  .app_cmd                        (app_cmd),  // input [2:0]		app_cmd
  .app_en                         (app_en),  // input				app_en
  .app_wdf_data                   (rom_data_o),  // input [511:0]		app_wdf_data
  .app_wdf_end                    (app_wdf_wren_end),  // input				app_wdf_end
  .app_wdf_wren                   (app_wdf_wren),  // input				app_wdf_wren
  .app_rd_data                    (app_rd_data),  // output [511:0]		app_rd_data
  .app_rd_data_end                (app_rd_data_end),  // output			app_rd_data_end
  .app_rd_data_valid              (app_rd_data_valid),  // output			app_rd_data_valid
  .app_rdy                        (app_rdy),  // output			app_rdy
  .app_wdf_rdy                    (app_wdf_rdy),  // output			app_wdf_rdy
  .app_sr_req                     (1'b0),  // input			 // Tie unused maintenance ports to 0
  .app_ref_req                    (1'b0),  // input			
  .app_zq_req                     (1'b0),  // input			
  .app_sr_active                  (a),  // output			app_sr_active
  .app_ref_ack                    (a),  // output			app_ref_ack
  .app_zq_ack                     (a),  // output			app_zq_ack
  .ui_clk                         (ui_clk),  // output			ui_clk
  .ui_clk_sync_rst                (ui_clk_sync_rst),  // output			ui_clk_sync_rst
  .app_wdf_mask                   (app_wdf_mask),  // input [63:0]		app_wdf_mask
    
    // System Clock Ports
  .sys_clk_p                      (sys_clk_p),
  .sys_clk_n                      (sys_clk_n),
    
    // Reference Clock Ports
  .clk_ref_p                      (clk_ref_p),
  .clk_ref_n                      (clk_ref_n),
    
   // the board has an active high connected, but the mig is active low
  .sys_rst                        (!reset) 
);

endmodule
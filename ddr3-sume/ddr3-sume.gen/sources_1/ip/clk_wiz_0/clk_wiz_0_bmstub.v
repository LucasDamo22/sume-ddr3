// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// -------------------------------------------------------------------------------

`timescale 1 ps / 1 ps

(* BLOCK_STUB = "true" *)
module clk_wiz_0 (
  clk_in1_p,
  clk_in1_n,
  clk_out1
);

  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 CLK_IN1_D CLK_P" *)
  (* X_INTERFACE_MODE = "slave CLK_IN1_D" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK_IN1_D, BOARD.ASSOCIATED_PARAM CLK_IN1_BOARD_INTERFACE, CAN_DEBUG false, FREQ_HZ 100000000" *)
  input clk_in1_p;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 CLK_IN1_D CLK_N" *)
  input clk_in1_n;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clock_CLK_OUT1 CLK_OUT1" *)
  (* X_INTERFACE_MODE = "master clock_CLK_OUT1" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clock_CLK_OUT1, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN , ASSOCIATED_BUSIF , ASSOCIATED_PORT , ASSOCIATED_RESET , INSERT_VIP 0" *)
  output clk_out1;

  // stub module has no contents

endmodule

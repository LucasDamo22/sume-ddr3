set_property SRC_FILE_INFO {cfile:/sim/freq-test/ddr3-pack/ddr3-sume/ddr3-sume.gen/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc rfile:../../../ddr3-sume.gen/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
current_instance inst
set_property src_info {type:SCOPED_XDC file:1 line:54 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1_p]] 0.050

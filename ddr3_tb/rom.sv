module rom (
    input logic clk,
    input reset,
    input logic [4:0] addr,
    output logic [511:0] data_o
);

// A constant 32x512-bit array initialized with random values.
logic [511:0] rom_data[0:31];

assign rom_data[0] =  512'hDEAD_BEEF_DEAD_BEEF_DEAD_BEEF_DEAD_BEEF_DEAD_BEEF_DEAD_BEEF_DEAD_BEEF_DEAD_BEEF;
assign rom_data[1] =  512'h8f7e_1a2b_3c4d_5e6f_7a8b_9c0d_1e2f_3a4b_5c6d_7e8f_9a0b_1c2d_3e4f_5a6b_7c8d_9e0f;
assign rom_data[2] =  512'ha1b2_c3d4_e5f6_a7b8_c9d0_e1f2_a3b4_c5d6_e7f8_a9b0_c1d2_e3f4_a5b6_c7d8_e9f0_a1b2;
assign rom_data[3] =  512'h5d6e_7f8a_9b0c_1d2e_3f4a_5b6c_7d8e_9f0a_1b2c_3d4e_5f6a_7b8c_9d0e_1f2a_3b4c_5d6e;
assign rom_data[4] =  512'hf0e1_d2c3_b4a5_9687_f8e9_dacf_bbed_aadc_9876_fedc_ba98_7654_3210_fedc_ba98_7654;
assign rom_data[5] =  512'h6a7b_8c9d_0e1f_2a3b_4c5d_6e7f_8a9b_0c1d_2e3f_4a5b_6c7d_8e9f_0a1b_2c3d_4e5f_6a7b;
assign rom_data[6] =  512'h1122_3344_5566_7788_99aa_bbcc_ddee_ff00_1234_5678_9abc_def0_1122_3344_5566_7788;
assign rom_data[7] =  512'h239a_847d_bf6c_e15a_d0b9_c8f6_e52a_1b4d_c9f8_e76a_5b2d_4e1c_3a0f_9b8d_7e6c_5a4b;
assign rom_data[8] =  512'h9d8c_7b6a_5f4e_3d2c_1b0a_f9e8_d7c6_b5a4_9f8e_7d6c_5b4a_3f2e_1d0c_fb9a_8e7d_6c5b;
assign rom_data[9] =  512'h4e5f_6a7b_8c9d_0e1f_2a3b_4c5d_6e7f_8a9b_0c1d_2e3f_4a5b_6c7d_8e9f_0a1b_2c3d_4e5f;
assign rom_data[10] =  512'hDEAD_BEEF_DEAD_BEEF_DEAD_BEEF_DEAD_BEEF_DEAD_BEEF_DEAD_BEEF_DEAD_BEEF_DEAD_BEEF;
assign rom_data[11] =  512'hdead_beef_cafe_babe_1234_5678_90ab_cdef_fedc_ba09_8765_4321_babe_cafe_beef_dead;
assign rom_data[12] =  512'h8877_6655_4433_2211_00ff_eedd_ccbb_aa99_1122_3344_5566_7788_99aa_bbcc_ddee_ff00;
assign rom_data[13] =  512'h1a0b_2938_47d6_c5f4_e3b2_a1c0_d9f8_e76a_5b4d_3c2e_1f0a_9b8c_7d6e_5f4a_3b2c_1d0e;
assign rom_data[14] =  512'h55aa_ff00_aacc_ffdd_ee11_bb22_9933_8844_7755_66aa_eeff_1122_3344_5566_7788_99aa;
assign rom_data[15] =  512'h0f1e_2d3c_4b5a_6978_f0e1_d2c3_b4a5_9687_e9d8_c7b6_a5f4_e3d2_c1b0_a9f8_e7d6_c5b4;
assign rom_data[16] =  512'hb4a5_c6d7_e8f9_a0b1_c2d3_e4f5_a6b7_c8d9_e0f1_a2b3_c4d5_e6f7_a8b9_c0d1_e2f3_a4b5;
assign rom_data[17] =  512'h1029_3847_56f6_e5d4_c3b2_a190_8f7e_6d5c_4b3a_2918_07f6_e5d4_c3b2_a190_8f7e_6d5c;
assign rom_data[18] =  512'h6c5b_4a3f_2e1d_0cfb_9a8e_7d6c_5b4a_3f2e_1d0c_fb9a_8e7d_6c5b_4a3f_2e1d_0cfb_9a8e;
assign rom_data[19] =  512'h6655_4433_2211_00ff_eedd_ccbb_aa99_8877_6655_4433_2211_00ff_eedd_ccbb_aa99_8877;
assign rom_data[20] =  512'h7e8f_9a0b_1c2d_3e4f_5a6b_7c8d_9e0f_a1b2_c3d4_e5f6_a7b8_c9d0_e1f2_a3b4_c5d6_e7f8;
assign rom_data[21] =  512'h9081_7263_54f5_e6d7_c8b9_a091_8273_64f5_e6d7_c8b9_a091_8273_64f5_e6d7_c8b9_a091;
assign rom_data[22] =  512'h0011_2233_4455_6677_8899_aabb_ccdd_eeff_ffaa_cc88_6644_2200_1133_5577_99bb_ddee;
assign rom_data[23] =  512'hc3b2_a190_8f7e_6d5c_4b3a_2918_07f6_e5d4_c3b2_a190_8f7e_6d5c_4b3a_2918_07f6_e5d4;
assign rom_data[24] =  512'hefcd_ab98_7654_3210_fedc_ba98_7654_3210_0123_4567_89ab_cdef_0123_4567_89ab_cdef;
assign rom_data[25] =  512'h5a4b_3c2d_1f0e_9b8c_7d6a_5f4e_3c2d_1b0a_f9e8_d7c6_b5a4_9f8e_7d6c_5b4a_3f2e_1d0c;
assign rom_data[26] =  512'h1357_9bdf_0246_8ace_eca8_6420_fdb9_7531_dfac_8642_0eca_8642_0fdb_9753_1eca_8642;
assign rom_data[27] =  512'hba98_7654_3210_fedc_ba98_7654_3210_fedc_ba98_7654_3210_fedc_ba98_7654_3210_fedc;
assign rom_data[28] =  512'h2d1c_0b9a_8f7e_6d5c_4b3a_2918_07f6_e5d4_c3b2_a190_8f7e_6d5c_4b3a_2918_07f6_e5d4;
assign rom_data[29] =  512'h6655_4433_2211_00ff_eedd_ccbb_aa99_8877_6655_4433_2211_00ff_eedd_ccbb_aa99_8877;
assign rom_data[30] =  512'ha5b4_c3d2_e1f0_a9b8_c7d6_e5f4_a3b2_c1d0_e9f8_a7b6_c5d4_e3f2_a1b0_c9d8_e7f6_a5b4;
assign rom_data[31] =  512'h789a_bcde_f012_3456_789a_bcde_f012_3456_89ab_cdef_0123_4567_89ab_cdef_0123_4567;

always_ff@(posedge clk or negedge reset) begin
    if(!reset) begin
        data_o <= '0;
    end else begin
        data_o <= rom_data[addr];
    end
    
end
endmodule
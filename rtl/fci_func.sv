module fci_func (
  input logic [63:0] ci,
  input logic [63:0] iword,
  output logic [63:0] oword
);
  logic [63:0] xor_res;
  logic [63:0] p8_res;
  assign xor_res = ci ^ iword;
  genvar i;
  generate
      for (i = 0; i < 8; i++) begin : p_loop
          p_module p_perm (
              .x (xor_res[i*8 +: 8]),   // 8 бит начиная с позиции i*8
              .y(p8_res[i*8 +: 8])
          );
      end
  endgenerate
  assign oword = {p8_res[63], p8_res[55], p8_res[47], p8_res[39], p8_res[31], p8_res[23], p8_res[15], p8_res[7], 
            p8_res[62], p8_res[54], p8_res[46], p8_res[38], p8_res[30], p8_res[22], p8_res[14], p8_res[6], 
            p8_res[61], p8_res[53], p8_res[45], p8_res[37], p8_res[29], p8_res[21], p8_res[13], p8_res[5], 
            p8_res[60], p8_res[52], p8_res[44], p8_res[36], p8_res[28], p8_res[20], p8_res[12], p8_res[4], 
            p8_res[59], p8_res[51], p8_res[43], p8_res[35], p8_res[27], p8_res[19], p8_res[11], p8_res[3], 
            p8_res[58], p8_res[50], p8_res[42], p8_res[34], p8_res[26], p8_res[18], p8_res[10], p8_res[2], 
            p8_res[57], p8_res[49], p8_res[41], p8_res[33], p8_res[25], p8_res[17], p8_res[9], p8_res[1], 
            p8_res[56], p8_res[48], p8_res[40], p8_res[32], p8_res[24], p8_res[16], p8_res[8], p8_res[0]}; //64

endmodule


module enc_round (
  input  logic [63:0] idata,
  output logic [63:0] odata
);
  
  // 2. 4 экземпляра M-функции (каждая на 16 бит)
  logic [63:0] after_m;
  
  genvar i;
  generate
    for (i = 0; i < 4; i++) begin : m_blocks
      m_module m_inst (
        .x (idata[i*16 +: 16]),    // 16 бит
        .y (after_m[i*16 +: 16])       // 16 бит результата
      );
    end
  endgenerate
  
  // 3. Перестановка байтов (64-битная)
  // r63..56||r47..40||r31..24||r15..8||r55..48||r39..32||r23..16||r7..0
  assign odata = {
    after_m[63:56],   // байт 7
    after_m[47:40],   // байт 5
    after_m[31:24],   // байт 3
    after_m[15:8],    // байт 1
    after_m[55:48],   // байт 6
    after_m[39:32],   // байт 4
    after_m[23:16],   // байт 2
    after_m[7:0]      // байт 0
  };

endmodule

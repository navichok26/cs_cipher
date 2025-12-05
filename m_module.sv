
module m_module (
  input  logic [15:0] x,
  output logic [15:0] y
);

  logic [7:0] xl, xr, phi_xl, rotl_xl, xor_xl, xor_xr;
  assign xl = x[15:8];  // старший байт
  assign xr = x[7:0];   // младший байт

  assign phi_xl = {xl[7], xl[6] ^ xl[5], xl[5],xl[4] ^ xl[3], xl[3], xl[2] ^ xl[1], xl[1],xl[0] ^ xl[7]};

  assign rotl_xl = {xl[6:0], xl[7]};

  logic [7:0] p_out1, p_out2;

   // yl = P(φ(xl) ^ xr)
  p_module p1 (
    .x (phi_xl ^ xr),
    .y (p_out1)
  );
  
  // yr = P(Rl(xl) ^ xr)
  p_module p2 (
    .x (rotl_xl ^ xr),
    .y (p_out2)
  );
  
  // Собираем результат: y = yl || yr
  assign y = {p_out1, p_out2};

endmodule


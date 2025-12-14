module round (
  input  logic [63:0] data_in,
  input  logic [63:0] subkey,
  output logic [63:0] data_out
);
  
  // Обычные переменные вместо localparam
  logic [63:0] CONSTANTS [0:1];
  
  // Инициализация констант
  initial begin
    CONSTANTS[0] = 64'hb7e151628aed2a6a;  // c
    CONSTANTS[1] = 64'hbf7158809cf4f3c7;  // c_
  end
  
  // Вместо generate используем последовательные вычисления
  logic [63:0] round1_in, round1_out;
  logic [63:0] round2_in, round2_out;
  logic [63:0] round3_in, round3_out;
  
  // Раунд 1: XOR с ключом
  assign round1_in = data_in ^ subkey;
  
  // Раунд 2: XOR с константой c
  assign round2_in = round1_out ^ CONSTANTS[0];
  
  // Раунд 3: XOR с константой c_
  assign round3_in = round2_out ^ CONSTANTS[1];
  
  // Инстансы enc_round
  enc_round round1_inst (
    .idata   (round1_in),
    .odata   (round1_out)
  );
  
  enc_round round2_inst (
    .idata   (round2_in),
    .odata   (round2_out)
  );
  
  enc_round round3_inst (
    .idata   (round3_in),
    .odata   (round3_out)
  );
  
  assign data_out = round3_out;

endmodule
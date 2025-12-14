`timescale 1ns/1ps

import p_table_pkg::*;

module tb_key_sh;

  logic        clk;
  logic        rst;
  logic        start_key_gen;
  logic [127:0] master_key;
  logic [575:0] round_keys;
  logic        keys_ready;
  int errors = 0;

  key_sh dut (
    .clk           (clk),
    .rst           (rst),
    .start_key_gen (start_key_gen),
    .master_key    (master_key),
    .round_keys    (round_keys),
    .keys_ready    (keys_ready)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  function automatic logic [63:0] model_fci(input logic [63:0] ci_in, input logic [63:0] iw_in);
    logic [63:0] xor_res;
    logic [63:0] p8_res;
    begin
      xor_res = ci_in ^ iw_in;
      for (int k = 0; k < 8; k++) begin
        p8_res[k*8 +: 8] = p_table_pkg::p_lookup(xor_res[k*8 +: 8]);
      end
      model_fci = {
        p8_res[63], p8_res[55], p8_res[47], p8_res[39], p8_res[31], p8_res[23], p8_res[15], p8_res[7],
        p8_res[62], p8_res[54], p8_res[46], p8_res[38], p8_res[30], p8_res[22], p8_res[14], p8_res[6],
        p8_res[61], p8_res[53], p8_res[45], p8_res[37], p8_res[29], p8_res[21], p8_res[13], p8_res[5],
        p8_res[60], p8_res[52], p8_res[44], p8_res[36], p8_res[28], p8_res[20], p8_res[12], p8_res[4],
        p8_res[59], p8_res[51], p8_res[43], p8_res[35], p8_res[27], p8_res[19], p8_res[11], p8_res[3],
        p8_res[58], p8_res[50], p8_res[42], p8_res[34], p8_res[26], p8_res[18], p8_res[10], p8_res[2],
        p8_res[57], p8_res[49], p8_res[41], p8_res[33], p8_res[25], p8_res[17], p8_res[9],  p8_res[1],
        p8_res[56], p8_res[48], p8_res[40], p8_res[32], p8_res[24], p8_res[16], p8_res[8],  p8_res[0]
      };
    end
  endfunction

  function automatic logic [575:0] model_key_sh(input logic [127:0] mk);
    logic [63:0] k_prev2, k_prev1;
    logic [63:0] k_current;
    logic [63:0] fci_out;
    logic [63:0] CI_CONSTANTS [0:8];
    logic [575:0] result;
    begin
      CI_CONSTANTS[0] = 64'h290D61409CEB9E8F;
      CI_CONSTANTS[1] = 64'h1F855F585B013986;
      CI_CONSTANTS[2] = 64'h972ED7D635AE1716;
      CI_CONSTANTS[3] = 64'h21B6694EA5728708;
      CI_CONSTANTS[4] = 64'h3C18E6E7FAADB889;
      CI_CONSTANTS[5] = 64'hB700F76F73841163;
      CI_CONSTANTS[6] = 64'h3F967F6EBF149DAC;
      CI_CONSTANTS[7] = 64'hA40E7EF6204A6230;
      CI_CONSTANTS[8] = 64'h03C54B5A46A34465;
      
      k_prev2 = mk[63:0];
      k_prev1 = mk[127:64];
      
      for (int i = 0; i < 9; i++) begin
        fci_out = model_fci(CI_CONSTANTS[i], k_prev1);
        k_current = k_prev2 ^ fci_out;
        result[i*64 +: 64] = k_current;
        k_prev2 = k_prev1;
        k_prev1 = k_current;
      end
      
      model_key_sh = result;
    end
  endfunction

  task run_case(input logic [127:0] mk);
    logic [575:0] expected;
    begin
      rst = 1;
      start_key_gen = 0;
      master_key = mk;
      @(posedge clk);
      @(posedge clk);
      rst = 0;
      @(posedge clk);
      
      start_key_gen = 1;
      @(posedge clk);
      start_key_gen = 0;
      
      wait(keys_ready);
      @(posedge clk);
      
      expected = model_key_sh(mk);
      if (round_keys !== expected) begin
        $display("Mismatch: mk=0x%032h got=0x%144h expected=0x%144h", mk, round_keys, expected);
        errors++;
      end
    end
  endtask

  initial begin
    $display("Starting key_sh tests");
    
    run_case(128'h0);
    run_case(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
    run_case(128'h0123456789ABCDEFFEDCBA9876543210);
    run_case(128'h1234567890ABCDEF0F1E2D3C4B5A6978);
    run_case(128'hA5A5A5A5A5A5A5A55A5A5A5A5A5A5A5A);

    for (int i = 0; i < 10; i++) begin
      run_case({$urandom(), $urandom(), $urandom(), $urandom()});
    end

    if (errors == 0) begin
      $display("key_sh PASS");
      $finish;
    end else begin
      $fatal(1, "key_sh FAIL: %0d mismatches", errors);
    end
  end

endmodule

`timescale 1ns/1ps

import p_table_pkg::*;

module tb_round;

  logic [63:0] data_in;
  logic [63:0] subkey;
  logic [63:0] data_out;
  int errors = 0;

  round dut (
    .data_in  (data_in),
    .subkey   (subkey),
    .data_out (data_out)
  );

  function automatic logic [15:0] model_m(input logic [15:0] in);
    logic [7:0] xl, xr;
    logic [7:0] phi_xl;
    logic [7:0] rotl_xl;
    begin
      xl = in[15:8];
      xr = in[7:0];
      phi_xl = {xl[7], xl[6] ^ xl[5], xl[5], xl[4] ^ xl[3], xl[3], xl[2] ^ xl[1], xl[1], xl[0] ^ xl[7]};
      rotl_xl = {xl[6:0], xl[7]};
      model_m = {p_table_pkg::p_lookup(phi_xl ^ xr), p_table_pkg::p_lookup(rotl_xl ^ xr)};
    end
  endfunction

  function automatic logic [63:0] model_enc(input logic [63:0] in);
    logic [63:0] after_m;
    begin
      for (int k = 0; k < 4; k++) begin
        after_m[k*16 +: 16] = model_m(in[k*16 +: 16]);
      end
      model_enc = {
        after_m[63:56],
        after_m[47:40],
        after_m[31:24],
        after_m[15:8],
        after_m[55:48],
        after_m[39:32],
        after_m[23:16],
        after_m[7:0]
      };
    end
  endfunction

  function automatic logic [63:0] model_round(input logic [63:0] din, input logic [63:0] sk);
    logic [63:0] temp;
    logic [63:0] c, c_;
    begin
      c  = 64'hb7e151628aed2a6a;
      c_ = 64'hbf7158809cf4f3c7;
      
      temp = din ^ sk;
      temp = model_enc(temp);
      
      temp = temp ^ c;
      temp = model_enc(temp);
      
      temp = temp ^ c_;
      temp = model_enc(temp);
      
      model_round = temp;
    end
  endfunction

  task run_case(input logic [63:0] din, input logic [63:0] sk);
    logic [63:0] expected;
    begin
      data_in = din;
      subkey = sk;
      #1;
      expected = model_round(din, sk);
      if (data_out !== expected) begin
        $display("Mismatch: din=0x%016h sk=0x%016h got=0x%016h expected=0x%016h", din, sk, data_out, expected);
        errors++;
      end
    end
  endtask

  initial begin
    $display("Starting round tests");
    run_case(64'h0, 64'h0);
    run_case(64'hFFFFFFFFFFFFFFFF, 64'hFFFFFFFFFFFFFFFF);
    run_case(64'h0123456789ABCDEF, 64'hFEDCBA9876543210);
    run_case(64'hB7E151628AED2A6A, 64'hBF7158809CF4F3C7);
    run_case(64'h1234567890ABCDEF, 64'h0F1E2D3C4B5A6978);

    for (int i = 0; i < 100; i++) begin
      run_case({$urandom(), $urandom()}, {$urandom(), $urandom()});
    end

    if (errors == 0) begin
      $display("round PASS");
      $finish;
    end else begin
      $fatal(1, "round FAIL: %0d mismatches", errors);
    end
  end

endmodule

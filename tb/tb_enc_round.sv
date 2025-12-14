`timescale 1ns/1ps

import p_table_pkg::*;

module tb_enc_round;

  logic [63:0] idata;
  logic [63:0] odata;
  int errors = 0;

  enc_round dut (
    .idata (idata),
    .odata (odata)
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

  task run_case(input logic [63:0] din);
    logic [63:0] expected;
    begin
      idata = din;
      #1;
      expected = model_enc(din);
      if (odata !== expected) begin
        $display("Mismatch: din=0x%016h got=0x%016h expected=0x%016h", din, odata, expected);
        errors++;
      end
    end
  endtask

  initial begin
    $display("Starting enc_round tests");
    run_case(64'h0);
    run_case(64'hFFFFFFFFFFFFFFFF);
    run_case(64'h0123456789ABCDEF);
    run_case(64'hFFEEDDCCBBAA0099);
    run_case(64'h123456789ABCDEF0);

    for (int i = 0; i < 20; i++) begin
      run_case({$urandom(), $urandom()});
    end

    if (errors == 0) begin
      $display("enc_round PASS");
    end else begin
      $fatal(1, "enc_round FAIL: %0d mismatches", errors);
    end
  end

endmodule

`timescale 1ns/1ps

import p_table_pkg::*;

module tb_m_module;

  logic [15:0] x;
  logic [15:0] y;
  int errors = 0;

  m_module dut (
    .x (x),
    .y (y)
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

  initial begin
    $display("Starting m_module exhaustive test");
    for (int i = 0; i < 65536; i++) begin
      x = i[15:0];
      #1;
      if (y !== model_m(x)) begin
        $display("Mismatch: in=0x%04h got=0x%04h expected=0x%04h", x, y, model_m(x));
        errors++;
      end
    end

    if (errors == 0) begin
      $display("m_module PASS");
    end else begin
      $fatal(1, "m_module FAIL: %0d mismatches", errors);
    end
  end

endmodule

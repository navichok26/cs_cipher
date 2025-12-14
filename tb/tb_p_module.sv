`timescale 1ns/1ps

import p_table_pkg::*;

module tb_p_module;

  logic [7:0] x;
  logic [7:0] y;
  int errors = 0;

  p_module dut (
    .x (x),
    .y (y)
  );

  initial begin
    $display("Starting p_module exhaustive test");
    for (int i = 0; i < 256; i++) begin
      x = i[7:0];
      #1;
      if (y !== p_table_pkg::p_lookup(x)) begin
        $display("Mismatch: in=0x%02h got=0x%02h expected=0x%02h", x, y, p_table_pkg::p_lookup(x));
        errors++;
      end
    end

    if (errors == 0) begin
      $display("p_module PASS");
    end else begin
      $fatal(1, "p_module FAIL: %0d mismatches", errors);
    end
  end

endmodule

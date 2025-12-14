`timescale 1ns/1ps

import p_table_pkg::*;

module tb_fci_func;

  logic [63:0] ci;
  logic [63:0] iword;
  logic [63:0] oword;
  int errors = 0;

  fci_func dut (
    .ci    (ci),
    .iword (iword),
    .oword (oword)
  );

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

  task run_case(input logic [63:0] ci_in, input logic [63:0] iw_in);
    logic [63:0] expected;
    begin
      ci = ci_in;
      iword = iw_in;
      #1;
      expected = model_fci(ci_in, iw_in);
      if (oword !== expected) begin
        $display("Mismatch: ci=0x%016h iw=0x%016h got=0x%016h expected=0x%016h", ci_in, iw_in, oword, expected);
        errors++;
      end
    end
  endtask

  initial begin
    $display("Starting fci_func tests");
    run_case(64'h0, 64'h0);
    run_case(64'hFFFFFFFFFFFFFFFF, 64'h0);
    run_case(64'h0, 64'hFFFFFFFFFFFFFFFF);
    run_case(64'h0123456789ABCDEF, 64'hFEDCBA9876543210);
    run_case(64'hA5A5A5A5A5A5A5A5, 64'h5A5A5A5A5A5A5A5A);
    run_case(64'h1234567890ABCDEF, 64'h0F1E2D3C4B5A6978);

    for (int i = 0; i < 50; i++) begin
      run_case({$urandom(), $urandom()}, {$urandom(), $urandom()});
    end

    if (errors == 0) begin
      $display("fci_func PASS");
    end else begin
      $fatal(1, "fci_func FAIL: %0d mismatches", errors);
    end
  end

endmodule

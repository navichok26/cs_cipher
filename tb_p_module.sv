`timescale 1ns / 1ns

module tb_p_module;
  logic [7:0]  a,y;
  logic  [7:0] y_ref;

  initial begin
    $dumpfile("work/wave.ocd");
    $dumpvars(0, tb_p_module);
  end

  initial begin
    for (int i = 0; i < 256; i++) begin
      a = i;  #1;
      case(a)
      8'h00: y_ref  = 8'h29;
      8'h01: y_ref  = 8'h0D;
      8'h02: y_ref  = 8'h61;
      8'h03: y_ref  = 8'h40;
      8'h04: y_ref  = 8'h9C;
      8'h05: y_ref  = 8'hEB;
      8'h06: y_ref  = 8'h9E;
      8'h07: y_ref  = 8'h8F;
      8'h08: y_ref  = 8'h1F;
      8'h09: y_ref  = 8'h85;
      8'h0A: y_ref  = 8'h5F;
      8'h0B: y_ref  = 8'h58;
      8'h0C: y_ref  = 8'h5B;
      8'h0D: y_ref  = 8'h01;
      8'h0E: y_ref  = 8'h39;
      8'h0F: y_ref  = 8'h86;
      
      8'h10: y_ref  = 8'h97;
      8'h11: y_ref  = 8'h2E;
      8'h12: y_ref  = 8'hD7;
      8'h13: y_ref  = 8'hD6;
      8'h14: y_ref  = 8'h35;
      8'h15: y_ref  = 8'hAE;
      8'h16: y_ref  = 8'h17;
      8'h17: y_ref  = 8'h16;
      8'h18: y_ref  = 8'h21;
      8'h19: y_ref  = 8'hB6;
      8'h1A: y_ref  = 8'h69;
      8'h1B: y_ref  = 8'h4E;
      8'h1C: y_ref  = 8'hA5;
      8'h1D: y_ref  = 8'h72;
      8'h1E: y_ref  = 8'h87;
      8'h1F: y_ref  = 8'h08;

      8'h20: y_ref  = 8'h3C;
      8'h21: y_ref  = 8'h18;
      8'h22: y_ref  = 8'hE6;
      8'h23: y_ref  = 8'hE7;
      8'h24: y_ref  = 8'hFA;
      8'h25: y_ref  = 8'hAD;
      8'h26: y_ref  = 8'hB8;
      8'h27: y_ref  = 8'h89;
      8'h28: y_ref  = 8'hB7;
      8'h29: y_ref  = 8'h00;
      8'h2A: y_ref  = 8'hF7;
      8'h2B: y_ref  = 8'h6F;
      8'h2C: y_ref  = 8'h73;
      8'h2D: y_ref  = 8'h84;
      8'h2E: y_ref  = 8'h11;
      8'h2F: y_ref  = 8'h63;

      8'h30: y_ref  = 8'h3F;
      8'h31: y_ref  = 8'h96;
      8'h32: y_ref  = 8'h7F;
      8'h33: y_ref  = 8'h6E;
      8'h34: y_ref  = 8'hBF;
      8'h35: y_ref  = 8'h14;
      8'h36: y_ref  = 8'h9D;
      8'h37: y_ref  = 8'hAC;
      8'h38: y_ref  = 8'hA4;
      8'h39: y_ref  = 8'h0E;
      8'h3A: y_ref  = 8'h7E;
      8'h3B: y_ref  = 8'hF6;
      8'h3C: y_ref  = 8'h20;
      8'h3D: y_ref  = 8'h4A;
      8'h3E: y_ref  = 8'h62;
      8'h3F: y_ref  = 8'h30;

      8'h40: y_ref  = 8'h03;
      8'h41: y_ref  = 8'hC5;
      8'h42: y_ref  = 8'h4B;
      8'h43: y_ref  = 8'h5A;
      8'h44: y_ref  = 8'h46;
      8'h45: y_ref  = 8'hA3;
      8'h46: y_ref  = 8'h44;
      8'h47: y_ref  = 8'h65;
      8'h48: y_ref  = 8'h7D;
      8'h49: y_ref  = 8'h4D;
      8'h4A: y_ref  = 8'h3D;
      8'h4B: y_ref  = 8'h42;
      8'h4C: y_ref  = 8'h79;
      8'h4D: y_ref  = 8'h49;
      8'h4E: y_ref  = 8'h1B;
      8'h4F: y_ref  = 8'h5C;

      8'h50: y_ref  = 8'hF5;
      8'h51: y_ref  = 8'h6C;
      8'h52: y_ref  = 8'hB5;
      8'h53: y_ref  = 8'h94;
      8'h54: y_ref  = 8'h54;
      8'h55: y_ref  = 8'hFF;
      8'h56: y_ref  = 8'h56;
      8'h57: y_ref  = 8'h57;
      8'h58: y_ref  = 8'h0B;
      8'h59: y_ref  = 8'hF4;
      8'h5A: y_ref  = 8'h43;
      8'h5B: y_ref  = 8'h0C;
      8'h5C: y_ref  = 8'h4F;
      8'h5D: y_ref  = 8'h70;
      8'h5E: y_ref  = 8'h6D;
      8'h5F: y_ref  = 8'h0A;

      8'h60: y_ref  = 8'hE4;
      8'h61: y_ref  = 8'h02;
      8'h62: y_ref  = 8'h3E;
      8'h63: y_ref  = 8'h2F;
      8'h64: y_ref  = 8'hA2;
      8'h65: y_ref  = 8'h47;
      8'h66: y_ref  = 8'hE0;
      8'h67: y_ref  = 8'hC1;
      8'h68: y_ref  = 8'hD5;
      8'h69: y_ref  = 8'h1A;
      8'h6A: y_ref  = 8'h95;
      8'h6B: y_ref  = 8'hA7;
      8'h6C: y_ref  = 8'h51;
      8'h6D: y_ref  = 8'h5E;
      8'h6E: y_ref  = 8'h33;
      8'h6F: y_ref  = 8'h2B;

      8'h70: y_ref  = 8'h5D;
      8'h71: y_ref  = 8'hD4;
      8'h72: y_ref  = 8'h1D;
      8'h73: y_ref  = 8'h2C;
      8'h74: y_ref  = 8'hEE;
      8'h75: y_ref  = 8'h75;
      8'h76: y_ref  = 8'hEC;
      8'h77: y_ref  = 8'hDD;
      8'h78: y_ref  = 8'h7C;
      8'h79: y_ref  = 8'h4C;
      8'h7A: y_ref  = 8'hA6;
      8'h7B: y_ref  = 8'hB4;
      8'h7C: y_ref  = 8'h78;
      8'h7D: y_ref  = 8'h48;
      8'h7E: y_ref  = 8'h3A;
      8'h7F: y_ref  = 8'h32;

      8'h80: y_ref  = 8'h98;
      8'h81: y_ref  = 8'hAF;
      8'h82: y_ref  = 8'hC0;
      8'h83: y_ref  = 8'hE1;
      8'h84: y_ref  = 8'h2D;
      8'h85: y_ref  = 8'h09;
      8'h86: y_ref  = 8'h0F;
      8'h87: y_ref  = 8'h1E;
      8'h88: y_ref  = 8'hB9;
      8'h89: y_ref  = 8'h27;
      8'h8A: y_ref  = 8'h8A;
      8'h8B: y_ref  = 8'hE9;
      8'h8C: y_ref  = 8'hBD;
      8'h8D: y_ref  = 8'hE3;
      8'h8E: y_ref  = 8'h9F;
      8'h8F: y_ref  = 8'h07;

      8'h90: y_ref  = 8'hB1;
      8'h91: y_ref  = 8'hEA;
      8'h92: y_ref  = 8'h92;
      8'h93: y_ref  = 8'h93;
      8'h94: y_ref  = 8'h53;
      8'h95: y_ref  = 8'h6A;
      8'h96: y_ref  = 8'h31;
      8'h97: y_ref  = 8'h10;
      8'h98: y_ref  = 8'h80;
      8'h99: y_ref  = 8'hF2;
      8'h9A: y_ref  = 8'hD8;
      8'h9B: y_ref  = 8'h9B;
      8'h9C: y_ref  = 8'h04;
      8'h9D: y_ref  = 8'h36;
      8'h9E: y_ref  = 8'h06;
      8'h9F: y_ref  = 8'h8E;

      8'hA0: y_ref  = 8'hBE;
      8'hA1: y_ref  = 8'hA9;
      8'hA2: y_ref  = 8'h64;
      8'hA3: y_ref  = 8'h45;
      8'hA4: y_ref  = 8'h38;
      8'hA5: y_ref  = 8'h1C;
      8'hA6: y_ref  = 8'h7A;
      8'hA7: y_ref  = 8'h6B;
      8'hA8: y_ref  = 8'hF3;
      8'hA9: y_ref  = 8'hA1;
      8'hAA: y_ref  = 8'hF0;
      8'hAB: y_ref  = 8'hCD;
      8'hAC: y_ref  = 8'h37;
      8'hAD: y_ref  = 8'h25;
      8'hAE: y_ref  = 8'h15;
      8'hAF: y_ref  = 8'h81;

      8'hB0: y_ref  = 8'hFB;
      8'hB1: y_ref  = 8'h90;
      8'hB2: y_ref  = 8'hE8;
      8'hB3: y_ref  = 8'hD9;
      8'hB4: y_ref  = 8'h7B;
      8'hB5: y_ref  = 8'h52;
      8'hB6: y_ref  = 8'h19;
      8'hB7: y_ref  = 8'h28;
      8'hB8: y_ref  = 8'h26;
      8'hB9: y_ref  = 8'h88;
      8'hBA: y_ref  = 8'hFC;
      8'hBB: y_ref  = 8'hD1;
      8'hBC: y_ref  = 8'hE2;
      8'hBD: y_ref  = 8'h8C;
      8'hBE: y_ref  = 8'hA0;
      8'hBF: y_ref  = 8'h34;

      8'hC0: y_ref  = 8'h82;
      8'hC1: y_ref  = 8'h67;
      8'hC2: y_ref  = 8'hDA;
      8'hC3: y_ref  = 8'hCB;
      8'hC4: y_ref  = 8'hC7;
      8'hC5: y_ref  = 8'h41;
      8'hC6: y_ref  = 8'hE5;
      8'hC7: y_ref  = 8'hC4;
      8'hC8: y_ref  = 8'hC8;
      8'hC9: y_ref  = 8'hEF;
      8'hCA: y_ref  = 8'hDB;
      8'hCB: y_ref  = 8'hC3;
      8'hCC: y_ref  = 8'hCC;
      8'hCD: y_ref  = 8'hAB;
      8'hCE: y_ref  = 8'hCE;
      8'hCF: y_ref  = 8'hED;

      8'hD0: y_ref  = 8'hD0;
      8'hD1: y_ref  = 8'hBB;
      8'hD2: y_ref  = 8'hD3;
      8'hD3: y_ref  = 8'hD2;
      8'hD4: y_ref  = 8'h71;
      8'hD5: y_ref  = 8'h68;
      8'hD6: y_ref  = 8'h13;
      8'hD7: y_ref  = 8'h12;
      8'hD8: y_ref  = 8'h9A;
      8'hD9: y_ref  = 8'hB3;
      8'hDA: y_ref  = 8'hC2;
      8'hDB: y_ref  = 8'hCA;
      8'hDC: y_ref  = 8'hDE;
      8'hDD: y_ref  = 8'h77;
      8'hDE: y_ref  = 8'hDC;
      8'hDF: y_ref  = 8'hDF;

      8'hE0: y_ref  = 8'h66;
      8'hE1: y_ref  = 8'h83;
      8'hE2: y_ref  = 8'hBC;
      8'hE3: y_ref  = 8'h8D;
      8'hE4: y_ref  = 8'h60;
      8'hE5: y_ref  = 8'hC6;
      8'hE6: y_ref  = 8'h22;
      8'hE7: y_ref  = 8'h23;
      8'hE8: y_ref  = 8'hB2;
      8'hE9: y_ref  = 8'h8B;
      8'hEA: y_ref  = 8'h91;
      8'hEB: y_ref  = 8'h05;
      8'hEC: y_ref  = 8'h76;
      8'hED: y_ref  = 8'hCF;
      8'hEE: y_ref  = 8'h74;
      8'hEF: y_ref  = 8'hC9;      

      8'hF0: y_ref  = 8'hAA;
      8'hF1: y_ref  = 8'hF1;
      8'hF2: y_ref  = 8'h99;
      8'hF3: y_ref  = 8'hA8;
      8'hF4: y_ref  = 8'h59;
      8'hF5: y_ref  = 8'h50;
      8'hF6: y_ref  = 8'h3B;
      8'hF7: y_ref  = 8'h2A;
      8'hF8: y_ref  = 8'hFE;
      8'hF9: y_ref  = 8'hF9;
      8'hFA: y_ref  = 8'h24;
      8'hFB: y_ref  = 8'hB0;
      8'hFC: y_ref  = 8'hBA;
      8'hFD: y_ref  = 8'hFD;
      8'hFE: y_ref  = 8'hF8;
      8'hFF: y_ref  = 8'h55;   
    endcase
      assert (y == y_ref)
      else $error($sformatf("Wrong result for a = %h: expected - %h, rtl - %h", a, y_ref, y));
    end
    $finish;
  end

  p_module dut (
    .x(a),
    .y(y)
  );

endmodule

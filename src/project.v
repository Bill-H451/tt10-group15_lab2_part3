/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
    parameter n = 8;
    parameter i = 0;
    reg D;
    reg E;
    reg [7:0] O;
    

  // All output pins must be assigned. If not used, assign to 0.
    always @(ui_in, uio_in)
    begin
        D = 0;
        E = 0;
        O = 0;
        for (i=n-1; i>0; i--)
        begin
            D = (ui_in[i] ^ uio_in[i]);
            if (D & ~E) 
                O = (ui_in[i]) ? ui_in : uio_in, 
                E = 1
        end
    end

  assign uo_out = O;
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule

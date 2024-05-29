/*
 * Copyright (c) 2024 Erwan Régy
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_riscv_cpu_erwanregy (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire write_enable;

    // TODO: Serial (e.g. UART) interface to get around limited number of pins?
    cpu #(
        .BUS_ADDRESS_WIDTH(8),
        .BUS_DATA_WIDTH(8)
    ) cpu (
        .clock(clk),
        .reset(~rst_n),

        .address(uo_out),
        .write_enable,
        .write_data(uio_out),
        .read_data(uio_in)
    );

    assign uio_oe = {8{write_enable}};

endmodule

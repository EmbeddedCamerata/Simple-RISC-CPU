`timescale 1ns/1ns

module rom(
    input       [12:0]  addr,
    input               ena,
    input               rd,
    output wire [7:0]   data
);

    reg [7:0] rom [13'h17ff:0];

    assign data = (rd && ena) ? rom[addr] : 8'hzz;

endmodule

`timescale 1ns/1ns

module sram(
    inout [7:0]     data,
    input [10:0]    addr,
    input           wr,
    input           rd,
    input           ena
);

    reg [7:0] ram [11'h7ff:0];

    assign data = (rd && ena) ? ram[addr] : 8'hzz;

    always @(posedge wr) begin
        ram[addr] <= data;
    end

endmodule

/*
 * Choose the output, from PC address or data/port address.
 * Read the instruction from ROM on the fore, and output the PC address
 * Read/Write the RAM or port on the later, whose address is given by instruction.
 * The signal fetch is given by clk_gen.
 */
module addr_mux(
    input               fetch,
    input       [12:0]  pc_addr,    // 8K Bytes
    input       [12:0]  ir_addr,    // 8K Bytes
    output reg  [12:0]  addr        // 8K Bytes
);

    always @(*) begin
        if (fetch)
            addr = pc_addr;
        else
            addr = ir_addr;
    end

endmodule
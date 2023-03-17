/*
 * Provides the address of instuction for reading it.
 * Every instruction is of 2-bytes which needs two cycles.
 */
module pc (
    input               rst_n,
    input               incr_pc,
    input               load_pc,
    input       [12:0]  ir_addr,    // 8K Bytes
    output reg  [12:0]  pc_addr     // 8K Bytes
);

    always @(posedge incr_pc or negedge rst_n) begin
        if (!rst_n)
            pc_addr <= 13'b0;
        else if (load_pc)
            pc_addr <= ir_addr;
        else
            pc_addr <= pc_addr + 1'b1;
    end

endmodule 
`timescale 1ns/1ns

module pc (
    input               rst_n,
    input               incr_pc,
    input               load_pc,
    input       [12:0]  ir_addr, // 8K Bytes
    output wire [12:0]  pc_addr  // 8K Bytes
);

    reg [12:0] pc_addr_r;

    assign pc_addr = pc_addr_r;

    always @(posedge incr_pc or negedge rst_n) begin
        if (!rst_n)
            pc_addr_r <= 13'b0;
        else if (load_pc)
            pc_addr_r <= ir_addr;
        else
            pc_addr_r <= pc_addr_r + 1'b1;
    end

endmodule 
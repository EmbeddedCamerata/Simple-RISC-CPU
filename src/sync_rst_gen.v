// synchronous system reset generate
// in order to eliminate meta-stability
module sync_rst_gen(
    input       sys_clk,
    input       rst_n,
    output wire sync_rst_n
);

    reg sync_rst_n1;
    reg sync_rst_n;

    always @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n)
            sync_rst_n1 <= 1'b0;
        else
            sync_rst_n1 <= 1'b1;
    end

    always @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n)
            sync_rst_n <= 1'b0;
        else
            sync_rst_n <= sync_rst_n1;
    end

endmodule 
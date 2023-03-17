/*
 * State machine controller.
 */
module statem_ctrl(
    input clk,
    input rst_n,
    input fetch,
    output reg statem_ena
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            statem_ena <= 1'b0;
        else if (fetch)
            statem_ena <= 1'b1;
        else
            statem_ena <= statem_ena;
    end

endmodule
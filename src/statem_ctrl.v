module statem_ctrl(
                    clk,
                    rst_n,
                    fetch,
                    statem_ena
                    );
input        clk,
           rst_n,
           fetch;
output reg statem_ena;

always@(posedge clk or negedge rst_n)
begin
if(!rst_n)
    statem_ena <= 1'b0;
else
    if(fetch)
        statem_ena <= 1'b1;
    else
        statem_ena <= statem_ena;
end

endmodule

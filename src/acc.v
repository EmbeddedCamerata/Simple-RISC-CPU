module acc(
    input               clk,
    input               rst_n,
    input               load_acc,
    input       [7:0]   alu_out,
    output reg  [7:0]   acc_out
);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            acc_out <= 8'h00;
        else if (load_acc)
            acc_out <= alu_out;
        else
            acc_out <= acc_out;
    end

endmodule 

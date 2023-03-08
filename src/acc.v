`timescale 1ns/1ns

module acc (
    input               clk,
    input               rst_n,
    input               load_acc,
    input       [7:0]   alu_out,
    output wire [7:0]   acc_out
);

    reg [7:0] acc_out_r;
    
    assign acc_out = acc_out_r;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            acc_out_r <= 8'h00;
        else if (load_acc)
            acc_out_r <= alu_out;
        else
            acc_out_r <= acc_out_r;
    end

endmodule 

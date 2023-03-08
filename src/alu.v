`timescale 1ns/1ns

module alu (
    input               clk,
    input               rst_n,
    input               alu_ena,
    input       [2:0]   opcode,
    input       [7:0]   data,
    input       [7:0]   acc_out,
    output wire [7:0]   alu_out,
    output wire         zero
);
    
    reg [7:0] alu_out_r;
    
    assign alu_out = alu_out_r;
    assign zero = (acc_out === 8'h00);  // ===, all the same

    localparam HLT  = 3'b000;
    localparam SKZ  = 3'b001;
    localparam ADD  = 3'b010;
    localparam ANDD = 3'b011;
    localparam XORR = 3'b100;
    localparam LDA  = 3'b101;
    localparam STO  = 3'b110;
    localparam JMP  = 3'b111;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            alu_out_r <= 8'h00;
        else if(alu_ena) begin
            case(opcode)
                HLT:    begin alu_out_r <= acc_out; end
                SKZ:    begin alu_out_r <= acc_out; end
                ADD:    begin alu_out_r <= data + acc_out; end
                ANDD:   begin alu_out_r <= data & acc_out; end
                XORR:   begin alu_out_r <= data ^ acc_out; end
                LDA:    begin alu_out_r <= data; end
                STO:    begin alu_out_r <= acc_out; end
                JMP:    begin alu_out_r <= acc_out; end
                default: begin alu_out_r <= 8'h00; end
            endcase
        end
        else begin
            alu_out_r <= alu_out_r;
        end
    end

endmodule

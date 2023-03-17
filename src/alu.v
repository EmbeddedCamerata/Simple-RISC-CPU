module alu (
    input               clk,
    input               rst_n,
    input               alu_ena,
    input       [2:0]   opcode,
    input       [7:0]   data,
    input       [7:0]   acc_out,
    output reg  [7:0]   alu_out,
    output wire         zero
);

    assign zero = (acc_out === 8'h00);

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
            alu_out <= 8'h00;
        else if (alu_ena) begin
            casex (opcode)
                HLT:    alu_out <= acc_out;
                SKZ:    alu_out <= acc_out;
                ADD:    alu_out <= data + acc_out;
                ANDD:   alu_out <= data & acc_out;
                XORR:   alu_out <= data ^ acc_out;
                LDA:    alu_out <= data;
                STO:    alu_out <= acc_out;
                JMP:    alu_out <= acc_out;
                default:alu_out <= 8'h00;
            endcase
        end
        else begin
            alu_out <= alu_out;
        end
    end

endmodule

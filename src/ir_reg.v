/*
 * Instruction registers.
 * On every positive edge of clk, load_ir decides to store
 * the data from the bus or not. Because the bus carries
 * instruction or data.
 */
module ir_reg(
    input               load_ir,
    input               clk,
    input               rst_n,
    input       [7:0]   data,
    output reg  [2:0]   opcode,
    output reg  [12:0]  ir_addr
);

    reg cstate;
    reg nstate;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cstate <= 1'b0;
        else
            cstate <= nstate;
    end

    always @(*) begin
        case (cstate)
            1'b0: if (load_ir) nstate = 1'b1 else nstate = 1'b0;
            1'b1: nstate = 1'b0;
            default: nstate = 1'b0;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            opcode <= 3'b000;
            ir_addr <= 13'b0_0000_0000_0000;
        end
        else begin
            case(nstate)
                1'b1: if (load_ir) {opcode, ir_addr[12:8]} <= data;
                1'b0: if (load_ir) {ir_addr[7:0]} <= data;
                default: ;
            endcase
        end
    end

endmodule

/*
 * State machine.
 * On cycle #0(S1):
 *      IR stores the high 8-bits instruction from ROM.
 *      rd=1, load_ir=1. Others = 0.
 * On cycle #1(S2):
 *      IR stores the low 8-bits instruction from ROM. PC +1.
 *      inc_pc = 1. Others keep the same as cycle #0.
 * On cycle #2(S3):
 *      NOP.
 * On cycle #3(S4):
 *      PC +1. Read the next instruction. If the opcode == HLT,
 *      halt = 1. Otherwise, others keep 0.
 *      inc_pc = 1. if (opcode == HLT), halt = 1. Others = 0.
 * On cycle #4(S5):
 *      If opcode == ANDD/ADD/XORR/LDA, read the data by address.
 *      If opcode == JMP, send destination address to pc.
 *      If opcode == STO, output acc.
 * On cycle #5(S6):
 *      If opcode == ANDD/ADD/XORR, do ALU. If opcode == LDA, send
 *      data to accumulator by ALU.
 *      If opcode == SKZ, if the output of acc == 0(zero == 1), PC +1.
 *      Otherwise, still.
 *      If opcode == JMP, jump to the destination address.
 *      If opcode == STO, write the data in the destination address.
 * On cycle #6(S7):
 *      NOP.
 * On cycle #7(S8):
 *      If opcode == SKZ and the output of acc == 0(zero == 1), PC +1
 *      for skipping one instruction. Otherwise, still.
 */
module statem(
    input               clk,
    input               zero,
    input               statem_ena,
    input       [2:0]   opcode,
    output reg          rd,
    output reg          load_ir,
    output reg          load_acc,
    output reg          load_pc,
    output reg          wr,
    output reg          incr_pc,
    output reg          datactrl_ena,
    output reg          halt
);

    localparam HLT  = 3'b000;
    localparam SKZ  = 3'b001;
    localparam ADD  = 3'b010;
    localparam ANDD = 3'b011;
    localparam XORR = 3'b100;
    localparam LDA  = 3'b101;
    localparam STO  = 3'b110;
    localparam JMP  = 3'b111;

    localparam IDLE = 4'b0000;
    localparam S1   = 4'b0001;
    localparam S2   = 4'b0010;
    localparam S3   = 4'b0011;
    localparam S4   = 4'b0100;
    localparam S5   = 4'b0101;
    localparam S6   = 4'b0110;
    localparam S7   = 4'b0111;
    localparam S8   = 4'b1000;

    reg [3:0] cstate, nstate;

    always @(negedge clk or negedge statem_ena) begin
        if (!statem_ena)
            cstate <= IDLE;
        else
            cstate <= nstate;
    end

    always @(*) begin
        case (cstate)
            IDLE:   nstate = S1;
            S1:     nstate = S2;
            S2:     nstate = S3;
            S3:     nstate = S4;
            S4:     nstate = S5;
            S5:     nstate = S6;
            S6:     nstate = S7;
            S7:     nstate = S8;
            S8:     nstate = S1;
            default:nstate = IDLE;
        endcase
    end

    always @(negedge clk or negedge statem_ena) begin
        if (!statem_ena) begin
            {load_ir, load_acc, load_pc, rd} <= 4'b0000;
            {wr, incr_pc, datactrl_ena, halt} <= 4'b0000;
        end
        else begin
            case (nstate)
                IDLE: begin
                    {load_ir, load_acc, load_pc, rd} <= 4'b0000;
                    {wr, incr_pc, datactrl_ena, halt} <= 4'b0000;
                end

                S1: begin
                    {load_ir, load_acc, load_pc, rd} <= 4'b1001;
                    {wr, incr_pc, datactrl_ena, halt} <= 4'b0000;
                end

                S2: begin
                    {load_ir, load_acc, load_pc, rd} <= 4'b1001;
                    {wr, incr_pc, datactrl_ena, halt} <= 4'b0100;
                end

                S3: begin
                    {load_ir, load_acc, load_pc, rd} <= 4'b0000;
                    {wr, incr_pc, datactrl_ena, halt} <= 4'b0000;
                end

                S4: begin
                    if (opcode == HLT) begin
                        {load_ir, load_acc, load_pc, rd} <= 4'b0000;
                        {wr, incr_pc, datactrl_ena, halt} <= 4'b0101;
                    end
                    else begin
                        {load_ir, load_acc, load_pc, rd} <= 4'b0000;
                        {wr, incr_pc, datactrl_ena, halt} <= 4'b0100;
                    end
                end

                S5: begin
                    if (opcode == JMP) begin
                        {load_ir, load_acc, load_pc, rd} <= 4'b0010;
                        {wr, incr_pc, datactrl_ena, halt} <= 4'b0000;
                    end
                    else if (opcode == LDA || opcode == ANDD ||
                            opcode == ADD || opcode == XORR) begin
                        {load_ir, load_acc, load_pc, rd} <= 4'b0001;
                        {wr, incr_pc, datactrl_ena, halt} <= 4'b0000;
                    end
                    else if (opcode == STO) begin
                        {load_ir, load_acc, load_pc, rd} <= 4'b0000;
                        {wr, incr_pc, datactrl_ena, halt} <= 4'b0010;
                    end
                    else begin
                        {load_ir, load_acc, load_pc, rd} <= 4'b0000;
                        {wr, incr_pc, datactrl_ena, halt} <= 4'b0000;
                    end
                end

                S6: begin
                    if (opcode == JMP) begin
                        {load_ir, load_acc, load_pc, rd} <= 4'b0010;
                        {wr, incr_pc, datactrl_ena, halt} <= 4'b0100;
                    end
                    else if (opcode == LDA || opcode == ANDD ||
                            opcode == ADD || opcode == XORR) begin
                        {load_ir, load_acc, load_pc, rd} <= 4'b0101;
                        {wr, incr_pc, datactrl_ena, halt} <= 4'b0000;
                    end
                    else if (opcode == STO) begin
                        {load_ir, load_acc, load_pc, rd} <= 4'b0000;
                        {wr, incr_pc, datactrl_ena, halt} <= 4'b1010;
                    end
                    else if (opcode == SKZ && zero == 1'b1) begin
                        {load_ir, load_acc, load_pc, rd} <= 4'b0000;
                        {wr, incr_pc, datactrl_ena, halt} <= 4'b0100;
                    end
                    else begin
                        {load_ir, load_acc, load_pc, rd} <= 4'b0000;
                        {wr, incr_pc, datactrl_ena, halt} <= 4'b0000;
                    end
                end

                S7: begin
                    if (opcode == LDA || opcode == ANDD ||
                        opcode == ADD || opcode == XORR) begin
                        {load_ir, load_acc, load_pc, rd} <= 4'b0001;
                        {wr, incr_pc, datactrl_ena, halt} <= 4'b0000;
                    end
                    else if (opcode == STO) begin
                        {load_ir, load_acc, load_pc, rd} <= 4'b0000;
                        {wr, incr_pc, datactrl_ena, halt} <= 4'b0010;
                    end
                    else begin
                        {load_ir, load_acc, load_pc, rd} <= 4'b0000;
                        {wr, incr_pc, datactrl_ena, halt} <= 4'b0000;
                    end
                end

                S8: begin
                    if (opcode == SKZ && zero == 1'b1) begin
                        {load_ir, load_acc, load_pc, rd} <= 4'b0000;
                        {wr, incr_pc, datactrl_ena, halt} <= 4'b0100;
                    end
                    else begin
                        {load_ir, load_acc, load_pc, rd} <= 4'b0000;
                        {wr, incr_pc, datactrl_ena, halt} <= 4'b0000;
                    end
                end

                default: ;
            endcase
        end
    end

endmodule
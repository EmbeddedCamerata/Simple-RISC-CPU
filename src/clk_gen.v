module clk_gen(
    input       sys_clk,
    input       rst_n,
    output wire clk,
    output reg  fetch,
    output reg  alu_ena
);

    reg [3:0] cstate, nstate;
            
    localparam IDLE = 4'b1000;
    localparam S1   = 4'b0000;
    localparam S2   = 4'b0001;
    localparam S3   = 4'b0011;
    localparam S4   = 4'b0010;
    localparam S5   = 4'b0110;
    localparam S6   = 4'b0111;
    localparam S7   = 4'b0101;
    localparam S8   = 4'b0100;

    assign clk = sys_clk;

    always @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n)
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

    always @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            fetch <= 1'b0;
            alu_ena <= 1'b0;
        end
        else begin
            case (nstate)
                IDLE:   fetch <= 1'b0; alu_ena <= 1'b0;
                S1:     fetch <= 1'b1; alu_ena <= 1'b0;
                S2:     fetch <= 1'b1; alu_ena <= 1'b0;
                S3:     fetch <= 1'b1; alu_ena <= 1'b0;
                S4:     fetch <= 1'b1; alu_ena <= 1'b0;
                S5:     fetch <= 1'b0; alu_ena <= 1'b0;
                S6:     fetch <= 1'b0; alu_ena <= 1'b1;
                S7:     fetch <= 1'b0; alu_ena <= 1'b0;
                S8:     fetch <= 1'b0; alu_ena <= 1'b0;
                default:fetch <= fetch;alu_ena <= alu_ena;
            endcase
        end
    end

endmodule 
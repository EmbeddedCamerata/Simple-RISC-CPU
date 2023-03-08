`timescale 1ns/1ns

module clk_gen (
    input       sys_clk,
    input       rst_n,
    output wire clk,
    output wire fetch,
    output wire alu_ena
);
    reg fetch_r;
    reg alu_ena_r;
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

    assign fetch = fetch_r;
    assign alu_ena = alu_ena_r;
    assign clk = sys_clk;

    always @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n)
            cstate <= IDLE;
        else
            cstate <= nstate;
    end

    always @(*) begin
        case (cstate)
            IDLE:   begin nstate = S1; end
            S1:     begin nstate = S2; end
            S2:     begin nstate = S3; end
            S3:     begin nstate = S4; end
            S4:     begin nstate = S5; end
            S5:     begin nstate = S6; end
            S6:     begin nstate = S7; end
            S7:     begin nstate = S8; end
            S8:     begin nstate = S1; end
            default: begin nstate = IDLE; end
        endcase
    end

    always @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            fetch_r <= 1'b0;
            alu_ena_r <= 1'b0;
        end
        else begin
            case(nstate)
                IDLE:   begin fetch_r <= 1'b0; alu_ena_r <= 1'b0; end
                S1:     begin fetch_r <= 1'b1; alu_ena_r <= 1'b0; end
                S2:     begin fetch_r <= 1'b1; alu_ena_r <= 1'b0; end 
                S3:     begin fetch_r <= 1'b1; alu_ena_r <= 1'b0; end 
                S4:     begin fetch_r <= 1'b1; alu_ena_r <= 1'b0; end 
                S5:     begin fetch_r <= 1'b0; alu_ena_r <= 1'b0; end 
                S6:     begin fetch_r <= 1'b0; alu_ena_r <= 1'b1; end 
                S7:     begin fetch_r <= 1'b0; alu_ena_r <= 1'b0; end 
                S8:     begin fetch_r <= 1'b0; alu_ena_r <= 1'b0; end 
                default: begin fetch_r <= fetch_r; alu_ena_r <= alu_ena_r; end
            endcase
        end
    end

endmodule 
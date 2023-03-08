module statem(
                clk,
                zero,
                statem_ena,
                opcode,
                wr,
                rd,
                load_pc,
                load_acc,
                incr_pc,
                load_ir,
                halt,
                datactrl_ena
                );
input       clk;
input       zero;
input       statem_ena;
input [2:0] opcode;

output reg  wr,
            rd;
output reg  load_acc,
            load_pc,
            incr_pc,
            load_ir;
output reg  halt,
            datactrl_ena;
            
parameter   HLT     = 3'b000,
            SKZ     = 3'b001,
            ADD     = 3'b010,
            ANDD    = 3'b011,
            XORR    = 3'b100,
            LDA     = 3'b101,
            STO     = 3'b110, 
            JMP     = 3'b111;
                        
parameter   IDLE = 4'b0000,
            S1   = 4'b0001,
            S2   = 4'b0010,
            S3   = 4'b0011,
            S4   = 4'b0100,
            S5   = 4'b0101,
            S6   = 4'b0110,
            S7   = 4'b0111,
            S8   = 4'b1000;
            
reg [3:0] cstate,
          nstate;

always@(negedge clk or negedge statem_ena)
begin
if(!statem_ena)
    cstate <= IDLE;
else
    cstate <= nstate;
end

always@(*)
begin
case(cstate)
IDLE:nstate = S1;
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

always@(negedge clk or negedge statem_ena)
begin
if(!statem_ena)
    begin
    {load_ir,load_acc,load_pc,rd} <= 4'b0000;
    {wr,incr_pc,datactrl_ena,halt} <= 4'b0000;
    end
else
    begin
    case(nstate)
    IDLE:
    begin
    {load_ir,load_acc,load_pc,rd} <= 4'b0000;
    {wr,incr_pc,datactrl_ena,halt} <= 4'b0000;
    end
    
    S1:
    begin
    {load_ir,load_acc,load_pc,rd} <= 4'b1001;
    {wr,incr_pc,datactrl_ena,halt} <= 4'b0000;
    end
    
    S2:
    begin
    {load_ir,load_acc,load_pc,rd} <= 4'b1001;
    {wr,incr_pc,datactrl_ena,halt} <= 4'b0100;
    end 
    
    S3:
    begin
    {load_ir,load_acc,load_pc,rd} <= 4'b0000;
    {wr,incr_pc,datactrl_ena,halt} <= 4'b0000;
    end 
    
    S4:
    begin
    if(opcode == HLT)
        begin
        {load_ir,load_acc,load_pc,rd} <= 4'b0000;
        {wr,incr_pc,datactrl_ena,halt} <= 4'b0101;
        end
    else
        begin
        {load_ir,load_acc,load_pc,rd} <= 4'b0000;
        {wr,incr_pc,datactrl_ena,halt} <= 4'b0100;
        end
    end 
    
    S5:
    begin
    if(opcode == JMP)
        begin
        {load_ir,load_acc,load_pc,rd} <= 4'b0010;
        {wr,incr_pc,datactrl_ena,halt} <= 4'b0000;
        end
    else
    if(opcode == LDA || opcode == ANDD ||
    opcode == ADD || opcode == XORR)
        begin
            {load_ir,load_acc,load_pc,rd} <= 4'b0001;
            {wr,incr_pc,datactrl_ena,halt} <= 4'b0000;
        end
    else
    if(opcode == STO)
        begin
        {load_ir,load_acc,load_pc,rd} <= 4'b0000;
        {wr,incr_pc,datactrl_ena,halt} <= 4'b0010;
        end
    else
        begin
        {load_ir,load_acc,load_pc,rd} <= 4'b0000;
        {wr,incr_pc,datactrl_ena,halt} <= 4'b0000;
        end
    end
    
    S6:
    begin
    if(opcode == JMP)
        begin
        {load_ir,load_acc,load_pc,rd} <= 4'b0010;
        {wr,incr_pc,datactrl_ena,halt} <= 4'b0100;
        end
    else
    if(opcode == LDA || opcode == ANDD ||
    opcode == ADD || opcode == XORR)
        begin
            {load_ir,load_acc,load_pc,rd} <= 4'b0101;
            {wr,incr_pc,datactrl_ena,halt} <= 4'b0000;
        end
    else
    if(opcode == STO)
        begin
        {load_ir,load_acc,load_pc,rd} <= 4'b0000;
        {wr,incr_pc,datactrl_ena,halt} <= 4'b1010;
        end
    else
    if(opcode == SKZ && zero == 1'b1)
        begin
        {load_ir,load_acc,load_pc,rd} <= 4'b0000;
        {wr,incr_pc,datactrl_ena,halt} <= 4'b0100;        
        end
    else
        begin
        {load_ir,load_acc,load_pc,rd} <= 4'b0000;
        {wr,incr_pc,datactrl_ena,halt} <= 4'b0000;
        end
    end 
    
    S7:
    begin
    if(opcode == LDA || opcode == ANDD ||
    opcode == ADD || opcode == XORR)
        begin
            {load_ir,load_acc,load_pc,rd} <= 4'b0001;
            {wr,incr_pc,datactrl_ena,halt} <= 4'b0000;
        end
    else
    if(opcode == STO)
        begin
        {load_ir,load_acc,load_pc,rd} <= 4'b0000;
        {wr,incr_pc,datactrl_ena,halt} <= 4'b0010;
        end
    else
        begin
        {load_ir,load_acc,load_pc,rd} <= 4'b0000;
        {wr,incr_pc,datactrl_ena,halt} <= 4'b0000;
        end
    end 
    
    S8:
    if(opcode == SKZ && zero == 1'b1)
        begin
        {load_ir,load_acc,load_pc,rd} <= 4'b0000;
        {wr,incr_pc,datactrl_ena,halt} <= 4'b0100;
        end
    else
        begin
        {load_ir,load_acc,load_pc,rd} <= 4'b0000;
        {wr,incr_pc,datactrl_ena,halt} <= 4'b0000;
        end
    
    default:; 
    endcase
    end
end

endmodule

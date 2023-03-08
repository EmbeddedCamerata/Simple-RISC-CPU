module addr_mux(
                fetch,
                addr,
                pc_addr,
                ir_addr
                );
input               fetch;
input        [12:0] pc_addr,
                  ir_addr;     // 8K Bytes
output reg [12:0] addr;     // 8K Bytes

always@(*)
begin
if(fetch)
    addr = pc_addr;
else
    addr = ir_addr;
end

endmodule 
module addr_decode(
                   addr,
                   rom_sel,
                   ram_sel
                   );
input [12:0] addr;
output          rom_sel,
             ram_sel;

assign rom_sel = (addr[12:11] == 2'b00 || addr[12:11] == 2'b01 || addr[12:11] == 2'b10)? 1'b1 : 1'b0;
assign ram_sel = (addr[12:11] == 2'b11)? 1'b1 : 1'b0;
endmodule

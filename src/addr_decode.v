/*
 * Generate the signal of selecting ROM or RAM.
 * 1FFFH ~ 1800H for RAM
 * 17FFH ~ 0000H for ROM
 */
module addr_decode(
    input       [12:0]  addr,
    output wire         rom_sel,
    output wire         ram_sel
);
    
    assign rom_sel = (addr[12:11] == 2'b00 || addr[12:11] == 2'b01 || addr[12:11] == 2'b10) ? 1'b1 : 1'b0;
    assign ram_sel = (addr[12:11] == 2'b11) ? 1'b1 : 1'b0;
    // always @(*) begin
    //     casex (addr)
    //         13'b1_1xxx_xxxx_xxxx: {rom_sel, ram_sel} = 2'b01;
    //         13'b0_xxxx_xxxx_xxxx: {rom_sel, ram_sel} = 2'b10;
    //         13'b1_0xxx_xxxx_xxxx: {rom_sel, ram_sel} = 2'b10;
    //         default: {rom_sel, ram_sel} = 2'b00;
    //     endcase
    // end

endmodule
module data_ctrl(
    input       [7:0]   alu_out,
    input               datactrl_ena,
    output wire [7:0]   data
);

    assign data = (datactrl_ena) ? alu_out : 8'hzz;
    // when ACC don't export data, the data bus is tri-state

endmodule

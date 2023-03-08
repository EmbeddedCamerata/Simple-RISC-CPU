module data_ctrl(
                 alu_out,
                 data,
                 datactrl_ena
                 );
input  [7:0] alu_out;
input          datactrl_ena;
output [7:0] data;

assign data = (datactrl_ena)? alu_out : 8'hzz;
// when ACC don't export data, the data bus is tri-state

endmodule 

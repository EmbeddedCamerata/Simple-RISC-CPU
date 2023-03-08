module risc_cpu(
                 rst_n,
                 sys_clk,
                 data,
                 wr,
                 rd,
                 halt,
                 addr,
                 //---- for verification
                 opcode,
                 fetch,
                 ir_addr,
                 pc_addr
                 
                );
input           rst_n;
input           sys_clk;
inout  [7:0]    data;
output          wr;
output          rd;
output          halt;
output [12:0]   addr;
//---- for verification
output [2:0]    opcode;
output          fetch;
output [12:0]   ir_addr;
output [12:0]   pc_addr;
// -----------------------------------------------------
// -----------------------------------------------------
wire [2:0]          opcode;
wire                clk,fetch,alu_ena;
wire                statem_ena,zero,load_acc,load_pc,load_ir,incr_pc,datactrl_ena;
wire [7:0]          alu_out,acc_out;
wire [12:0]         pc_addr,ir_addr;

// clk_gen
clk_gen u_clk_gen(
                  .sys_clk (sys_clk),
                  .rst_n   (rst_n  ),
                  .clk     (clk    ),
                  .fetch   (fetch  ),
                  .alu_ena (alu_ena)
                  );

// statem_ctrl
statem_ctrl u_statem_ctrl(
                          .clk        (clk       ),
                          .rst_n      (rst_n     ),
                          .fetch      (fetch     ),
                          .statem_ena (statem_ena)
                          );
//statem        
statem u_statem(
                .clk            (clk         ),
                .zero           (zero        ),
                .statem_ena     (statem_ena  ),
                .opcode         (opcode      ),
                .wr             (wr          ),
                .rd             (rd          ),
                .load_acc       (load_acc    ),
                .load_pc        (load_pc     ),
                .incr_pc        (incr_pc     ),
                .load_ir        (load_ir     ),
                .halt           (halt        ),
                .datactrl_ena   (datactrl_ena)
                );

//acc    
acc u_acc(
          .load_acc   (load_acc  ) ,
          .clk        (clk       ),
          .rst_n      (rst_n     ) ,
          .alu_out    (alu_out   ),
          .acc_out    (acc_out   )
          );

//addr_mux
addr_mux u_addr_mux(
                    .fetch    (fetch  ),
                    .pc_addr  (pc_addr),
                    .ir_addr  (ir_addr),
                    .addr     (addr   )
                    );

//alu
alu u_alu(
          .clk      (clk     ),
          .rst_n    (rst_n   ),
          .alu_ena  (alu_ena ),
          .opcode   (opcode  ),
          .data     (data    ),
          .acc_out  (acc_out ),
          .alu_out  (alu_out ),
          .zero     (zero    )
          );



// data_ctrl
data_ctrl u_data_ctrl(
                      .alu_out        (alu_out         ),
                      .datactrl_ena   (datactrl_ena    ),
                      .data           (data            )
                      );
//ir_reg
ir_reg u_ir_reg(
                .load_ir    (load_ir),    
                .clk        (clk    ),    
                .rst_n      (rst_n  ),
                .data       (data   ),
                .opcode     (opcode ),
                .ir_addr    (ir_addr)    
                );
//pc
pc u_pc(
        .incr_pc    (incr_pc),    
        .load_pc    (load_pc),    
        .ir_addr    (ir_addr),    
        .rst_n      (rst_n  ),
        .pc_addr    (pc_addr)    
        );
endmodule

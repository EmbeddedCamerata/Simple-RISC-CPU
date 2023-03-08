`include "time.v"
//`include "test1.dat"
//`include "test2.dat"
//`include "test3.dat"
//`include "test1.pro"
//`include "test2.pro"
//`include "test3.pro"

`define PERIOD 100 // matches clk_gen.v

module top;
reg reset_req,clock;
integer test;

reg  [(3*8):0]  mnemonic; //array that holds 3 8-bit ASCII characters
reg  [12:0]     PC_addr,IR_addr;
wire [7:0]      data;
wire [12:0]     addr;
wire            rd,wr,halt,ram_sel,rom_sel;
wire            sync_rst_n;

wire [2:0]      opcode;
wire            fetch;
wire [12:0]     ir_addr,pc_addr;
//----------------------------------------------------------------------------
risc_cpu u_risc_cpu(
                   .sys_clk    (clock),
                   .rst_n      (sync_rst_n),
                   .halt       (halt),
                   .rd         (rd),
                   .wr         (wr),
                   .addr       (addr),
                   .data       (data),
                   .opcode     (opcode),
                   .fetch      (fetch),
                   .ir_addr    (ir_addr),
                   .pc_addr    (pc_addr)
                   );
                  
sram           u_sram         (
                            .addr(addr[10:0]),
                            .rd(rd),
                            .wr(wr),
                            .ena(ram_sel),
                            .data(data)
                            );
                            
rom           u_rom             (
                            .addr(addr),
                            .rd(rd),
                            .ena(rom_sel),
                            .data(data)
                            );
                            
addr_decode  u_addr_decode     (
                            .addr(addr),
                            .ram_sel(ram_sel),
                            .rom_sel(rom_sel)
                            );
                            
sync_rst_gen u_sync_rst_gen (
                            .sys_clk(clock),
                            .rst_n(reset_req),
                            .sync_rst_n(sync_rst_n)
                            );
//------------------------------------------------------------------------------
initial
begin
$fsdbDumpfile("debussy.fsdb");
$fsdbDumpvars;
end



initial
    begin
    clock=1;
    //display time in nanoseconds
    $timeformat ( -9, 1, " ns", 12);
    display_debug_message;
    sys_reset;
    test1;
    $stop;
    test2;
    $stop;
    test3;
    $stop;
    end

task display_debug_message;
begin
    $display("\n******************************************************");
    $display("* THE FOLLOWING DEBUG TASK ARE AVAILABLE: *");
    $display("* \"test1; \" to load the 1st diagnostic progran. *");
    $display("* \"test2; \" to load the 2nd diagnostic program. *");
    $display("* \"test3; \" to load the Fibonacci program. *");
    $display("******************************************************\n");
    end
endtask

task test1;
    begin
    test = 0;
    disable MONITOR;
    $readmemb("../test1.pro", u_rom.rom);
    $display("rom loaded successfully!");
    $readmemb("../test1.dat",u_sram.ram);
    $display("ram loaded successfully!");
    #1 test = 1;
    #14800 ;
    sys_reset;
    end
endtask

task test2;
    begin
    test = 0;
    disable MONITOR;
    $readmemb("../test2.pro",u_rom.rom);
    $display("rom loaded successfully!");
    $readmemb("../test2.dat",u_sram.ram);
    $display("ram loaded successfully!");
    #1 test = 2;
    #11600;
    sys_reset;
    end
endtask

task test3;
    begin
    test = 0;
    disable MONITOR;
    $readmemb("../test3.pro",u_rom.rom);
    $display("rom loaded successfully!");
    $readmemb("../test3.dat",u_sram.ram);
    $display("ram loaded successfully!");
    #1 test = 3;
    #94000;
    sys_reset;
    end
endtask

task sys_reset;
    begin
    reset_req = 1;
    #(`PERIOD*0.7) reset_req = 0;
    #(1.5*`PERIOD) reset_req = 1;
    end
endtask

always @(test)
begin: MONITOR
    case (test)
        1: begin //display results when running test 1
        $display("\n*** RUNNING CPUtest1 - The Basic CPU Diagnostic Program ***");
        $display("\n TIME PC INSTR ADDR DATA ");
        $display(" ---------- ---- ----- ----- ----- ");
        while (test == 1)
            @(u_risc_cpu.u_addr_mux.pc_addr)//fixed
            if ((u_risc_cpu.u_addr_mux.pc_addr%2 == 1)&&(u_risc_cpu.u_addr_mux.fetch == 1))//fixed
                begin
                # 60 PC_addr <= u_risc_cpu.u_addr_mux.pc_addr -1 ;
                IR_addr <= u_risc_cpu.u_addr_mux.ir_addr;
                # 340 $strobe("%t %h %s %h %h",$time,PC_addr,mnemonic,IR_addr,data );//HERE DATA HAS BEEN CHANGEDT-CPU-M-REGISTER.DATA
                end
        end
    
    2: begin
        $display("\n*** RUNNING CPUtest2 - The Advanced CPU Diagnostic Program ***");
        $display("\n TIME PC INSTR ADDR DATA ");
        $display(" ---------- --- ----- ----- ---- ");
        while (test == 2)
            @(u_risc_cpu.u_addr_mux.pc_addr)
            if ((u_risc_cpu.u_addr_mux.pc_addr%2 == 1) && (u_risc_cpu.u_addr_mux.fetch == 1))
                begin
                # 60 PC_addr <= u_risc_cpu.u_addr_mux.pc_addr - 1 ;
                IR_addr <= u_risc_cpu.u_addr_mux.ir_addr;
                # 340 $strobe("%t %h %s %h %h", $time, PC_addr,
                mnemonic, IR_addr, data );
                end
        end
    
    3: begin
        $display("\n*** RUNNING CPUtest3 - An Executable Program ***");
        $display("*** This program should calculate the fibonacci ***");
        $display("\n TIME FIBONACCI NUMBER");
        $display( " --------- -----------------");
        while (test == 3)
            begin
            wait ( u_risc_cpu.u_alu.opcode == 3'h1) // display Fib. No. at end of program loop
            $strobe("%t %d", $time,u_sram.ram[10'h2]);
            wait ( u_risc_cpu.u_alu.opcode != 3'h1);
            end
        end
    endcase
end
//----------------------------------------------------------------------------------

always @(posedge halt) //STOP when HALT instruction decoded
begin
#500
$display("\n***********************************************************");
$display("* A HALT INSTRUCTION WAS PROCESSED !!! *");
$display("***********************************************************\n");
end

always #(`PERIOD/2) clock=~clock;
    always @(u_risc_cpu.u_alu.opcode)
    //get an ASCII mnemonic for each opcode
    case(u_risc_cpu.u_alu.opcode)
    3'h0 :    mnemonic ="HLT";
    3'h1 :    mnemonic = "SKZ";
    3'h2 :    mnemonic = "ADD";
    3'h3 :    mnemonic = "AND";
    3'h4 :    mnemonic = "XOR";
    3'h5 :    mnemonic = "LDA";
    3'h6 :    mnemonic = "STO";
    3'h7 :    mnemonic = "JMP";
    default : mnemonic = "???";
    endcase

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//
//////////////////////////////////////////////////////////////////////////////////
module exe(clk,o_p,instr);
input clk;
output [31:0] instr;
//output zero;
output reg [31:0] o_p;
  //output branch,jump,flag,zero;
  wire branch,jump,flag,zero;
 wire [31:0] immi;
 wire [4:0] rs,rt,rd;
  wire [4:0] shift;
 wire  [25:0] targ_addr;
  wire aluselect,regdest,memwrite,regwrite,memtoreg,shift_ctrl,immidiate;
  wire [3:0] aluctrl;

 wire [15:0] offset;
reg [4:0] Rd;
wire [31:0] A;
wire [31:0] o_p_alu,o_p_mem;
wire [31:0] reg_B;
reg [31:0] B;
reg [31:0] reg_file[0:31];
reg [31:0] main_mem[0:255];
reg [7:0] instr_mem[0:128];
initial begin

reg_file[0] = 0; // Here, I am initialising the top 5 register file values.
reg_file[1] = 10;
reg_file[2] = 2;
reg_file[3] = 3;
reg_file[4] = 4;
reg_file[5] = 5;
reg_file[6] = 6; 
reg_file[7] = 7;
reg_file[8] = 8;
reg_file[9] = 9;
reg_file[10] = 10;
reg_file[11] = 11;
reg_file[12] = 12;
reg_file[13] = 13;
reg_file[14] = 14;
reg_file[15] = 15;
reg_file[16] = 16;
reg_file[17] = 17; 
reg_file[18] = 18;
reg_file[19] = 19;
reg_file[20] = 20;
reg_file[21] = 21;
reg_file[22] = 22;
main_mem[0] = 0; // Here, I am initialising the top 5 memory file values.
main_mem[1] = 10;
main_mem[2] = 20;
main_mem[3] = 30;
main_mem[4] = 40;
main_mem[5] = 50;
//ADD R2 R0 R0
instr_mem[0] = 8'b00100000;
instr_mem[1] = 8'b00010000;
instr_mem[2] = 8'b00000000;
instr_mem[3] = 8'b00000000;
//ADD R2 R2 R1
instr_mem[4] = 8'b00100000;
instr_mem[5] = 8'b00010000;
instr_mem[6] = 8'b01000001;    
instr_mem[7] = 8'b00000000;
//ADDI R1 R1 -1
instr_mem[8] = 8'b11111111;
instr_mem[9] = 8'b11111111;
instr_mem[10] = 8'b00100001;
instr_mem[11] = 8'b00100000;
//BEQ R1 R0 label
instr_mem[12] = 8'b00000011;
instr_mem[13] = 8'b00000000;
instr_mem[14] = 8'b00100000;
instr_mem[15] = 8'b00010000;
// NO OP
instr_mem[16] = 8'b00100000;
instr_mem[17] = 8'b00000000;
instr_mem[18] = 8'b00000000;
instr_mem[19] = 8'b00000000;
//jump to instruction 1
instr_mem[20] = 8'b00000001;
instr_mem[21] = 8'b00000000;
instr_mem[22] = 8'b00000000;    
instr_mem[23] = 8'b00001000;
// NO OP
instr_mem[24] = 8'b00100000;
instr_mem[25] = 8'b00000000;
instr_mem[26] = 8'b00000000;
instr_mem[27] = 8'b00000000;    
//SW R2
instr_mem[28] = 8'b00000000;
instr_mem[29] = 8'b00000000;
instr_mem[30] = 8'b01000010;
instr_mem[31] = 8'b10101100;
/*slti
instr_mem[24] = 8'b00111110;
instr_mem[25] = 8'b00000000;
instr_mem[26] = 8'b00000011;
instr_mem[27] = 8'b00101000;			
//lw
instr_mem[28] = 8'b00000001;
instr_mem[29] = 8'b00000000;
instr_mem[30] = 8'b01000011;
instr_mem[31] = 8'b10001100;	
		
//sw
instr_mem[32] = 8'b00000001;
instr_mem[33] = 8'b00000000;
instr_mem[34] = 8'b01000011;
instr_mem[35] = 8'b10101100;	
//slti

instr_mem[37] = 8'b00000000;
instr_mem[38] = 8'b01000011;
instr_mem[39] = 8'b00101000;				
		
//beq
instr_mem[40] = 8'b00111110;
instr_mem[41] = 8'b00000000;
instr_mem[42] = 8'b01000011;
instr_mem[43] = 8'b00010000;
//jump
instr_mem[44] = 8'b00111110;
instr_mem[45] = 8'b00000000;
instr_mem[46] = 8'b01000011;
instr_mem[47] = 8'b00001000;
*/

pc = 0;

end

reg [31:0] pc;
wire [29:0] PC_add;
wire [29:0] PC_jump;
reg [29:0] PC_1;
reg [29:0] PC_2;
reg [31:0] instr_out;
//
assign PC_jump = {pc[31:28],targ_addr[25:0]};
assign PC_add = pc[31:2] + 30'd1; 

always@(PC_add or branch or zero)
begin
if(branch == 1'b1 & zero == 1'b1)
begin
PC_1 = PC_add + {{14{offset[15]}},offset[15:0]}-1;
end 
else
begin
PC_1 = PC_add;
end
end
//
always@(PC_jump or PC_1 or jump)
begin
if(jump == 1'b1)
begin
PC_2 = PC_jump;
end
else
begin
PC_2 = PC_1;
end
end
//
always@(negedge clk)
begin 
instr_out = {instr_mem[pc+3],instr_mem[pc+2],instr_mem[pc+1],instr_mem[pc]};
pc[31:0] = {PC_2,{2{1'b0}}};
end


assign instr = instr_out;



//
decode modu(instr,immi,rs,rt,rd,aluselect,regdest,memwrite,regwrite,memtoreg,branch,jump,aluctrl,shift,targ_addr,offset,shift_ctrl,immidiate);
//
assign A=reg_file[rs];
assign reg_B = reg_file[rt];
always@(rs or rt or rd or aluselect or immi or regdest or reg_B )
begin
if(regdest==1)
begin
Rd=rd;
end
else if(regdest==0)
begin
Rd=rt;
end
if(aluselect==1)
begin
if(immidiate==0)
begin
B=immi;
end
else
begin
B={16'b0,offset};
end
end
else if(aluselect==0)
begin
B=reg_B;
end
end
//
alu g1(A,B,aluctrl,o_p_alu,zero,shift,flag,shift_ctrl);
//
assign o_p_mem=main_mem[o_p_alu];
always@(posedge clk)
begin
if(regwrite==1 && memtoreg==0)
begin
reg_file[Rd] = o_p_alu;
o_p =o_p_alu;
end
if(regwrite==1 && memtoreg==1)
begin
reg_file[Rd] = o_p_mem;
o_p =o_p_mem;
end
if(memwrite==1)
begin
main_mem[o_p_alu]=reg_file[rt];
o_p =reg_file[rt];
end
end

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//reg [31:0] mem_reg [31:0];


module decode(instr,immi,rs,rt,rd,aluselect,regdest,memwrite,regwrite,memtoreg,branch,jump,aluctrl,shift,targ_addr,offset,shift_ctrl,immidiate);
input [31:0] instr;
//input clk;
output reg [31:0] immi;
output reg [4:0] rs,rt,rd;
output  reg [4:0] shift;
output reg  [25:0] targ_addr;
output  reg aluselect,regdest,memwrite,regwrite,memtoreg;
output  reg [3:0] aluctrl;
output  reg branch,jump;
output reg [15:0] offset;
output reg shift_ctrl,immidiate;
//reg [31:0] mem_reg [31:0];
//reg [31:0] A,B;
always@(instr)
begin
 rs = instr[25:21];
 rt =instr[20:16];
 rd =instr[15:11];
 shift=instr[10:6];
targ_addr=instr[25:0];
immi=32'h0000;
branch = 0;
jump=0;
aluselect=1'bz;
regdest=1'bz;
memwrite=0;
regwrite=0;
memtoreg=1'bz;
aluctrl=4'b0000;
immidiate=0;
shift_ctrl=0;
offset=instr[15:0];
// immidiate 
if(instr[15]==1)
begin
 immi={16'hFFFF,instr[15:0]};
end
else if(instr[15]==0)
begin
immi={16'h0000,instr[15:0]};
end
//

if(instr[31:26]==6'b000000)  //R-type 
begin
branch = 0;
jump=0;
aluselect=0;
regdest=1;
memwrite=0;
regwrite=1;
memtoreg=0;
if(instr[5:0]==6'b100000)	//ADD
begin
aluctrl=4'b0000;
end
else if(instr[5:0]==6'b100010) //SUB
begin
aluctrl=4'b0001;
end
else if(instr[5:0]==6'b101010) //SLT
begin
aluctrl=4'b1010;
end
else if(instr[5:0]==6'b101011) //SLTU
begin
aluctrl=4'b1101;
end
else if(instr[5:0]==6'b100100)	//AND
begin
aluctrl = 4'b0010;
immidiate=1;
end
else if(instr[5:0]==6'b100101)	//OR
begin
aluctrl = 4'b0011;
immidiate=1;
end
else if(instr[5:0]==6'b100111)		//nor	
begin
aluctrl = 4'b0101;
end
else if(instr[5:0]==6'b100110)		//xor
begin
aluctrl = 4'b0110;
immidiate=1;
end
else if(instr[5:0]==6'b000000)		//SLL,SLLV
begin
if(instr[10:6]==5'b00000)				
begin
shift_ctrl=1'b1;
end
aluctrl = 4'b0111;
end
else if(instr[5:0]==6'b000010)		//SRL,SRLV
begin
if(instr[10:6]==5'b00000)
begin
shift_ctrl=1'b1;
end
aluctrl = 4'b1000;
end

else if(instr[5:0]==6'b000011)		//SRA,SRAV
begin
if(instr[10:6]==5'b00000)
begin
shift_ctrl=1'b1;
end
aluctrl = 4'b0100;
end

end
///


else if (instr[31:26]==6'b001000)  //ADDI
begin
branch=0;
jump=0;
aluctrl=4'b0000;
aluselect=1;
regdest=0;
memwrite=0;
regwrite=1;
memtoreg=0;
//immidiate=1;
end


else if(instr[31:26]==6'b001100) //andi
begin
branch=0;
jump=0;
aluctrl=4'b0010;
aluselect=1;
regdest=0;
memwrite=0;
regwrite=1;
memtoreg=0;
immidiate=1;
end

else if(instr[31:26]==6'b001101) //ori
begin
branch=0;
jump=0;
aluctrl=4'b0011;
aluselect=1;
regdest=0;
memwrite=0;
regwrite=1;
memtoreg=0;
immidiate=1;
end

else if(instr[31:26]==6'b001110) //xori
begin
branch=0;
jump=0;
aluctrl=4'b0110;
aluselect=1;
regdest=0;
memwrite=0;
regwrite=1;
memtoreg=0;
immidiate=1;
end




else if(instr[31:26]==6'b001010) //slti
begin
branch=0;
jump=0;
aluctrl=4'b1010;
aluselect=1;
regdest=0;
memwrite=0;
regwrite=1;
memtoreg=0;
end

else if(instr[31:26]==6'b001011) //sltiU
begin
branch=0;
jump=0;
aluctrl=4'b1101;
aluselect=1;
regdest=0;
memwrite=0;
regwrite=1;
memtoreg=0;
immidiate=1;
end





else if(instr[31:26]==6'b100011) //LW
begin
branch=0;
jump=0;
aluctrl=4'b0000;
aluselect=1;
regdest=0;
memwrite=0;
regwrite=1;
memtoreg=1;
end


else if(instr[31:26]==6'b101011) //SW
begin
branch=0;
jump=0;
aluctrl=4'b0000;
aluselect=1;
regdest=0;
memwrite=1;
regwrite=0;
memtoreg=0;

end


else if(instr[31:26]==6'b000100) //BEQ
begin
branch=1;
jump=0;
aluctrl=4'b0001;
aluselect=0;
regdest=0;
memwrite=0;
regwrite=0;
memtoreg=0;
end

else if(instr[31:26]==6'b000101) //BNEQ
begin
branch=1;
jump=0;
aluctrl=4'b1011;
aluselect=0;
regdest=0;
memwrite=0;
regwrite=0;
memtoreg=0;
end


else if(instr[31:26]==6'b000110) //BLEZ
begin
branch=1;
jump=0;
aluselect=0;
regdest=0;
memwrite=0;
regwrite=0;
memtoreg=0;
/*if(instr[20:16]==5'b00001)			
begin
aluctrl=4'b1110;
end*/
//else if(instr[20:16]==5'b00000)		
//begin
aluctrl=4'b1001;
//end
end

else if(instr[31:26]==6'b000111) //BGTZ
begin
branch=1;
jump=0;
aluselect=0;
regdest=0;
memwrite=0;
regwrite=0;
memtoreg=0;
/*if(instr[20:16]==5'b00001)			
begin
aluctrl=4'b1110;
end*/
//else if(instr[20:16]==5'b00000)		
//begin
aluctrl=4'b1110;
//end
end





else if(instr[31:26]==6'b000010) //J-type
begin
branch=0;
jump=1;
aluctrl=4'b0000;
aluselect=0;
regdest=0;
memwrite=0;
regwrite=0;
memtoreg=0;
end

end




endmodule
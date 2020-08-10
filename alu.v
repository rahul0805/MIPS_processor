`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

 
module alu(a,b,aluctrl,o_p,zero,shift_amt,flag,shift_ctrl);
input [31:0] a,b;
input [4:0] shift_amt;
input [3:0] aluctrl;
input shift_ctrl;
//input rst;
output reg [31:0]o_p;
output reg zero;
output reg flag;
always@(*)
begin
flag = 1'b0;
case(aluctrl)
default :begin
o_p = 32'b0;
zero = 1'b0;
end 
4'b0000 : begin
{flag,o_p} = a + b;
zero = (o_p==32'b0);
end
4'b0001 : begin
o_p = a-b;
zero = (o_p==32'b0);
end
4'b0010 : begin
o_p = a & b;
end
4'b0011 : begin
o_p = a | b;
end
4'b0100 : begin
if(shift_ctrl==1'b0)
begin
o_p = (b>>>shift_amt);
end
else
begin
o_p = (b>>>a);
end
end
4'b0101 : begin
o_p = ~(a | b);
end
4'b0110 : begin 
o_p = a^b;
end
4'b0111 : begin
if(shift_ctrl==1'b0)
begin
o_p = (b<<shift_amt);
end
else
begin
o_p = (b<<a);
end
end 
//
4'b1000 : begin
if(shift_ctrl==1'b0)
begin
o_p = (b>>shift_amt);
end
else
begin
o_p = (b>>a);
end
end
//
4'b1001 : begin
o_p = ($signed(a) > $signed(b));
end
4'b1010 : begin
o_p= ($signed(a) < $signed(b));
end
4'b1011 : begin
o_p= (a==b);
end
4'b1100 : begin
o_p= (a!=b);
end
4'b1101 : begin
o_p= (a<b);
end

4'b1110 : begin
o_p= ($signed(a) <= $signed(b));
end

endcase
if(o_p==32'b0)
begin
zero = 1'b1;
end
else
begin
zero=1'b0;
end
end

endmodule
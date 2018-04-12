`timescale 1s / 1s
module alu(x,y,aluop,re1,re2,of,uof,equ);
	input signed [31:0] x;
	input signed [31:0] y;
	input [3:0] aluop;
	output reg [31:0] re1;
	output reg [31:0] re2;
	output reg equ;
	integer  R1, R2, R3, R4, R5,
		 R6, R7, R8, R9, R10,
		 R11, R12;
	reg [31:0] R13;	
	integer  r4, r5;
	always @(aluop or x or y) begin
		R1=x<<y;
		R2=x>>>y;
		R3=x>>y;
		R5=x/y;    r5=x%y;
		R6=x+y;
		R7=x-y;
		R8=x&y;
		R9=x|y;
		R10=x^y;
		R11=~(x|y);
		R12=x<y?1:0;
		R13=$unsigned(x)<$unsigned(y)?1:0;
		equ<=x==y?1:0;
	end
	always @(aluop or x or y) begin
		case(aluop)
			4'b0000:re1<=R1;
			4'b0001:re1<=R2;
			4'b0010:re1<=R3;
			4'b0011:begin
				{re1,re2}=x*y;
			end
			4'b0100:begin
				re1<=R5;
				re2<=r5;
			end
			4'b0101:begin
				re1<=R6;
			end
			4'b0110:begin
				re1<=R7;
			end
			4'b0111:re1<=R8;
			4'b1000:re1<=R9;
			4'b1001:re1<=R10;
			4'b1010:re1<=R11;
			4'b1011:re1<=R12;
			4'b1100:re1<=R13;
			default:begin
				re1<=0;
				re2<=0;
			end
			endcase
	end
	endmodule
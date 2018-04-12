`timescale 1ns / 1ps
module alu_ctl(op,alu_in,Rt_write,reg_write);
input [31:0]op;
output reg Rt_write;
output wire reg_write;
output reg [3:0]alu_in;
reg [3:0]func;
reg [3:0]op_i;
reg reg_write1,reg_write2,r_type;
assign reg_write = (r_type&reg_write1)|reg_write2;
always @(op) begin
	case(op[5:0])
		6'b100000: begin func[3:0] = 4'b0101;reg_write1=1; end//add
		6'b100001: begin func[3:0] = 4'b0101;reg_write1=1; end//addu
		6'b100100: begin func[3:0] = 4'b0111;reg_write1=1; end//and
		6'b011010: begin func[3:0] = 4'b0100;reg_write1=1; end//div
		6'b011011: begin func[3:0] = 4'b0100;reg_write1=1; end//div
		6'b011000: begin func[3:0] = 4'b0011;reg_write1=1; end//mult
		6'b011001: begin func[3:0] = 4'b0011;reg_write1=1; end//mult
		6'b100111: begin func[3:0] = 4'b1010;reg_write1=1; end
		6'b100101: begin func[3:0] = 4'b1000;reg_write1=1; end//or
		6'b000000: begin func[3:0] = 4'b0000;reg_write1=1; end//sll
		6'b101010: begin func[3:0] = 4'b1011;reg_write1=1; end//slt
		6'b101011: begin func[3:0] = 4'b1100;reg_write1=1; end//sltu
		6'b000011: begin func[3:0] = 4'b0001;reg_write1=1; end//sra
		6'b000010: begin func[3:0] = 4'b0010;reg_write1=1; end//srl
		6'b100010: begin func[3:0] = 4'b0110;reg_write1=1; end//sub
		6'b100011: begin func[3:0] = 4'b0110;reg_write1=1; end//subu
		6'b100110: begin func[3:0] = 4'b1001;reg_write1=1; end//xor
		default: begin func[3:0] = 4'b0101; reg_write1=0;end
	endcase
	case(op[31:26])
		6'b001000: begin op_i[3:0] = 4'b0101;Rt_write = 1;reg_write2=1; end//addi
		6'b001001: begin op_i[3:0] = 4'b0101;Rt_write = 1;reg_write2=1; end//addiu
		6'b001100: begin op_i[3:0] = 4'b0111;Rt_write = 1;reg_write2=1; end//andi
		6'b001101: begin op_i[3:0] = 4'b1000;Rt_write = 1;reg_write2=1; end//ori
		6'b001010: begin op_i[3:0] = 4'b1011;Rt_write = 1;reg_write2=1; end//slti
		6'b001110: begin op_i[3:0] = 4'b1001;Rt_write = 1;reg_write2=1; end//xori
		6'b000000: begin op_i[3:0] = 4'b0000;Rt_write = 0;reg_write2=0; end
		6'b100011: begin Rt_write = 1;reg_write2=0; end
		default: begin op_i[3:0] = 4'b0101;Rt_write = 0;reg_write2=0; end
	endcase
	if(op_i[3:0] == 4'b0000) begin
		alu_in[3:0] = func[3:0];
		r_type = 1;
	end
	else begin
		r_type = 0;
		alu_in[3:0] = op_i[3:0];
	end

end

endmodule

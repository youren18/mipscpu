module cpu_ctl(
    input [31:0] instr,
    output beq, bne, bgez, j, jal, jr, jump_reg, reg_write2, rs_read,
    mem_write, shamt,sys_call,
    output [1:0]mode,
    output [4:0]RA_in

);
    wire [4:0] rs, rt, rd, mid;
    wire [5:0] op,funct;
    wire [5:0] sham;
    assign op=instr[31:26];
    assign rs=instr[25:21];
    assign rt=instr[20:16];
    assign rd=instr[15:11];
    assign sham=instr[10:6];
    assign funct=instr[5:0];

    wire iszero,not_rs;
    assign iszero=(op==6'h00)?1:0;
    assign beq=(op==6'h04);
    assign bne=(op==6'h05);
    assign bgez=(op==6'h01);
    assign jr=(funct==6'h08) & iszero;
    assign jal=(op==6'h03); 
    assign j=(op==6'h02) | jr | jal;
    assign jump_reg=j;
    assign reg_write2=(op==6'h23) | (op==6'h03);
    assign mem_write=(op==6'h2b) | (op==6'h29);
    assign shamt=((funct==6'h00) | (funct==6'h02) | (funct==6'h03)) & iszero;
    assign not_rs=~shamt;
    assign sys_call=(funct==6'b001100) & iszero;
    assign mode=(op==6'h29)?2:0; //sh, sw
    assign  rs_read=(iszero | beq | bne | bgez | jr) & not_rs;

    multiplexer ldf(sys_call, rs, 2, mid);
    multiplexer dsfs(shamt, mid, rt, RA_in);
    

endmodule   

module multiplexer(
    input sel,
    input is_zero, is_one,
    output out
);
    parameter len=32;
    wire [len-1:0] is_zero, is_one,out;
    assign out= (sel==1)?is_one: is_zero;
endmodule
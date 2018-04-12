
module cpu(
    input rst,
    input clk,
    input [2:0] freq,
    input [2:0] showsth,
    output reg[7:0]SEG,AN

);
    
    //reg [31:0] mem[0:100];
    reg [31:0] instr;
    wire [4:0] rs, rt, rd;
    assign rs=instr[25:21];
    assign rt=instr[20:16];
    assign rd=instr[15:11];
    assign sham=instr[10:6];
    wire beq, bne, bgez, j, jal, jr, jump_reg, reg_write2, rs_read,
    mem_write, shamt,sys_call;
    wire [1:0]mode;
    wire [4:0]RA_in;

    wire halt=(A==10) & sys_call;
    wire sum=(~halt) | rst;
    initial begin
      instr=0;
        //$readmemh("test.txt", mem);
    end
//指令寄存器的地址数据 instr 和 mem关联
//mips rom
     instruction_memory dss(pc_out,  instr);
    
    cpu_ctl fefdg(
          instr, beq, bne, bgez, j, jal, jr, jump_reg, reg_write2, rs_read,
         mem_write, shamt,sys_call,mode, RA_in
     );

//alu 控制器
    wire  Rt_write, reg_write1;
    wire  [3:0]alu_in;
    alu_ctl sdff(instr, alu_in, Rt_write, reg_write1);

//PC跳转
    wire pc_sel;
    wire [9:0]pc_in, pc_out;
    wire [9:0]pcin1=pc_in + (pc_out+1);
    assign pc_sel=(beq & alu_equal) | (bne & ~alu_equal) | (bgez_ctl & bgez) | jump_reg;

    /*module PC_out(
    input clk,
    input rst, sum, sel,
    input [9:0]im,
    output reg [9:0]pc

);*/
     assign pc_in=jump_reg?(jr? A[9:0]: instr[9:0]):pcin1;
     PC_out hh(clk, rst, sum, pc_sel, pc_in, pc_out);//需要pc_in来源
   
   
    
//regfile组装
     wire [31:0] write_data, A, B, pc32;
     wire [4:0]rW, rA, rB;
     wire w_enable;
     wire bgez_ctl = ~A[31];
    
     assign w_enable= reg_write1 | reg_write2;
     assign rW=Rt_write? rt: (jal? 6'h1f: rd);
     assign rA=RA_in;
     assign rB=sys_call? 4: rt;
     assign write_data=mem_write? ram_data_out: (jal? pc32: alu_out);//三种输入来源
     
     data_extend#(10) pc_10to32 (1, pc_out+1, pc32);
     //module data_extend(input sign,input in_data,output out_data);
     register_file regfile(clk, w_enable, rW, rA, rB,  write_data, A, B);

     //

    /*module register_file(
    input clk, we;
    input [4:0]rW, rA, rB,
    input [31:0] win,
    output [31:0]A, B
    );*/

//alu组装
     wire [31:0]X, Y, alu_out, sham32, im32;
     wire [4:0]alu_sel;
     wire alu_equal;
     data_extend#(5) sham_5to32(0, sham, sham32);
     data_extend#(16) im_16to32(1, instr[15:0], im32);
     assign X=A;
     assign Y=shamt? sham32: (rs_read? im32: B);//还要考虑srav,srlv，加一个选择器


    //mips ram组装
    wire [11:0] ram_addr={alu_out[11:0]};
    wire [31:0] ram_data_in, ram_data_out;
    wire [1:0] ram_mode;
    wire ram_write;

    assign ram_mode=mode;
    assign ram_write = mem_write;
    assign ram_data_in=B;
    ram hjj(clk, ram_write, ram_mode, ram_addr, ram_data_in, ram_data_out);

//统计结果
   /*module statistics_para(input clk,input rst,input j,input b,input suc_b,input halt,output no_j_count,output j_count,output j_ok_count,output circle_count);
    reg [31:0] j_count;//有条件
    reg [31:0] no_j_count;//无条件
    reg [31:0] j_ok_count;//有条件成功
    reg [31:0] circle_count;//总周期
    */
    wire b,suc_b;
    wire [31:0] b_count, j_count, b_suc_count, circle_count,sysout;//系统调用定义
    assign b=bne | beq |bgez;
    assign suc_b=(bne&~alu_equal) | (beq & alu_equal) | (bgez_ctl & bgez);
    statistics_para final(clk, rst, j, b, suc_b, halt, b_count, j_count, b_suc_count, circle_count);

//显示结果

    /*module show(
     input clk,
     input rst,
     input [2:0]sel,
     input [31:0]SyscallOut, T_all, T_branch, T_suc, T_jump;
     output reg[7:0]SEG,AN
    );
    */
    always@(posedge clk) begin
        if(rst) sysout=0;
        else if(halt) sysout=B;
        else sysout=sysout;
    end
    
    show ds(clk,rst,showsth,sysout, circle_count,b_count,b_suc_count,j_count);
endmodule


`timescale 1ns / 1ps
//owtime dff(clk, power_light, start_light, totaltime, left, SEG,AN); 
module show(
     input clk,
     input rst,
     input [2:0]sel,
     input [31:0]SyscallOut, T_all, T_branch, T_suc, T_jump,
     output reg[7:0]SEG,AN
    );
    wire [7:0] seg1,an1,seg2,an2,seg3,an3,seg4,an4,seg5,an5,seg6,an6,seg7,an7,seg8,an8,temp;//连接数码管的使能端  
	wire clk_d, clk_N;
    //阶段剩余时间的即时显示，高低位
    reg [3:0] show1,show2,show3,show4,show5,show6,show7,show8;
    reg power=1; 
	divider#(100) lp(clk,clk_d);

    reg [3:0]count;
    reg [31:0]hh;
      always@(posedge clk_d)begin
                 if(sel==0 || sel>4) begin
                    if(count<7) count=count+1;
                    else count=0; 
                end
                else begin
                    if(count<4) count=count+1;
                    else count=0; 
                end
     end
     
         
     always@(*)begin
            if(rst) begin 
                show1=0;show2=0;show3=0;show4=0;
                show5=0;show6=0;show7=0;show8=0; 
            end
            else begin
                if(sel==0 || sel>4) begin//系统调用
                     show1=SyscallOut[3:0];
                     show2=SyscallOut[7:4];
                     show3=SyscallOut[11:8];
                     show4=SyscallOut[15:12];
                      show5=SyscallOut[19:16];
                      show6=SyscallOut[23:20];
                      show7=SyscallOut[27:24];
                     show8=SyscallOut[31:28];
               
                 end
                 else  begin //总周期
                     if(sel==1) hh=T_all;
                     else if(sel==2) hh=T_branch;
                     else if(sel==4) hh=T_suc;
                     else hh=T_jump;
                     show1=hh%10;
                     show2=(hh/10)%10;
                     show3=(hh/100)%10;
                     show4=(hh/1000)%10;
                     show5=0;show6=0;show7=0;show8=0;
                  end
           end
    end
          
      always@(*)begin
             if(sel==0 || sel>4)  begin
                if(count==0) begin SEG=seg1; temp=an1; end
                else if(count==1) begin SEG=seg2; temp=an2; end
                else if(count==2) begin SEG=seg3; temp=an3; end
                else if(count==3) begin SEG=seg4; temp=an4; end
                else if(count==4)  begin SEG=seg5; temp=an5; end
                else if(count==5)  begin SEG=seg6; temp=an6; end
                else if(count==6)  begin SEG=seg7; temp=an7; end
                else begin SEG=seg8; temp=an8; end
            end     
            else begin
                if(count==0) begin SEG=seg1; temp=an1; end
                else if(count==1) begin SEG=seg2; temp=an2; end
                else if(count==2) begin SEG=seg3; temp=an3; end
                else if(count==3) begin SEG=seg4; temp=an4; end
            end    

               if(power==0) begin AN=8'b11111111;         end
               else begin AN=temp;   end          
       
        end
	/*
	 always@(*)begin
			if({clk_d,clk_d2,clk_d3}==0) begin SEG=seg5; temp=an5; end
	        else if({clk_d,clk_d2,clk_d3}==1) begin SEG=seg; temp=an; end
			else if({clk_d,clk_d2,clk_d3}==2) begin SEG=seg3; temp=an3; end
			else if({clk_d,clk_d2,clk_d3}==3||{clk_d,clk_d2,clk_d3}==4) begin SEG=seg2; temp=an2; end
			else begin SEG=seg4; temp=an4; end
			
			//if(start==0 && complete==0) begin//暂停状态闪烁
			     if(power==0) begin AN=8'b11111111;        end
				 else begin AN=temp;   end
			//end
		    end 	 
	 end
	 */

	 time_print#(7) m1(power,show8,seg8,an8);////位置7的显示
	 time_print#(6) m2(power,show7,seg7,an7);////位置6的显示
     time_print#(5) m44(power,show6,seg6,an6);////位置5的显示
     time_print#(4) m5(power,show5,seg5,an5);//位置4的显示
     time_print#(3) m55(power,show4,seg4,an4);////位置3的显示
     time_print#(2) m14(power,show3,seg3,an3);////位置2的显示
     time_print#(1) m41(power,show2,seg2,an2);////位置1的显示
	 time_print#(0) m5(power,show1,seg1,an1);////位置0的显示	 	 
endmodule

//该模块已经考虑了电源开关，电源关则无显示
module time_print(	
        input power,
        input [3:0] printnum,
        output reg [7:0] SEG,AN
        );
     parameter position=0;
	always @(*) begin
	    if(power) begin
		    case(printnum)
			0:SEG = 8'b11000000;
			1:SEG = 8'b11111001;
			2:SEG = 8'b10100100;
			3:SEG = 8'b10110000;
			4:SEG = 8'b10011001;
			5:SEG = 8'b10010010;
			6:SEG = 8'b10000010;
			7:SEG = 8'b11111000;
			8:SEG = 8'b10000000;
			9:SEG = 8'b10011000;
			10:SEG = 8'b10001000;
			11:SEG = 8'b10000011;
			12:SEG = 8'b11000110;
			13:SEG = 8'b10100001;
			14:SEG = 8'b10000110;
			15:SEG = 8'b10001110;
		    endcase
		    
		    case(position)
			0:AN = 8'b11111110;
			1:AN = 8'b11111101;
			2:AN = 8'b11111011;
			3:AN = 8'b11110111;
			4:AN = 8'b11101111;
			5:AN = 8'b11011111;
			6:AN = 8'b10111111;
			7:AN = 8'b01111111;
		    endcase
		end
		else begin
		     SEG = 8'b00000000;
		     AN = 8'b11111111;
		end
	end
endmodule


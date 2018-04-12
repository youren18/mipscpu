
`timescale  1ns / 1ps
module divider(clk, clk_N);
input clk;                      
output reg clk_N=0;                 
parameter N = 100_000_000;      // 1Hz的时钿,N=fclk/fclk_N
reg [31:0] counter=0;             /* 计数器变量，通过计数实现分频〿
                                   当计数器仿0计数刿(N/2-1)时，
                                   输出时钟翻转，计数器清零 */
always @(posedge clk)  begin    // 时钟上升沿
         if(counter<N/2)
			counter=counter+1;
		else  begin
		counter=0;
		clk_N=~clk_N;
		end

		 // 功能实现
end                           
endmodule
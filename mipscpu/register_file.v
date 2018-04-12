`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/02/26 10:29:38
// Design Name: 
// Module Name: register_file
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module register_file(
    input clk, we,
    input [4:0]rW, rA, rB,
    input [31:0] win,
    output [31:0]A, B
    );

    reg[31:0]mem[0:31];//顺序？？
    always@(posedge clk) begin
      mem[0]=0;
      if(we && rW != 0) mem[rW]=win;
      else  mem[rW]= mem[rW];

      /*A=mem[rA];
      B=mem[rB];*/

    end
    assign  A=mem[rA];
    assign  B=mem[rB];
   
endmodule

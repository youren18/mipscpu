
module PC_out(
    input clk,
    input rst, sum, sel,
    input [9:0]im,
    output reg [9:0]pc

);
    wire[9:0] temp;
    multiplexer#(10) sdf(sel,pc+1,im,temp);
    initial begin
        pc=0;
    end
    
    always@(posedge clk)begin
      if(rst==1) pc<=0; 
      else if(sum==0) pc<=temp;
      else p<=pc;

    end
    
endmodule


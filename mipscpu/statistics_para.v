module statistics_para(input clk,input rst,input j,input b,input suc_b,input halt,output no_j_count,output j_count,output j_ok_count,output circle_count);
    reg [31:0] j_count;//有条件
    reg [31:0] no_j_count;//无条件
    reg [31:0] j_ok_count;//有条件成功
    reg [31:0] circle_count;//总周期
    
    reg d1,d2;
    initial begin
      d1=0;d2=0;
    end
    always @(posedge halt) begin
        if(rst) d1=0;
        else d1=1;
    end

    always @(posedge clk) begin
        if(rst) d2=0;
        else d2=d1;
    end

    always @(posedge clk) begin
       if (rst == 1) begin
            j_count <= 0;
            no_j_count <= 0;
            j_ok_count <= 0;
            circle_count <= 0;
        end
        else begin
        //无条件分支指令数
        if (j == 1) begin
            no_j_count = no_j_count + 1;
        end
        else begin end
        
        //有条件分支指令数
        if (b == 1) begin
            j_count = j_count + 1;
        end
        else begin end

        //有条件成功跳转分支指令数
        if (suc_b == 1) begin
            j_ok_count = j_ok_count + 1;
        end
        else begin end

        //总周期数
        if (halt == 0) begin
            circle_count = circle_count + 1;
        end
        else begin 
            circle_count = circle_count + {31'b0,(d1-d2)};
        end 

        end
    end
endmodule

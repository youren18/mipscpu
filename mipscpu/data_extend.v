//sign=1为有符号扩展
//sign=0为无符号扩展
module data_extend(input sign,input in_data,output out_data);
    parameter in_data_length=16;
    wire [in_data_length - 1:0] in_data;
    reg [31:0] out_data;
    always@(*)begin
    out_data[31:32-in_data_length] <= in_data;
    
    if(sign == 1)
    begin
        out_data <= out_data >>> (32 - in_data_length);
    end
    else
    begin
        out_data <= out_data >> (32 - in_data_length);
    end
    end
       
endmodule


//sel=1为有符号拓展
//sel=0为无符号扩展


module extend_16to32(input sel, input [15:0]immediate_16, output [31:0]immediate_32);

    assign immediate_32 = (sel)? {{16{immediate_16[15]}}, immediate_16[15:0]} : {{16{1'b0}}, immediate_16[15:0]};

endmodule   

module extend_5to32(input sel, input [4:0]immediate_5, output [31:0]immediate_32);

    assign immediate_32 = (sel)? {{27{immediate_16[15]}}, immediate_16[4:0]} : {{27{1'b0}}, immediate_16[4:0]};

endmodule   
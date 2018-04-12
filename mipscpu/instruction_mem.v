
module instruction_memory(pc,  data);
    input [9:0] pc;
    output [31:0]data;
    reg [31:0] mem[0:1023];
    initial begin
       $readmemh("test.txt", mem);
    end
    assign data=mem[pc];
    
endmodule
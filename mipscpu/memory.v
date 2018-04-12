
//mode=0 字访问;mode=1 字节访问; mode=2时 半字访问
module ram(
    clk,we,mode,ram_addr,data_in,data_out
);
    input clk,we;
    input [1:0]mode;
    input [11:0]ram_addr;
    input [31:0]data_in;
    output reg[31:0]data_out;
 
    reg [7:0] D0[0:1023];
    reg [7:0] D1[0:1023];
    reg [7:0] D2[0:1023];
    reg [7:0] D3[0:1023];

    wire h_byteaddr=ram_addr[1];
    wire [1:0]byteaddr=ram_addr[1:0];
    wire [9:0]addr=ram_addr[11:2];
    //assign data_out=mem[addr];
    always@(posedge clk)begin
      if(we)begin
        if(mode==0)  begin
           D0[addr]=data_in[7:0];
           D1[addr]=data_in[15:8];
           D2[addr]=data_in[23:16];
           D3[addr]=data_in[31:24];

        end
        else if(mode==1)begin
            if(h_byteaddr==0) begin
               D0[addr]=data_in[7:0];
               D1[addr]=data_in[15:8];
               D2[addr]=D2[addr];
               D3[addr]=D3[addr];
               end
            else begin
               D0[addr]=D0[addr];
               D1[addr]=D1[addr];
               D2[addr]=data_in[7:0];
               D3[addr]=data_in[15:8];
            end
        end

        else if(mode==2)begin
            D0[addr]=D0[addr];
            D1[addr]=D1[addr];
            D2[addr]=D2[addr];
            D3[addr]=D3[addr];
            if(byteaddr==0) D0[addr]=data_in[7:0];
            else if(byteaddr==1) D1[addr]=data_in[7:0]; 
            else if(byteaddr==2) D2[addr]=data_in[7:0]; 
            else  D3[addr]=data_in[7:0]; 
        end

        else begin
            D0[addr]=D0[addr];
            D1[addr]=D1[addr];
            D2[addr]=D2[addr];
            D3[addr]=D3[addr];
        end

      end
      else begin
        D0[addr]=D0[addr];
        D1[addr]=D1[addr];
        D2[addr]=D2[addr];
        D3[addr]=D3[addr];
      end
    end

    always@(*)begin
        if(mode==0) data_out={D3[addr],D2[addr],D1[addr],D0[addr]};
        else if(mode==1) begin
            if(h_byteaddr==0)
            data_out={16'b0,D1[addr],D0[addr]};
            else
            data_out={16'b0,D3[addr],D2[addr]};
        end
        else if(mode==2)begin
            if(byteaddr==0)  data_out={24'b0,D0[addr]};
            else if(byteaddr==1) data_out={24'b0,D1[addr]};
            else if(byteaddr==2) data_out={24'b0,D2[addr]};
            else data_out={24'b0,D3[addr]};
        end
    end
endmodule
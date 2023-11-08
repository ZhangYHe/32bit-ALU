`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/07 10:03:48
// Design Name: 
// Module Name: alu_32bit
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


module alu_32bit(
op,input_a,input_b,
CF,OF,ZF,SF,PF,out
    );
    input [31:0] input_a,input_b;
    input [10:0] op;
    output reg[31:0] out;
    output reg CF,OF,ZF,SF,PF;
   
always@(*)
begin
    case(op)
        //add
        11'b00000100000:
            begin
            out=input_a+input_b;
            OF=((input_a[31]==input_b[31])&&(~out[31]==input_a[31]))?1:0;
            ZF=(out==0)?1:0;
            CF=0;
            SF=out[31];
            // 1的个数为偶数，PF=1
            PF=~(^out[31:0]);
            end
        //addu
        11'b00000100001:
            begin
            {CF,out}=input_a+input_b;
            ZF=(out==0)?1:0;
            OF=0;
            SF=out[31];
            PF=~(^out[31:0]);
            end
        //sub
        11'b00000100010:
            begin
            out=input_a-input_b;
            OF=((input_a[31]==0&&input_b[31]==1&&out[31]==1)||(input_a[31]==1&&input_b[31]==0&&out[31]==0))?1:0;
            ZF=(input_a==input_b)?1:0;
            CF=0;
            SF=out[31];
            PF=~(^out[31:0]);
            end
        //subu
        11'b00000100011:
            begin
            {CF,out}=input_a-input_b;
            ZF=(out==0)?1:0;
            OF=0;
            SF=out[31];
            PF=~(^out[31:0]);
            end
        //and
        11'b00000100100:
            begin
            out=input_a&input_b;
            ZF=(out==0)?1:0;
            CF=0;
            OF=0;
            SF=out[31];
            PF=~(^out[31:0]);
            end
        //or
        11'b00000100101:
            begin
            out=input_a|input_b;
            ZF=(out==0)?1:0;
            CF=0;
            OF=0;
            SF=out[31];
            PF=~(^out[31:0]);
            end
        //xor
        11'b00000100110:
            begin
            out=input_a^input_b;
            ZF=(out==0)?1:0;
            CF=0;
            OF=0;
            SF=out[31];
            PF=~(^out[31:0]);
            end
        //nor
        11'b00000100111:
            begin
            out=~(input_a|input_b);
            ZF=(out==0)?1:0;
            CF=0;
            OF=0;
            SF=out[31];
            PF=~(^out[31:0]);
            end
        //slt
        11'b00000101010:
            begin                        
            if(input_a[31]==1&&input_b[31]==0)
                out=1;
            else if(input_a[31]==0&&input_b[31]==1)
                out=0;
            else 
                out=(input_a<input_b)?1:0;
           OF=out; 
           ZF=(out==0)?1:0;
           CF=0;   
           SF=out[31];
           PF=~(^out[31:0]);           
           end
        //sltu
        11'b00000101011:
            begin
                out=(input_a<input_b)?1:0;
                CF=out;
                ZF=(out==0)?1:0;
                OF=0;
                SF=out[31];
                PF=~(^out[31:0]);
            end
        //shl
        11'b00000000100:
            begin   
            {CF,out}=input_a<<input_b;
            OF=0;
            ZF=(out==0)?1:0;
            SF=out[31];
            PF=~(^out[31:0]);
            end
        //shr
        11'b00000000110:
            begin
            out=input_a>>input_b;
            CF=input_a[input_b-1];
            OF=0;
            ZF=(out==0)?1:0;
            SF=out[31];
            PF=~(^out[31:0]);
            end
        //sar
        11'b00000000111:
            begin
            out=($signed(input_a))>>>input_b;
            CF=input_a[input_b-1];
            OF=0;
            ZF=(out==0)?1:0;
            SF=out[31];
            PF=~(^out[31:0]);
            end
        //truncate
        11'b00000101100:
            begin
                case(input_b)
                    32'b0000_0000_0000_0000_0000_0000_0000_1000:
                        begin
                        out=~(input_a&32'b1111_1111_1111_1111_1111_1111_1111_0000);
                        SF=out[31];
                        CF=0;
                        OF=0;
                        ZF=(out==0)?1:0;
                        PF=~(^out[31:0]);
                        end
                    32'b0000_0000_0000_0000_0000_0000_1000_0000:
                        begin
                        out=~(input_a&32'b1111_1111_1111_1111_1111_1111_0000_0000);
                        SF=out[31];
                        CF=0;
                        OF=0;
                        ZF=(out==0)?1:0;
                        PF=~(^out[31:0]);
                        end
                    32'b0000_0000_0000_0000_0000_1000_0000_0000:
                        begin
                        out=~(input_a&32'b1111_1111_1111_1111_1111_0000_0000_0000);
                        SF=out[31];
                        CF=0;
                        OF=0;
                        ZF=(out==0)?1:0;
                        PF=~(^out[31:0]);
                        end
                    32'b0000_0000_0000_0000_1000_0000_0000_0000:
                        begin
                        out=~(input_a&32'b1111_1111_1111_1111_0000_0000_0000_0000);
                        SF=out[31];
                        CF=0;
                        OF=0;
                        ZF=(out==0)?1:0;
                        PF=~(^out[31:0]);
                        end
                    32'b0000_0000_0000_1000_0000_0000_0000_0000:
                        begin
                        out=~(input_a&32'b1111_1111_1111_0000_0000_0000_0000_0000);
                        SF=out[31];
                        CF=0;
                        OF=0;
                        ZF=(out==0)?1:0;
                        PF=~(^out[31:0]);
                        end
                    32'b0000_0000_1000_0000_0000_0000_0000_0000:
                        begin
                        out=~(input_a&32'b1111_1111_0000_0000_0000_0000_0000_0000);
                        SF=out[31];
                        CF=0;
                        OF=0;
                        ZF=(out==0)?1:0;
                        PF=~(^out[31:0]);
                        end
                    32'b0000_1000_0000_0000_0000_0000_0000_0000:
                        begin
                        out=~(input_a&32'b1111_0000_0000_0000_0000_0000_0000_0000);
                        SF=out[31];
                        CF=0;
                        OF=0;
                        ZF=(out==0)?1:0;
                        PF=~(^out[31:0]);
                        end
                endcase
            end
        //tunr


    endcase
end
endmodule

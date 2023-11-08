`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/07 11:18:39
// Design Name: 
// Module Name: testbench
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


module testbench(

    );
    reg [10:0] op;
    reg [31:0] input_a,input_b;
    wire [31:0] out;
    wire CF,OF,ZF,SF,PF;
    alu_32bit alu_32bit(op,input_a,input_b,CF,OF,ZF,SF,PF,out);
    initial
    begin
    //add
         op=11'b00000100000;        
         input_a=32'hf2340000;
         input_b=32'h80000000;
    #20  input_a=32'h7fffffff;
         input_b=32'h70000001;
    #20  input_a=32'h7fffffff;
         input_b=32'hf0000001;
    #20  input_a=32'hffffffff;
         input_b=32'h00000001;
    //addu          
    #20  op=11'b00000100001;   
         input_a=32'hf2340000;
         input_b=32'h80000000;
    #20  input_a=32'h7fffffff;
         input_b=32'h70000001;
    #20  input_a=32'hffffffff;
         input_b=32'h00000001;
    //sub    
    #20  op=11'b00000100010;        
         input_a=32'h72340000;
         input_b=32'h60000000;
    #20  input_a=32'h7fffffff;
         input_b=32'hf0000001;
    #20  input_a=32'hf00fffff;
         input_b=32'h7ffffff1;
    #20  input_a=32'hffffffff;
         input_b=32'hffffffff;
    #20  input_a=32'hf0000000;
         input_b=32'h0fffffff; 
    //subu
    #20  op=11'b00000100011;        
         input_a=32'h72340000;
         input_b=32'h60000000;
    #20  input_a=32'h7fffffff;
         input_b=32'hf0000001;
    #20  input_a=32'hffffffff;
         input_b=32'hffffffff;
    #20  input_a=32'hf0000000;
         input_b=32'h0fffffff; 
    //and
    #20  op=11'b00000100100;        
         input_a=32'h72340000;
         input_b=32'h60000000;
    #20  input_a=32'h7fffffff;
         input_b=32'h00000000; 
    //or
    #20  op=11'b00000100101;        
         input_a=32'h00000000;
         input_b=32'h00000000;
    #20  input_a=32'h7fffffff;
         input_b=32'hf0000001;
    //xor
    #20  op=11'b00000100110;        
         input_a=32'ha0000000;
         input_b=32'h50000000;
    #20  input_a=32'h7fffffff;
         input_b=32'hf0000001;
    //nor
    #20  op=11'b00000100111;        
         input_a=32'h123451ff;
         input_b=32'h60000000;
    #20  input_a=32'h7fffffff;
         input_b=32'hf0000001;
    //slt
    #20  op=11'b00000101010;        
         input_a=32'h72340000;
         input_b=32'hf0000000;
    #20  input_a=32'h7000000f;
         input_b=32'h7f000001;
    #20  input_a=32'hf0001231;
         input_b=32'h7ac34545;
    //sltu
    #20  op=11'b00000101011;        
         input_a=32'h72340000;
         input_b=32'hf0000000;
    #20  input_a=32'h7000000f;
         input_b=32'h7f000001;
    #20  input_a=32'hf0001231;
         input_b=32'h7ac34545;
    //shl
    #20  op=11'b00000000100;
         input_a=32'hffffffff;
         input_b=32'd5;
    //shr
    #20  op=11'b00000000110;
         input_a=32'hffffffff;
         input_b=32'd5;
    //sar
    #20  op=11'b00000000111;
         input_a=32'hffffffff;
         input_b=32'd3;
    #20  input_a=32'h0fffffff;
         input_b=32'd5;
     //truncate
     #20  op=11'b00000101100;
         input_a=32'hffffffff;
         input_b=32'b0000_0000_0000_0000_0000_0000_0000_1000;
     #20 input_a=32'hffffffff;
         input_b=32'b0000_0000_0000_0000_0000_0000_1000_0000;
     #20 input_a=32'hffffffff;
         input_b=32'b0000_0000_0000_0000_0000_1000_0000_0000;
     #20 input_a=32'hffffffff;
         input_b=32'b0000_0000_0000_0000_1000_0000_0000_0000;
     #20 input_a=32'hffffffff;
         input_b=32'b0000_0000_0000_1000_0000_0000_0000_0000;
     #20 input_a=32'hffffffff;
         input_b=32'b0000_0000_1000_0000_0000_0000_0000_0000;
     #20 input_a=32'hffffffff;
         input_b=32'b0000_1000_0000_0000_0000_0000_0000_0000;
    end
    
endmodule


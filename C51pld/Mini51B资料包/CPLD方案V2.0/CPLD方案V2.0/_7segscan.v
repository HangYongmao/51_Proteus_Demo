module _7segscan(clk,dataA,dataB,dataC,dataD,segd,sel);
input [7:0]dataA;
input [7:0]dataB;
input [7:0]dataC;
input [7:0]dataD;
input clk;
output [7:0]segd;
output [3:0]sel;

reg [7:0]segd;
reg [3:0]sel;
reg [1:0]i;

always@(posedge clk)
begin
	i<=i+1;
	case(i)
		0:begin segd=dataA;sel=8;end
		1:begin segd=dataB;sel=4;end
		2:begin segd=dataC;sel=2;end
		3:begin segd=dataD;sel=1;end
		default:begin segd=8'bx;sel=0;end
	endcase
end
endmodule

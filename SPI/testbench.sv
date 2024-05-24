// Code your testbench here
////////////////////////////////Interface////////////////////////////
interface  spi_if  #(parameter SPI_MODE = 0) 
 (input logic i_Rst_L,i_Clk);
logic        o_RX_DV; 
logic  [7:0] o_RX_Byte;  
logic        i_TX_DV =0;  
logic  [7:0] i_TX_Byte=0; 
bit          i_SPI_Clk;
logic        o_SPI_MISO;
logic        i_SPI_MOSI =0;
logic        i_SPI_CS_n =1;

// Signals Sampled with i_Clk
clocking cb @ (posedge i_Clk);
  default input #8 output #2;
  input o_RX_DV, o_RX_Byte;
  inout i_TX_DV, i_TX_Byte;
endclocking 

// Signals Sampled wwith i_SPI_Clk
clocking cb2 @(posedge i_SPI_Clk);
  default input #8 output #2;
  input o_SPI_MISO;
  inout i_SPI_MOSI;
endclocking

// Modport for testbench module
modport Tb(clocking cb, clocking cb2 ,output i_SPI_Clk , i_SPI_CS_n);

endinterface
    
/////////////////////////randomization class/////////////////////////
class mycons;
// Declaration of random variables
rand logic [7:0] i_TX_Byte_r;
rand logic i_SPI_MOSI_r, i_SPI_CS_n_r;

// Constraints of the random variables
  constraint variables_random {
    i_TX_Byte_r dist {
      [0:49] := 20,
      [50:99] := 10,
      [100:149] := 35,
      [150:199] := 25,
      [200:255] := 10
    };
    i_SPI_MOSI_r dist {
      1 := 50,
      0 := 50
    };
    i_SPI_CS_n_r dist {
      1 := 2,
      0 := 98
    };
  }
endclass

///////////////////////////////test////////////////////////////////// 
module test (spi_if.Tb _if1);

bit vir_clk;   // declare an internal variable for clock
mycons cls = new(); // generate a new class of mycons
  
// generating the clock using vir_clk   
always @(_if1.cb)
  begin
    if (~ _if1.i_SPI_CS_n) begin
        #80;
      vir_clk <=  ~vir_clk;end
    else 
      vir_clk <= 0;
  end
assign _if1.i_SPI_Clk = vir_clk & ~ _if1.i_SPI_CS_n;

// Randomize the data and assign the values in differnet times
always @( _if1.cb)
  begin
    cls.randomize();
    _if1.cb2.i_SPI_MOSI <= cls.i_SPI_MOSI_r;
    _if1.i_SPI_CS_n <= cls.i_SPI_CS_n_r;
  end  
always @( _if1.cb)
  begin
    _if1.cb.i_TX_Byte <= cls.i_TX_Byte_r;
    repeat(9) @(_if1.cb);
  end
  
// Setting i_TX_DV every 8 i_SPI_Clk cycles
always @(_if1.cb)
  begin
    if (~_if1.i_SPI_CS_n) begin
       _if1.cb.i_TX_DV <= 1;
      repeat(31) @ (_if1.cb)
       begin
       _if1.cb.i_TX_DV <= 0;
        if (_if1.i_SPI_CS_n)
          break;
      end
    end
  end
  
/////////////////////////coverage point /////////////////////////////
// First Covergroup triggered by i_Clk
covergroup cg @(_if1.cb);
    option.per_instance = 1;
		o_RX_DV: coverpoint  _if1.cb.o_RX_DV {
      bins tran_01 = (0=>1);
    }
        i_SPI_CS_n: coverpoint  _if1.i_SPI_CS_n {
      bins tran_01 = (0=>1);
      bins tran_10 = (1=>0);
    }
    	i_TX_DV: coverpoint  _if1.cb.i_TX_DV  {
      bins tran_01 = (0=>1);
    }
endgroup
  
// Second Covergroup triggered by i_TX_DV
covergroup cg2 @(negedge _if1.cb.i_TX_DV);
    option.per_instance = 1;
		i_TX_Byte: coverpoint  _if1.cb.i_TX_Byte {
          bins first_range = {[0:49]};
          bins second_range = {[50:99]};
          bins third_range = {[100:149]};
          bins fourth_range = {[150:199]};
          bins last_range  = {[200:255]};
    }
endgroup
 
// Intialize covergroups
cg cov1;
cg2 cov2;
initial begin 
  cov1=new();
  cov2=new();
end
 
endmodule
  
////////////////////////////top module /////////////////////////////
module Top;
 
logic clk,reset;
always #20 clk=~clk; // Clock system generation

// Interface instantiation
spi_if #(.SPI_MODE(1)) _if2 (reset, clk); 
  
// DUT Module instantiation 
SPI_Slave #(.SPI_MODE(1)) DUT (  
 .i_Rst_L (reset),   
 .i_Clk (clk),      
 .o_RX_DV (_if2.o_RX_DV),    
 .o_RX_Byte (_if2.o_RX_Byte),  
 .i_TX_DV (_if2.i_TX_DV),    
 .i_TX_Byte (_if2.i_TX_Byte),  
 .i_SPI_Clk (_if2.i_SPI_Clk),
 .o_SPI_MISO (_if2.o_SPI_MISO),
 .i_SPI_MOSI (_if2.i_SPI_MOSI),
 .i_SPI_CS_n (_if2.i_SPI_CS_n)     
 );
    
// Testbench Module Intantiation
test _testbench (_if2.Tb);
 
// Starting the testbench
initial
 begin 
     clk=0;
     reset=0;
     #15;
     reset=1;
     #10000;
     reset=0;
     #1
     $finish;
 end

// Generate the waveform of Signals
initial  
 begin 
     $dumpfile("dump.vcd");
     $dumpvars;
 end
    
//////////////////////// assertion ///////////////////////////
 
/// assert that when i_TX_DV is high i_TX_Byte stored in temp variable r_TX_Byte
property i_tx_DV;
  @(posedge DUT.i_Clk) disable iff (DUT.i_SPI_CS_n || ~reset) DUT.i_TX_DV |=> (DUT.r_TX_Byte == DUT.i_TX_Byte); 
endproperty 
  assert property (i_tx_DV) ;
  cover property (i_tx_DV);
    
/// assert that ALWAYS the MISO signal equals MSB of r_TX_Byte  
property SPI_MISO;
  @(posedge DUT.i_Clk) disable iff (DUT.i_SPI_CS_n || ~reset) DUT.i_TX_DV |-> ##2 (DUT.i_TX_Byte [7] == DUT.o_SPI_MISO);
endproperty 
  assert property(SPI_MISO); 
  cover property (SPI_MISO);
 
/// assert that o_RX_DV is high in rising edge of r3_RX_Done
property o_rx_DV;
  @(posedge DUT.i_Clk) disable iff (DUT.i_SPI_CS_n || ~reset) 
  $rose(DUT.r_RX_Done) |-> ##2 DUT.o_RX_DV;
endproperty 
   assert property (o_rx_DV );
   cover property (o_rx_DV);  
      
/// assert that  while o_RX_DV is high  o_RX_Byte stored to r_RX_Byte
property rx_data;
  @(posedge DUT.i_Clk) disable iff (DUT.i_SPI_CS_n || ~reset) DUT.o_RX_DV |-> (DUT.o_RX_Byte == DUT.r_RX_Byte); 
endproperty 
    assert property(rx_data); 
    cover property (rx_data);
      
/// assert that ALWAYS the MOSI signal is stored in LSB of r_Temp_RX   
 property SPI_MOSI;
   @(negedge DUT.i_SPI_Clk) disable iff (DUT.i_SPI_CS_n || ~reset) ##1 (DUT.r_Temp_RX_Byte[0] == $past(DUT.i_SPI_MOSI));
endproperty 
   assert property(SPI_MOSI); 
   cover property (SPI_MOSI);
          
endmodule

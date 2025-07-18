module test_RAM_2048_8 ();
  parameter		word_size = 8;
  parameter		addr_size = 11;
  parameter		mem_depth = 128;
  parameter		 num_col = 16;
  parameter		col_addr_size = 4;
  parameter		row_addr_size = 7;
  parameter 		initial_pattern = 8'b0000_0001;
  parameter 		Hi_Z_pattern = 8'bzzzz_zzzz;

  reg  [word_size-1 : 0] 	data_to_memory;
  reg  			CS_b, WE_b, OE_b;


  integer 		col, row;
  wire [col_addr_size-1:0] 	col_addr = col;
  wire [row_addr_size-1:0] 	row_addr = row;
  wire [addr_size-1:0] 	addr = {row_addr, col_addr};

  parameter 		t_WPC = 8;		// Write pattern cycle time (Exceeds min)
  parameter		 t_RPC = 12;		// Read pattern cycle time (Exceeds min)
  parameter		 latency_Zero_Delay = 5000;
  parameter 		latency_Non_Zero_Delay = 18000;
  //parameter 		stop_time = 7200;	// For zero-delay simulation
  parameter 		stop_time = 80000;	// For non-zero delay simulation
  
// Three-state, bi-directional I/O bus

  wire [word_size-1 : 0] 
    data_bus = ((CS_b == 0) && (WE_b == 0) && (OE_b == 1)) 
      ? data_to_memory : Hi_Z_pattern;

  wire [word_size-1 : 0] 
    data_from_memory = ((CS_b == 0) && (WE_b == 1) && (OE_b == 0))
      ?   data_bus : Hi_Z_pattern;

  RAM_2048_8 M1 (data_bus, addr, CS_b, OE_b, WE_b);	// UUT

  initial #stop_time $finish;
/*
// Zero delay test: Write walking ones to memory
  initial begin
    CS_b = 0;
    OE_b = 1;
    WE_b = 1;
    for (col= 0; col <= num_col-1; col = col +1) begin
    data_to_memory = initial_pattern;

    for (row = 0; row <= mem_depth-1; row = row + 1) begin
      #1 WE_b = 0;
      #1 WE_b = 1;
       data_to_memory = 
         {data_to_memory[word_size-2:0],data_to_memory[word_size-1]};
      end
    end
  end
 
// Zero delay test: Read back walking ones from memory
  initial begin
    #latency_Zero_Delay;
    CS_b = 0;
    OE_b = 0;
    WE_b = 1;
    for (col= 0; col <= num_col-1; col = col +1) begin
      for (row = 0; row <= mem_depth-1; row = row + 1) begin
        #1;
      end
    end
  end
*/
///*
// Non-Zero delay test: Write walking ones to memory
// Writing controlled by WE_b
  initial begin
    CS_b = 0;
    OE_b = 1;
    WE_b = 1;

    for (col= 0; col <= num_col-1; col = col +1) begin
      data_to_memory = initial_pattern;
      for (row = 0; row <= mem_depth-1; row = row + 1) begin
        #(t_WPC/8) WE_b = 0;
        #(t_WPC/4);
        #(t_WPC/2) WE_b = 1;
        data_to_memory = 
          {data_to_memory[word_size-2:0],data_to_memory[word_size-1]};
        #(t_WPC/8);  
      end 
    end
  end

// Non-Zero delay test: Read back walking ones from memory
  initial begin
    #latency_Non_Zero_Delay;
    CS_b = 0;
    OE_b = 0;
    WE_b = 1;
    for (col= 0; col <= num_col-1; col = col +1) begin
      for (row = 0; row <= mem_depth-1; row = row + 1) begin
        #t_RPC;
      end
    end
  end
 //*/
 
// Testbench probe to monitor write activity
reg  [word_size-1:0] write_probe;
always @ (posedge M1.WE_b)
    case (M1.col_addr)
    0: write_probe = M1.RAM_col0[M1.row_addr];   
    1: write_probe = M1.RAM_col1[M1.row_addr];
    2: write_probe = M1.RAM_col2[M1.row_addr];   
    3: write_probe = M1.RAM_col3[M1.row_addr];
    4: write_probe = M1.RAM_col4[M1.row_addr];   
    5: write_probe = M1.RAM_col5[M1.row_addr];
    6: write_probe = M1.RAM_col6[M1.row_addr];   
    7: write_probe = M1.RAM_col7[M1.row_addr];
    8: write_probe = M1.RAM_col8[M1.row_addr];   
    9: write_probe = M1.RAM_col9[M1.row_addr];
    10:write_probe = M1.RAM_col10[M1.row_addr]; 
    11:write_probe = M1.RAM_col11[M1.row_addr];
    12:write_probe = M1.RAM_col12[M1.row_addr]; 
    13:write_probe = M1.RAM_col13[M1.row_addr];
    14:write_probe = M1.RAM_col14[M1.row_addr]; 
    15:write_probe = M1.RAM_col15[M1.row_addr];
  endcase
endmodule


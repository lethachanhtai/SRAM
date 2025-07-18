`timescale  1ns / 10ps	

module RAM_2048_8   (data, addr, CS_b, OE_b, WE_b);
  parameter		word_size = 8;
  parameter		addr_size = 11;
  parameter		mem_depth = 128;
  parameter		col_addr_size = 4;
  parameter		row_addr_size = 7;
  parameter 		Hi_Z_pattern = 8'bzzzz_zzzz;
  inout [word_size-1: 0] 	data;
  input [addr_size-1: 0] 	addr;
  input 			CS_b, OE_b, WE_b;

  reg  [word_size-1 : 0] data_int;
  reg  [word_size-1 : 0] RAM_col0 [mem_depth-1 :0]; 	
  reg  [word_size-1 : 0] RAM_col1 [mem_depth-1 :0];
  reg  [word_size-1 : 0] RAM_col2 [mem_depth-1 :0]; 	
  reg  [word_size-1 : 0] RAM_col3 [mem_depth-1 :0];
  reg  [word_size-1 : 0] RAM_col4 [mem_depth-1 :0]; 	
  reg  [word_size-1 : 0] RAM_col5 [mem_depth-1 :0];
  reg  [word_size-1 : 0] RAM_col6 [mem_depth-1 :0]; 	
  reg  [word_size-1 : 0] RAM_col7 [mem_depth-1 :0];
  reg  [word_size-1 : 0] RAM_col8 [mem_depth-1 :0]; 	
  reg  [word_size-1 : 0] RAM_col9 [mem_depth-1 :0];
  reg  [word_size-1 : 0] RAM_col10 [mem_depth-1 :0]; 	
  reg  [word_size-1 : 0] RAM_col11 [mem_depth-1 :0];
  reg  [word_size-1 : 0] RAM_col12 [mem_depth-1 :0]; 	
  reg  [word_size-1 : 0] RAM_col13 [mem_depth-1 :0];
  reg  [word_size-1 : 0] RAM_col14 [mem_depth-1 :0]; 	
  reg  [word_size-1 : 0] RAM_col15 [mem_depth-1 :0];

  wire [col_addr_size-1: 0] 		col_addr = addr[col_addr_size-1: 0]; 
  wire [row_addr_size-1: 0] 	row_addr = addr[addr_size-1: col_addr_size];

  assign data = ((CS_b == 0) && (WE_b == 1) && (OE_b == 0))
     ? data_int: Hi_Z_pattern;

  always @ (data or col_addr or row_addr or CS_b or OE_b or WE_b)
      begin
        data_int = Hi_Z_pattern;
        if ((CS_b == 0) && (WE_b == 0))	// Priority write to memory
          case (col_addr)				// column address
            0: RAM_col0[row_addr] = data;    		
            1: RAM_col1[row_addr] = data;
            2: RAM_col2[row_addr] = data;    		
            3: RAM_col3[row_addr] = data;
            4: RAM_col4[row_addr] = data;    		
            5: RAM_col5[row_addr] = data;
            6: RAM_col6[row_addr] = data;    		
            7: RAM_col7[row_addr] = data;
            8: RAM_col8[row_addr] = data;    		
            9: RAM_col9[row_addr] = data;
            10: RAM_col10[row_addr] = data; 		
            11: RAM_col11[row_addr] = data;
            12: RAM_col12[row_addr] = data; 		
            13: RAM_col13[row_addr] = data;
            14: RAM_col14[row_addr] = data; 		
            15: RAM_col15[row_addr] = data;
          endcase 

        else if ((CS_b == 0) && (WE_b == 1) && (OE_b == 0))  // Read from memory
          case (col_addr)
            0: data_int = RAM_col0[row_addr];   
            1: data_int = RAM_col1[row_addr];
            2: data_int = RAM_col2[row_addr];   
            3: data_int = RAM_col3[row_addr];
            4: data_int = RAM_col4[row_addr];   
            5: data_int = RAM_col5[row_addr];
            6: data_int = RAM_col6[row_addr];   
            7: data_int = RAM_col7[row_addr];
            8: data_int = RAM_col8[row_addr];   
            9: data_int = RAM_col9[row_addr];
            10:data_int = RAM_col10[row_addr]; 
            11:data_int = RAM_col11[row_addr];
            12:data_int = RAM_col12[row_addr]; 
            13:data_int = RAM_col13[row_addr];
            14:data_int = RAM_col14[row_addr]; 
            15:data_int = RAM_col15[row_addr];
          endcase 
      end
  ///*  Comment out of the model for a zero delay functional test.
  specify
    // Parameters for the read cycle
    specparam t_RC = 10;	// Read cycle time
    specparam t_AA = 8;		// Address access time
    specparam t_ACS = 8;	// Chip select access time
    specparam t_CLZ = 2;	// Chip select to output in low-z
    specparam t_OE = 4;		// Output enable to output valid
    specparam t_OLZ = 0;	// Output enable to output in low-z
    specparam t_CHZ = 4;	// Chip de-select to output  in hi-z
    specparam t_OHZ = 3.5;	// Output disable to output in hi-z
    specparam t_OH = 2;		// Output hold from address change

    // Parameters for the write cycle
    specparam t_WC = 7;		// Write cycle time
    specparam t_CW = 5;		// Chip select to end of write
    specparam t_AW = 5;		// Address valid to end of write
    specparam t_AS = 0;		// Address setup time
    specparam t_WP = 5;		// Write pulse width
    specparam t_WR = 0;		// Write recovery time
    specparam t_WHZ = 3;	// Write enable to output in hi-z
    specparam t_DW = 3.5;	// Data set up time
    specparam t_DH = 0;		// Data hold time     
    specparam t_OW = 10;	// Output active from end of write

  //Module path timing specifications
    (addr *> data) = t_AA;				// Verified in simulation
    (CS_b *> data) = (t_ACS, t_ACS, t_CHZ);
    (OE_b *> data) = (t_OE, t_OE, t_OHZ);		// Verified in simulation
      
  //Timing checks (Note use of conditioned events for the address setup,
  //depending on whether the write is controlled by the WE_b or  by CS_b.

  //Width of write/read cycle
    $width (negedge addr, t_WC); 
			
  //Address valid to end of write
    
    $setup (addr, posedge WE_b &&& CS_b == 0, t_AW);	
    $setup (addr, posedge CS_b &&& WE_b == 0, t_AW);	

  //Address setup before write enabled 

    $setup (addr, negedge WE_b &&& CS_b == 0, t_AS);	 
    $setup (addr, negedge CS_b &&& WE_b == 0, t_AS);	 

  //Width of write pulse
    $width (negedge WE_b, t_WP);		

  //Data valid to end of write 
    $setup (data, posedge WE_b &&& CS_b == 0, t_DW);	
    $setup (data, posedge CS_b &&& WE_b == 0, t_DW);	


  //Data hold from end of write 
    $hold (data, posedge WE_b &&& CS_b == 0, t_DH);
    $hold (data, posedge CS_b &&& WE_b == 0, t_DH);

  //Chip sel to end of write 
    $setup (CS_b, posedge WE_b &&& CS_b == 0, t_CW);
    $width (negedge CS_b &&& WE_b == 0, t_CW);

  endspecify 
//*/
endmodule




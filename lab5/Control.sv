//Two-always example for state machine

module control (input  logic Clk, Reset, ClearA_LoadB, Run, M, MA,
                output logic Shift_En, Add, Sub );

    // Declare signals curr_state, next_state of type enum
    // with enum values of A, B, ..., F as the state values
	 // Note that the length implies a max of 8 states, so you will need to bump this up for 8-bits
    enum logic [5:0] {A, BA, BS, CA, CS, DA, DS, EA, ES, FA, FS, GA, GS, HA, HS, IA, ISub, IShift, J}   curr_state, next_state; 

	//updates flip flop, current state is the only one
    always_ff @ (posedge Clk)  
    begin
        if (Reset)
            curr_state <= A;
        else 
            curr_state <= next_state;
    end

    // Assign outputs based on state
	 always_comb
    begin
        
		next_state  = curr_state;	//required because I haven't enumerated all possibilities below
      unique case (curr_state) 

		A :    if (Run)
			if (M)
				next_state = BA;
			else
				next_state = BS;
		BA :	next_state = BS;
		BS :	if (MA)
				next_state = CA;
			else 
				next_state = CS;
		CA :	next_state = CS;
		CS :	if (MA)
				next_state = DA;
			else 
				next_state = DS;
		DA :	next_state = DS;
		DS :	if (MA)
				next_state = EA;
			else 
				next_state = ES;
		EA :	next_state = ES;
		ES :	if (MA)
				next_state = FA;
			else 
				next_state = FS;
		FA :	next_state = FS;
		FS :	if (MA)
				next_state = GA;
			else 
				next_state = GS;
		GA :	next_state = GS;
		GS :	if (MA)
				next_state = HA;
			else 
				next_state = HS;
		HA :	next_state = HS;
		HS :	if (MA)
				next_state = ISub;
			else 
				next_state = IShift;
		ISub :	next_state = IShift;
		IShift :	next_state = J;
		J :    if (~Run) 
			next_state = A;
			  
  endcase
   
		  // Assign outputs based on ‘state’
        case (curr_state) 
	   	   A: 
	         begin
					Shift_En = 1'b0;
					Add = 1'b0;
					Sub = 1'b0;
		      end
				
				BA, CA, DA, EA, FA, GA, HA:
				begin
					Shift_En = 1'b0;
					Add = 1'b1;
					Sub = 1'b0;
				end
				
				ISub:
				begin
					Shift_En = 1'b0;
					Add = 1'b0;
					Sub = 1'b1;
				end
				
	   	   J: 
		      begin
					Shift_En = 1'b0;
					Add = 1'b0;
					Sub = 1'b0;
		      end
				
	   	   default:  //default case, can also have default assignments for Ld_A and Ld_B before case
		      begin 
					Shift_En = 1'b1;
					Add = 1'b0;
					Sub = 1'b0;
		      end
        endcase
    end

endmodule

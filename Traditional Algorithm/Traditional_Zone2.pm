// Traditional Algorithm 
// Zone Z2

dtmc

// CONSTANTS
const int IMG=4;     // main grid current
const int IDG5=0; 
const int r1_nbr=1;  // relay number
const int r2_nbr=2;
const int r3_nbr=3;
const int r4_nbr=4;


// PROBABILITITES
const double IED=0.1;  // Relay failure
const double BRK=0.1;  // Circuit breaker failure
const double WD= 0.1;   // Internal error

// GLOBAL VARIABLES
global isol:bool init false;   // isolation success 
global risk:bool init false;    // system under risk 
global z_nbr:[0..4];  // zone number 1 t0 4
global FC2:[0..1];
// 0: No fault
// 1: Fault 

// Fault injection module
module Fault

        [] (FC2=0)&(b1=0&b2=0&b3=0&b4=0)  ->  (FC2'=1)&(z_nbr'=2);

endmodule

// DG connection check
module DG1
	DG1:[0..2];
	// 1:Not connected
	// 2: Connected
	IDG1:[0..1];
	// 0: Zero current
	// 1: Non-zero/1A current

	[] (DG1=0&IDG1=0&FC2=1)  ->    0.5:(DG1'=1)&(IDG1'=0)
		    			              +0.5:(DG1'=2)&(IDG1'=1);
endmodule


// construct remaining modules through renaming
module DG2 = DG1[IDG1=IDG2,DG1=DG2,FC2=FC2]endmodule
module DG3 = DG1[IDG1=IDG3,DG1=DG3,FC2=FC2]endmodule
module DG4 = DG1[IDG1=IDG4,DG1=DG4,FC2=FC2]endmodule

// Configuration check from breakers CB and SW status
module SW
	sw:[0..2]; 
	// 1: Open 
	// 2: Close
	ISW_F:[0..30];

	[] (sw=0&DG1>0&DG2>0&DG3>0&DG4>0) ->  0.5:(sw'=1)&(ISW_F'=0)
			                     +0.5:(sw'=2)&(ISW_F'=ICB3_F+IDG3+IDG4+ICB4_F);	
endmodule
 

module CB1
	ICB1_F:[0..12];
	b1:[0..3]; 
	// 1: Open 
	// 2: Close
	// 3: Fail to open

        // Breaker can be open or close initially    
	[] (b1=0)&(sw=1|sw=2)&(BC1=0)&(DG1>0&DG2>0&DG3>0&DG4>0) 
						               		->  0.5:(b1'=1)&(ICB1_F'=0)
			                  	   +0.5:(b1'=2)&(ICB1_F'=IMG);	
	 // Relay has sent command to breaker						                           
	 [] (b1=2&BC1=1& FC2=1)  ->  1-BRK:(b1'=1)&(isol'=true)
			            +BRK:(b1'=3)&(isol'=false); 
			                   
endmodule



module CB4 = CB1 [b1=b4,BC1=BC4,ICB1_F=ICB4_F,IMG=IDG5] endmodule



module CB2
	ICB2_F:[0..12];
	b2:[0..3]; 
	// 1: Open 
	// 2: Close
	// 3: Fail to open
	
        // Breaker can be open or close initially 
	[] (b2=0&BC2=0&DG1>0&DG2>0&DG3>0&DG4>0)&(sw>0)  ->  0.5:(b2'=1)&(ICB2_F'=0)
		          				           +0.5:(b2'=2)&(ICB2_F'=ICB1_F+IDG1+IDG2); 
	 // Relay has sent command to breaker	
	[] (b2=2&BC2=1&FC2=1)  ->  1-BRK:(b2'=1)&(isol'=true)
			           +BRK:(b2'=3)&(isol'=false); 

endmodule


module CB3
	ICB3_F:[0..12];
	b3:[0..3]; 
	// 1: Open 
	// 2: Close
	// 3: Fail to open
	
	// Breaker can be open or close initially 
	[] (b3=0&BC3=0 )&(sw=1|(sw=2& b1=1))&(DG1>0&DG2>0&DG3>0&DG4>0) 
						               ->  0.5: (b3'=1)&(ICB3_F'=0)
			                  +0.5:(b3'=2)&(ICB3_F'=IMG);
	[] (b3=0&sw=2&b1=2)&(DG1>0&DG2>0&DG3>0&DG4>0) 
								                 -> (b3'=1)&(ICB3_F'=0);
        // Relay has sent command to breaker							                           
	[] (b3=2&BC3=1&FC2=1)  ->  1-BRK:(b3'=1)&(isol'=true)
							           +BRK:(b3'=3)&(isol'=false);

endmodule

 
// Protection function module
module R1
	
	// Relay current values
	IR1_F:[0..20];
	r1:[0..6];
	// 0: Idle
	// 1: Trip 
        // 2: Fail
	// 3: Wait
	// 4: Risk
	// 5: Active
	// 6: Passive
       // Breaker signal
	BC1:[0..2]; 
	 // 1: Sent
	// 2: Not sent 
	// Relay selectivity parameter
        sel1:[0..4]init 4;
	t1: bool init false;

	// Active/Passive mode check
	[] (r1=0)&(FC2=1)&(sel1=4)&(r1_nbr<z_nbr)&(b1=2)&(b2=2&b3>0&b4>0&sw>0)  
                                         -> (IR1_F'=ICB1_F)&(sel1'=-(r1_nbr-z_nbr));
	[] (r1=0)&(sel1!=4)&(IR1_F >0)&(b1=2&b2=2&b3>0&sw>0&b4>0)  
					                 -> (r1'=5); 
	[] (r1=0) & (sel1=4)& (IR1_F =0)&((b1=1)&b2>0&b3>0&sw>0&b4>0)  
					                 -> (r1'=6); 
   
	// Operation R1 act as backup relay
	[] (r1=5&(WD2=1|(CT2=1&(r2=2|b2=3))))&(FC2=1)  ->  1-IED:(r1'=1)&(BC1'=1)
			          				           +IED: (r1'=2)&(BC1'=2);
	// tb<<tp
	[ft1] (r1=5&(CT2=2))&(FC2=1)  ->  1-IED:(r1'=1)&(BC1'=1)
			                  +IED:(r1'=2)&(BC1'=2);
	// tb>>tp
	[] (r1=5&(CT2=3&(r2=2|b2=3)))&(FC2=1)  ->  (r1'=4)&(risk'=true);
	/// Timer check for CTM=3
	[] r1=4& t1=false -> 0.5:(t1'=true)&(r1'=4)+0.5:(t1'=false)&(r1'=4);



endmodule


module R2
	// Relay current values
	IR2_F:[0..20];
	r2:[0..6];
	// 0: Idle
	// 1: Trip 
        // 2: Fail
	// 3: Wait
	// 4: Risk
	// 5: Active
	// 6: Passive
       // Breaker signal
	BC2:[0..2]; 
	 // 1: Sent
	// 2: Not sent 
	// Relay selectivity parameter
        sel2:[0..4]init 4;
               
	// Active/Passive mode check
	[] (r2=0&sel2=4&FC2=1)&(r2_nbr>=z_nbr)&(b2=2)&(b1>0&b3>0&sw>0&b4>0)  
                              -> (IR2_F'=ICB1_F+IDG1+IDG2)&(sel2'=(r2_nbr-z_nbr));
	[] (r2=0)&(sel2=4)&(IR2_F=0)&(b1>0&b2=1&b3>0&sw>0&b4>0)  
					                 -> (r2'=6);
	[] (r2=0)&(sel2!=4)&(IR2_F>0)&(b1>0&b2=2&b3>0&sw>0&b4>0)  
					                 -> (r2'=5); 
	// Operation R2 act as main relay
	[] (r2=5&(r1=5|r3=5)&WD2=2&(CT2=1|CT2=3))&(FC2=1)  ->  1-IED:(r2'=1)&(BC2'=1)
			          				               +IED:(r2'=2)&(BC2'=2);
        [ft1] (r2=5&(r1=5)&WD2=2&(CT2=2))&(FC2=1)  ->  1-IED:(r2'=1)&(BC2'=1)
			                 		       +IED:(r2'=2)&(BC2'=2);
	[ft2] (r2=5&(r3=5)&WD2=2&(CT2=2))&(FC2=1)  ->  1-IED:(r2'=1)&(BC2'=1)
			                 		       +IED:(r2'=2)&(BC2'=2);
endmodule


module R3
	// Relay current values
	IR3_F:[0..20];
	r3:[0..6];
	// 0: Idle
	// 1: Trip 
        // 2: Fail
	// 3: Wait
	// 4: Risk
	// 5: Active
	// 6: Passive
       // Breaker signal
	BC3:[0..2]; 
	 // 1: Sent
	// 2: Not sent 
	// Relay selectivity parameter
        sel3:[0..4]init 4;
	t3: bool init false; 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
	// Active/Passive mode check
	[] (r3=0&sel3=4&FC2=1)&(r3_nbr>=z_nbr)&(b3=2)&(sw=2)&(b2>0&b1>0&b4>0)   
                                         -> (IR3_F'=ICB3_F)&(sel3'=(r3_nbr-z_nbr));
	[] (r3=0&sel3=4)&(FC2=1)&(r3_nbr<z_nbr)&(b3=2)&(sw=2)&(b1>0&b2>0&b4>0)  
                                         -> (IR3_F'=ICB3_F)&(sel3'=-(r3_nbr-z_nbr));
	[] (r3=0)&(sel3!=4)&(IR3_F>0)&(b1>0&b2>0&b3=2&sw=2&b4>0)  
					                 -> (r3'=5); 
	[] (r3=0&sel3=4)&(IR3_F =0)&((b3=1)&b2>0&b1>0&sw>0&b4>0)  
					                 -> (r3'=6); 
	// Operation R3 act as backup relay
	[] (r3=5&(WD2=1|(CT2=1&(r2=2|b2=3))))&(FC2=1)  ->  1-IED:(r3'=1)&(BC3'=1)
			         				           +IED:(r3'=2)&(BC3'=2);
	// tb<<tp
	[ft2] (r3=5&(CT2=2))&(FC2=1)    
				      ->  1-IED:(r3'=1)&(BC3'=1)
			          +IED: (r3'=2)&(BC3'=2);
	// tb>>tp
	[] (r3=5&(CT2=3&(r2=2|b2=3)))&(FC2=1)     
				      ->  (r3'=4)&(risk'=true);
	/// Timer check for CTM=3
	[] r3=4& t3=false -> 0.5:(t3'=true)&(r3'=4)+0.5:(t3'=false)&(r3'=4);

endmodule


module R4
	// Relay current values
	IR4_F:[0..20];
	r4:[0..6];
	// 0: Idle
	// 1: Trip 
        // 2: Fail
	// 3: Wait
	// 4: Risk
	// 5: Active
	// 6: Passive
       // Breaker signal
	BC4:[0..2]; 
	 // 1: Sent
	// 2: Not sent
	// Relay selectivity parameter
        sel4:[0..4]init 4;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
	// Active/Passive mode check
	[] (r4=0&sel4=4&FC2=1)&(r4_nbr>z_nbr)&(b4=2)&(sw=2)&(b2>0&b1>0&b3>0)   
                                         -> (IR4_F'=IDG5)&(sel4'=(r4_nbr-z_nbr));
	[] (r4=0)&(sel4!=4)&(IR4_F>0)&(b1>0&b2>0&b4=2&sw=2&b3>0)  
					                 -> (r4'=5); 
	[] (r4=0)&(sel4=2|sel4=4)&(IR4_F =0)&(b1>0&b2>0&(b4=1|b4=2)&sw>0&b3>0)  
					                 -> (r4'=6);
endmodule




//Watchdog module to check error
module Watchdog2
 	 WD2:[0..2];
  	//0: idle
 	//1: Error
	//2: No Error            
	[] (WD2=0&CT2=0) &((r2=5&r1=5&(r4=6)&(r3=6|(sw=1&b3=2)))
			 |(r2=5&r3=5&(r4=6)&(r1=6|(b2=1&b1=2))))
								->  1-WD:(WD2'=2)
		            +WD:(WD2'=1); 
endmodule


// CTM check module
module CT2_Chk
	CT2:[0..3];
   	// 1: CTM in range (0.3<=CTM<=0.4)
	// 2: CTM out of range (CTM<0.3)
 	//3: CTM out of range (CTM>0.4)
  
	[](CT2=0)&(WD2=2)  ->   1/3:(CT2'=1)
				       +1/3:(CT2'=2)
						       +1/3:(CT2'=3);
endmodule


// LABELS FOR PROPERTIES VERIFICATION
label "Succ1" =  (b1=1|b2=1)&(isol=true);
label "Succ2" =  (b2=1|b3=1)&(isol=true);

label "Cond1"= (FC2=1)&(r2=5&r1=5);
label "Succa"= (CT2=1|CT2=3)&((r2=1 &b2=1 & isol=true)
		  |(r1=1&b1=1& isol=true))
		  |((CT2=2& r1=2& r2=1&b2=1)
                  |(CT2=2& r1=1&b1=3& r2=1&b2=1))
		  |(WD2=1& (r1=1&b1=1)); 
   
label "Cond2"= (FC2=1)&(r2=5&r3=5);
label "Succb"= (CT2=1|CT2=3)&((r2=1 &b2=1 & isol=true)
		  |(r3=1&b3=1& isol=true))
		  |((CT2=2& r3=2& r2=1&b2=1)
                  |(CT2=2& r3=1&b3=3& r2=1&b2=1))
		  |(WD2=1& (r3=1&b3=1)); 

label "Fail1"  = (WD2=2&(((b2=3& b1=3)
		       |(r2=1&b2=3&r1=2))  
		       |(r2=2& b1=3)|(r2=2&r1=2)))    
		       |(WD2=1& (r1=2|(r1=1&b1=3)));    
label "Fail2"  = (WD2=2&(((b2=3& b3=3)
		       |(r2=1&b2=3&r3=2))  
		       |(r2=2& b3=3)|(r2=2&r3=2)))    
		       |(WD2=1& (r3=2|(r3=1&b3=3)));

label "False_trip"=(CT2=2&r2=1&r1=1)|(CT2=2&r2=1&r3=1);

label "Risk"= ((CT2=3&r1=4&t1=true)|(CT2=3&r3=4&t3=true))&risk=true;





 



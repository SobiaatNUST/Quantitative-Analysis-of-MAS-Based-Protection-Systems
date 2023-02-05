// Auxiliary Algorithm Part A
// Zone Z2

dtmc

//CONSTANTS
const int IMG=4;     // main grid current
const int IDG5=0;  
const int r1_nbr=1;  // relay number
const int r2_nbr=2;
const int r3_nbr=3;
const int r4_nbr=4;

// PROBABILITITES
const double IED=0.1;   // Relay failure
const double BRK=0.1;  // Circuit breaker failure
const double COM;      // Communication failure
const double WD=0.1;   // Internal error

//GLOBAL VARAIBLES
global z_nbr:[0..4];         // zone number 1 t0 4
global isol:bool init false; // isolation success 
   

// Fault injection module
module Fault
	FC2:[0..1]; // Fault
  	//0: No fault
 	//1: Fault 
        [] (FC2=0)  ->  1:(FC2'=1)&(z_nbr'=2);	   	            
endmodule


// DG connection check
module DG1
	DG1:[0..2];
	// 1:Not connected
	// 2: Connected
	IDG1:[0..1];
	// 0: Zero current
	// 1: Non-zero/2A current

	[] (DG1=0&IDG1=0&FC2=1)  ->    0.5: (DG1'=1)&(IDG1'=0)
		    			              +0.5:(DG1'=2)&(IDG1'=2);
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
	ISW_F:[0..20];

	[] sw=0&(DG1>0&DG2>0&DG3>0&DG4>0) ->   0.5:(sw'=1)&(ISW_F'=0)
			                      +0.5:(sw'=2)&(ISW_F'=ICB3_F+IDG3+IDG4+ICB4_F);	
endmodule

module CB1
	ICB1_F:[0..6];
	b1:[0..3]; 
	// 1: Open 
	// 2: Close
	// 3: Fail to open
	
        // Breaker can be open or close initially 
	[] (b1=0&BC1=0)&(sw=1|sw=2)&(DG1>0&DG2>0&DG3>0&DG4>0)  ->  0.5:(b1'=1)&(ICB1_F'=0)
			                   				                  +0.5:(b1'=2)&(ICB1_F'=IMG);
	 // Relay has sent command to breaker							                           
        [] (b1=2&BC1=1)  ->  1-BRK:(b1'=1)&(isol'=true)
							    +BRK:(b1'=3)&(isol'=false);
			                   
endmodule
module CB4 = CB1[b1=b4,BC1=BC4,ICB1_F=ICB4_F,IMG=IDG5] endmodule 

module CB3
	ICB3_F:[0..6];
	b3:[0..3]; 
	// 1: Open 
	// 2: Close
	// 3: Fail to open
	
        // Breaker can be open or close initially 
	[] (b3=0&BC3=0)&((sw=1|sw=2)&b1=1)&(DG1>0&DG2>0&DG3>0&DG4>0)  ->  0.5: (b3'=1)& (ICB3_F'=0)
			                   		                         +0.5:(b3'=2)& (ICB3_F'=IMG);
	[] (b3=0&sw=2&b1=2)&(DG1>0&DG2>0&DG3>0&DG4>0)  ->  (b3'=1)& (ICB3_F'=0);
        // Relay has sent command to breaker							                           
 	[] (b3=2&BC3=1) ->  1-BRK:(b3'=1)&(isol'=true)
							   +BRK:(b3'=3)&(isol'=false);
			                   
endmodule


module CB2
	ICB2_F:[0..10];
	b2:[0..3]; 
	// 1: Open 
	// 2: Close
	// 3: Fail to open
	
        // Breaker can be open or close initially 
		
	[] (b2=0&BC2=0)&(DG1>0&DG2>0&DG3>0&DG4>0)&(b1>0&b3>0&sw>0&b4>0)
										                                    ->  0.5: (b2'=1)&(ICB2_F'=0)
			           	                       +0.5:(b2'=2)&(ICB2_F'=ICB1_F+IDG1+IDG2); 
	[] (b2=2&BC2=1)  ->   1-BRK:(b2'=1)&(isol'=true)
			     +BRK:(b2'=3)&(isol'=false);  
endmodule

// Protection Function module
module R1
     // Relay current values
	IR1_F:[0..6];
	r1:[0..6];
	// 0: Idle
	// 1: Trip 
        // 2: Fail
	// 3: Lockout
	// 4: Reset
	// 5: Active
	// 6: Passive
       // Breaker signal
	BC1:[0..2]; 
	 // 1: Sent
	// 2: Not sent 
	TL1:[0..2];
	// 1: Previous lockout
	// 2: Not in previous lockout

	// Relay selectivity parameter
        sel1:[0..4]init 4;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
	// Active/Passive mode check
	[] (r1=0&FC2=1&sel1=4)&(r1_nbr<z_nbr)&(b1=2)&(b2>0&b3>0&b4>0&sw>0)  
                              -> (IR1_F'=ICB1_F)&(sel1'=-(r1_nbr-z_nbr));
	[] (r1=0&!sel1=4&IR1_F>0)&(b1=2&b2>0&b3>0&sw>0&b4>0)
				     -> (r1'=5); 
     	[] (r1=0&sel1=4&IR1_F =0)&((b1=1)&b2>0&b3>0&sw>0&b4>0)  
					     -> (r1'=6); 
	// Operation mode
	[lok] (r1=5&s2=0) ->  (r1'=3); 
	[prim] (r1=3&TL1=0)  ->  (r1'=4);
	[] ((r1=5|r1=4)&(TRQ_R1=1|TL1=2))  ->  1-IED:(r1'=1)
			                       +IED: (r1'=2);
	[] (r1=5&s2=4&TL1=0)  ->     0.1:(r1'=3)&(TL1'=1) 
			    	     +0.45: (r1'=5)&(TL1'=2)
				             +0.45: (r1'=4)&(TL1'=2);
	// Breaker signal sent or not
	[] (r1=1&BC1=0)   ->  1-COM:(BC1'=1)
				     +COM:(BC1'=2);
	[] (sv1=1)&(BC1=0|BC1=2)  ->  (BC1'=1);

endmodule


module R2
	// Relay current values
	IR2_F:[0..12];
	r2:[0..6];
	// 0: Idle
	// 1: Trip 
        // 2: Fail
	// 3: Lockout
	// 4: Reset
	// 5: Active
	// 6: Passive
       // Breaker signal
	BC2:[0..2]; 
	 // 1: Sent
	// 2: Not sent 
	TL2:[0..2];
	// 1: Previous lockout
	// 2: Not in previous lockout
	// Relay selectivity parameter
        sel2:[0..4]init 4;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
	// Active/Passive mode check
	[] (r2=0&sel2=4&FC2=1)&(r2_nbr>=z_nbr)&(b2=2)&(b1>0&b3>0&sw=2&b4>0)  
                      ->  (IR2_F'=ICB1_F+IDG1+IDG2)&(sel2'=(r2_nbr-z_nbr));
	[] (r2=0&sel2=4&FC2=1)&(r2_nbr<z_nbr)&(b2=2)&(b1>0&b3>0&sw=2&b4>0)   
          	     ->  (IR2_F'=ICB1_F+IDG1+IDG2)&(sel2'=-(r2_nbr-z_nbr));
	[] (r2=0&!sel2=4&IR2_F >0)&(b1>0&b2=2&b3>0&sw=2&b4>0)  
			           -> (r2'=5); 
	// Operation mode
	[prim] (r2=5&TL2=0&WD2=2)  ->  1-IED:(r2'=1)
			               +IED:(r2'=2);
	[prim2] (r2=5&TL2=0&WD2=2) ->  1-IED:(r2'=1)
			               +IED:(r2'=2);
	[prim3] (r2=5&TL2=0&WD2=2) ->  1-IED:(r2'=1)
			               +IED:(r2'=2);
	// Breaker signal sent or not
	[] (r2=1&BC2=0)   ->  1-COM:(BC2'=1)
				     +COM:(BC2'=2);
endmodule


module R3
	// Relay current values
	IR3_F:[0..12];
	r3:[0..6];
	// 0: Idle
	// 1: Trip 
        // 2: Fail
	// 3: Lockout
	// 4: Reset
	// 5: Active
	// 6: Passive
       // Breaker signal
	BC3:[0..2]; 
	 // 1: Sent
	// 2: Not sent 
	TL3:[0..2];
	// 1: Previous lockout
	// 2: Not in previous lockout
	// Relay selectivity parameter
        sel3:[0..4]init 4;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
	// Active/Passive mode check
	[] (r3=0&sel3=4&FC2=1)&(r3_nbr>z_nbr)&(b3=2&sw=2)&(b2>0&b1>0&b4>0)   
                          	->  (IR3_F'=ICB3_F)&(sel3'=(r3_nbr-z_nbr));
	[] (r3=0&sel3=4&FC2=1)&(r3_nbr<z_nbr)&(b3=2)&(sw=2)&(b1>0&b2>0&b4>0)  
                                ->  (IR3_F'=ICB3_F)&(sel3'=-(r3_nbr-z_nbr));
	[] (r3=0&! sel3=4&IR3_F>0)&(b1>0&b2>0&b3=2&sw>0&b4>0)  
					        -> (r3'=5); 
	[] (r3=0&sel3=4&IR3_F=0)&((b3=1)&b2>0&b1>0&sw>0&b4>0)  
					        -> (r3'=6);
	// Operation mode        
	[lok2] (r3=5&s2=0)&(CTM2=2|CTM2=3)  ->  (r3'=3);
	[prim2] (r3=3&TL3=0)  ->  (r3'=4);
	[] ((r3=5|r3=4)&(TRQ_R3=1|TL3=2))  ->   1-IED:(r3'=1)
			                        +IED:(r3'=2); 
	[] (r3=5&s2=4&TL3=0)  ->   0.1:(r3'=3)&(TL3'=1) 
			      	  +0.45:(r3'=5)&(TL3'=2)
				      	  +0.45:(r3'=4)&(TL3'=2);
	// Breaker signal sent or not
	[] (r3=1&BC3=0)   ->  1-COM:(BC3'=1)
				     +COM:(BC3'=2);
	[] (sv3=1)&(BC3=0|BC3=2)  ->  (BC3'=1);

endmodule


module R4
	// Relay current values
	IR4_F:[0..12];
	r4:[0..6];
	// 0: Idle
	// 1: Trip 
        // 2: Fail
	// 3: Lockout
	// 4: Reset
	// 5: Active
	// 6: Passive
       // Breaker signal
	BC4:[0..2]; 
	 // 1: Sent
	// 2: Not sent 
	TL4:[0..2];
	// 1: Previous lockout
	// 2: Not in previous lockout

	// Relay selectivity parameter
        sel4:[0..4]init 4;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
	// Active/Passive mode check
	[] (r4=0&sel4=4&FC2=1)&(r4_nbr>z_nbr)&(b4=2&sw=2)&(b2>0&b1>0&b3>0)  
                     	      ->  (IR4_F'=ICB4_F)&(sel4'=(r4_nbr-z_nbr));
	[] (r4=0&!sel4=4&IR4_F>0)&(b1>0&b2>0&b4=2&sw>0&b3>0)  
					            -> (r4'=5); 
	[] (r4=0&sel4=2&IR4_F=0)&(b1>0&b2>0&b4=2&sw>0&b3>0)  
					            -> (r4'=6);
	// Operation mode       
	[lok3] (r4=5&s2=0&(CTM2=2|CTM2=3))  ->  (r4'=3);
	[prim3] (r4=3&TL4=0)  ->  (r4'=4);
	[] ((r4=5|r4=4)&(TRQ_R4=1|TL4=2))  ->  1-IED:(r4'=1)
			                        +IED:(r4'=2);
	[] (r4=5&s2=4&TL4=0)  ->  0.1:(r4'=3)&(TL4'=1) 
			         +0.45:(r4'=5)&(TL4'=2)
				         +0.45:(r4'=4)&(TL4'=2);
	// Breaker signal sent or not
	[] (r4=1&BC4=0)  ->   1-COM:(BC4'=1)
				      +COM:(BC4'=2);
	[] (sv4=1)&(BC4=0|BC4=2)  ->  (BC4'=1);


endmodule

// Watchdog module to check relay error
module Watchdog2
 	 WD2:[0..2];
  	//0: idle
 	//1: Error
	//2: No Error
      
	[] (WD2=0&CTM2=0)&((r2=5&sel2=0&r3=6& r1=5& sel1=1&(r4=6))
		         |(r2=5&sel2=0&r1=6&r3=5& sel3=1&(r4=6)))
					 		->    1-WD:(WD2'=2)
		           		     +WD:(WD2'=1);
endmodule

//Coordination margin check module
module CTM2_Chk
         CTM2:[0..3];
	//1: CTM in range
	//2: CTM out of range
	[](CTM2=0&WD2=2)  ->   1/3:(CTM2'=1)
				      +1/3:(CTM2'=2)
	                      +1/3:(CTM2'=3);			    	    
endmodule

// Signal dispatching module
module Sig_Disp2
 	s2:[0..4];
  	//0: Idle
 	//1: TL1 sent
	//2: TR1 Reset sent
	//3: TRQ1 sent
	//4: TRQ1 not sent

	[lok]  (s2=0&r1=5&r2=5&(CTM2=2|CTM2=3))  ->  (s2'=1); 
	[prim] (s2=1&r1=3&TL2=0&(CTM2=2|CTM2=3))  ->  (s2'=2);
	[lok2] (s2=0&r3=5&r2=5&(CTM2=2|CTM2=3))  ->  (s2'=1); 
	[prim2](s2=1&r3=3&TL2=0&(CTM2=2|CTM2=3))  ->  (s2'=2);
	[lok3] (s2=0&r4=5&r2=5&(CTM2=2|CTM2=3))  ->  (s2'=1); 
	[prim3](s2=1&r4=3&TL2=0&(CTM2=2|CTM2=3)) ->  (s2'=2);
	[] (s2=0&WD2=1)  ->  1-COM:(s2'=3)
				     +COM:(s2'=4);
	[] (s2=2&(r2=2|BC2=2|(BC2=1&b2=3))) ->  (s2'=3);

endmodule

// Signal receiving module
module Sig_Rcv1
	TRQ_R1:[0..2]; 
	//1: Received
	//2: Not received
	[] (TRQ_R1=0&s2=3&IR1_F>0) ->  1-COM:(TRQ_R1'=1)  
				    	       +COM:(TRQ_R1'=2);
endmodule

// construct remaining modules through renaming
module   Sig_Rcv2 = Sig_Rcv1[s2=s2,TRQ_R1=TRQ_R3,IR1_F=IR3_F] endmodule
module   Sig_Rcv4 = Sig_Rcv1[s2=s2,TRQ_R1=TRQ_R4,IR1_F=IR4_F] endmodule


// Supervisory service module
module sup_sv1
	sv1:[0..1];
	// 0: idle
	// 1: Supervisory service activated
	// Ts time elapsed
 	 t1: bool init false; 

	[] (sv1=0&t1=false)&(TRQ_R1=2|TL1=1|(r1=2&(b2=2|b2=3)))&(IR1_F>0)  ->  0.5: (t1'=true)
					                                                      +0.5:(t1'=false);
	[] (sv1=0&t1=false)&(BC1=2)&(b2=2|b2=3)  ->  0.5: (t1'=true)
					                            +0.5:(t1'=false);
	[] sv1=0 & t1=true -> (sv1'=1);      
endmodule


// construct remaining modules through renaming 
module sup_sv3 =sup_sv1[sv1=sv3,t1=t3,TRQ_R1=TRQ_R3,TL1=TL3,b2=b2,r1=r3,FC2=FC2,BC1=BC3,IR1_F=IR3_F] endmodule
module sup_sv4 =sup_sv1[sv1=sv4,t1=t4,TRQ_R1=TRQ_R4,TL1=TL4,b2=b2,r1=r4,FC2=FC2,BC1=BC4,IR1_F=IR4_F] endmodule



// LABELS FOR PROPERTIES VERIFICATION
label "Cond1"=  FC2=1 & (r1=5&r2=5);
label "Succ1"= (b1=1 & isol=true)|(b2=1& isol=true);

label "Cond2"=  FC2=1 & (r3=5&r2=5);
label "Succ2"= (b2=1 & isol=true)|(b3=1& isol=true);

label "Fail1"  = ((WD2=2 &(CTM2=2|CTM2=3) & (r2=1& BC2=1 & b1=3 & b2=3)|(r2=1& BC2=2 & b1=3)
		 |(r2=2& b1=3))|(WD2=1& b1=3&(s2=3|s2=4)));
			
label "Fail2"=((WD2=2&(CTM2=2|CTM2=3) & (r2=1& BC2=1 & b2=3 & b3=3)|(r2=1& BC2=2 & b3=3)
	       |(r2=2& b3=3))|(WD2=1& b3=3&(s2=3|s2=4)));

label "risk1"= (CTM2=3&(sv1=1&t1=true&BC1=1&b1=3));
label "risk2"= (CTM2=3&(sv3=1&t3=true&BC3=1&b3=3));










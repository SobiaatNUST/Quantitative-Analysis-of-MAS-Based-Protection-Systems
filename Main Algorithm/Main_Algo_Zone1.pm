// Main Algorithm supporting MAS-based Schemes
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
global False_trip:bool init false; // false trip
global z_nbr:[0..4];  // zone number 1 t0 4
global FC1:[0..1];
// 0: No fault
// 1: Fault 

// Fault injection module
module Fault


        [] (FC1=0)&(b1=0&b2=0&b3=0&b4=0)  ->  (FC1'=1)&(z_nbr'=1);

endmodule



// DG connection check
module DG1

	DG1:[0..2];
	// 1:Not connected
	// 2: Connected

	IDG1:[0..2];
	// 0: Zero current
	// 2: Non-zero/2A current

	[] (DG1=0&IDG1=0&FC1=1)  ->    0.5: (DG1'=1)&(IDG1'=0)
		    		      +0.5:(DG1'=2)&(IDG1'=2);

endmodule


// construct remaining modules through renaming
module DG2 = DG1[IDG1=IDG2,DG1=DG2,FC1=FC1]endmodule
module DG3 = DG1[IDG1=IDG3,DG1=DG3,FC1=FC1]endmodule
module DG4 = DG1[IDG1=IDG4,DG1=DG4,FC1=FC1]endmodule



// Configuration check from breakers CB and SW status
module SW

	sw:[0..2]; 
	// 1: Open 
	// 2: Close

	ISW_F:[0..12];

	[] (sw=0&DG1>0&DG2>0&DG3>0&DG4>0) ->   0.5: (sw'=1)&(ISW_F'=0)
			                      +0.5:(sw'=2)&(ISW_F'=ICB3_F+IDG3+IDG4+ICB4_F);	


endmodule
 


module CB1

	ICB1_F:[0..6];
	b1:[0..3]; 
	// 1: Open 
	// 2: Close
	// 3: Fail to open
	
        // Breaker can be open or close initially    
	[] (b1=0)&(sw=1|sw=2)&(BC1=0)&(DG1>0&DG2>0&DG3>0&DG4>0)  ->  0.5:(b1'=1)&(ICB1_F'=0)
			                  	   		    +0.5:(b1'=2)&(ICB1_F'=IMG);	
	 // Relay has sent command to breaker						                           
	 [] (b1=2&BC1=1& FC1=1)  ->  1-BRK:(b1'=1)&(isol'=true)&(FC1'=0)
			            +BRK:(b1'=3)&(isol'=false)&(FC1'=1); 
			                   
endmodule


// construct remaining modules through renaming
module CB4 = CB1[b1=b4,BC1=BC4,ICB1_F=ICB4_F,IMG=IDG5] endmodule 



module CB2
	ICB2_F:[0..6];
	b2:[0..3]; 
	// 1: Open 
	// 2: Close
	// 3: Fail to open	

	[] (b2=0&BC2=0)&(DG1>0&DG2>0&DG3>0&DG4>0)&(b1>0&b3>0&sw>0)  
					          ->  0.5:(b2'=1)&(ICB2_F'=0)
					     	     +0.5:(b2'=2)&(ICB2_F'=ISW_F); 
	// Relay has sent command to breaker	
	[] (b2=2&BC2=1&FC1=1)  ->    1-BRK:(b2'=1)&(isol'=true)&(FC1'=0)
			            +BRK:(b2'=3)&(isol'=false)&(FC1'=1); 

endmodule

// CB3 has constraints with CB1 and SW
module CB3
	
	ICB3_F:[0..6];
	b3:[0..3]; 
	// 1: Open 
	// 2: Close
	// 3: Fail to open

	[] (b3=0)&((sw=1&b1=2)|b1=1)&(BC3=0)&(DG1>0&DG2>0&DG3>0&DG4>0) 
						               ->   0.5:(b3'=1)&(ICB3_F'=0)
			                  			   +0.5:(b3'=2)&(ICB3_F'=IMG);
	// When both the SW and CB1 are close
	[] (b3=0)&(sw=2&b1=2)&(DG1>0&DG2>0&DG3>0&DG4>0)  ->  (b3'=1)&(ICB3_F'=0);
								              
	// Relay has sent command to breaker							                           
	[] (b3=2&BC3=1&FC1=1)  ->  1-BRK:(b3'=1)&(isol'=true)&(FC1'=0)
				   +BRK:(b3'=3)&(isol'=false)&(FC1'=1);			           

endmodule


//Protection Function module
module R1

// Relay current values
	IR1_F:[0..6];

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
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
	// Active/Passive mode check
	[] (r1=0)&(sel1=4)&(FC1=1)&(r1_nbr>=z_nbr)&(b1=2)&(b2>0&b3>0&sw>0&b4>0) 
                                           -> (IR1_F'=ICB1_F)&(sel1'=(r1_nbr-z_nbr));
	[] (r1=0)&(sel1=0)&(IR1_F >0)&(b1=2&b2>0&b3>0&sw>0&b4>0)  
					                   ->  (r1'=5); 
        [] (r1=0)&(sel1=4)&(IR1_F =0)&((b1=1)&b2>0&b3>0&sw>0&b4>0)  
					                   ->  (r1'=6); 
	// Operation mode
	[] (r1=5&WD1=2&(CT1=1|CT1=3))&(FC1=1)  ->  1-IED:(r1'=1)&(BC1'=1)
			                           +IED: (r1'=2)&(BC1'=2);
        [] (r1=5&WD1=2&(CT1=2))&(FC1=1)  ->  (r1'=3);
 	[] (r1=3)&(r2=2|b2=3)&(FC1=1)  ->  1-IED:(r1'=1)&(BC1'=1)
			                   +IED:(r1'=2)&(BC1'=2);

     
 endmodule



module R2
     
	// Relay current values
	IR2_F:[0..6];

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
	[] (r2=0)&(sel2=4)&(FC1=1)&(r2_nbr>=z_nbr)&(b2=2)&(b1>0&b3>0&sw=2&b4>0)  
                                  ->  (IR2_F'=ICB3_F+IDG3+IDG4+ICB4_F)&(sel2'=(r2_nbr-z_nbr));
	[] (r2=0)&(sel2=4)&(FC1=1)&(r2_nbr<z_nbr)&(b2=2)&(b1>0&b3>0&sw=2&b4>0)   
                                  ->  (IR2_F'=ICB3_F+IDG3+IDG4+ICB4_F)&(sel2'=-(r2_nbr-z_nbr));
	[] (r2=0)&(!sel2=4)&(IR2_F >0)&(b1>0&b2=2&b3>0&sw=2&b4>0)  
					                 ->  (r2'=5);  
	[] (r2=0&sel2=4&IR2_F =0)&((b2=1)&b1>0&b3>0&sw>0&b4>0)  
					                 -> (r2'=6);   
	// Operation R2 act as backup relay
	[] (r2=5 &(FC1=1)&(WD1=1|(WD1=2&CT1=1&(r1=2|b1=3))))  ->  1-IED:(r2'=1)&(BC2'=1)
			          				  +IED: (r2'=2)&(BC2'=2);
        // tb<<tp
	[] (r2=5&(CT1=2&r1=3))&(FC1=1)  ->  1-IED:(r2'=1)&(BC2'=1)&(False_trip'=true)
			         	   +IED:(r2'=2)&(BC2'=2)&(False_trip'=false);
	// tb>>tp
	[] (r2=5&(CT1=3&(r1=2|b1=3)))&(FC1=1)  ->  (r2'=4)&(risk'=true);
	//R2 act as main relay
	[] (r2=5&WD2=2&(CT2=1|CT2=3))&(FC1=1)  ->  1-IED:(r2'=1)&(BC2'=1)
			                           +IED: (r2'=2)&(BC2'=2);
         [] (r2=5&WD2=2&(CT2=2))&(FC1=1)  ->  (r2'=3);  
 	 [] (r2=3)&(r3=2|b3=3)&(FC1=1)  ->  1-IED:(r2'=1)&(BC2'=1)
			                    +IED:(r2'=2)&(BC2'=2);

endmodule


module R3
	// Relay current values
	IR3_F:[0..6];

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
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
	// Active/Passive mode check

	[] (r3=0)&(sel3=4)&(FC1=1)&(r3_nbr>=z_nbr)&(b3=2)&(b2=2)&(sw=2)&(b1>0&b4>0)   
                                   	  ->  (IR3_F'=ICB3_F)&(sel3'=(r3_nbr-z_nbr));
	[] (r3=0)&(sel3=4)&(FC1=1)&(r3_nbr<z_nbr)&(b3=2)&(b2=2)&(sw=2)&(b1>0&b4>0)  
                                         ->  (IR3_F'=ICB3_F)&(sel3'=-(r3_nbr-z_nbr));
	[] (r3=0) & (sel3=4)& (IR3_F =0)&((b3=1)&b2>0&b1>0&sw>0&b4>0)  
					                 -> (r3'=6);
	[] (r3=0)&(! sel3=4) & (IR3_F >0)&(b1>0&b2=2&b3=2&sw=2&b4>0)  
					                 -> (r3'=5);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
 	 // Operation R3 act as backup relay

	[] (r3=5&(WD2=1|(CT2=1&(r2=2|b2=3))))&(FC1=1)  ->  1-IED:(r3'=1)&(BC3'=1)
			         			   +IED:(r3'=2)&(BC3'=2);
	[] (r3=5&(CT2=2&r2=3))&(FC1=1)  ->  1-IED:(r3'=1)&(BC3'=1)&(False_trip'=true)
			                    +IED:(r3'=2)&(BC3'=2)&(False_trip'=false);
	[] (r3=5&(CT2=3&(r2=2|b2=3)))&(FC1=1)  ->  (r3'=4)&(risk'=true);

endmodule


module R4

       // Relay current values
	IR4_F:[0..6];

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
	
	[] (r4=0&sel4=4&FC1=1)&(r4_nbr>=z_nbr)&(b4=2&b2=2&sw=2&b1>0&b3>0)   
                                    -> (IR4_F'=IDG5)&(sel4'=(r4_nbr-z_nbr));
	[] (r4=0)&(sel4=4)& (IR4_F =0)&(FC1=1)&(b1>0&b2>0&b4=1&sw>0&b3>0)  
					                 -> (r4'=6); 	
	[] (r4=0)&(!sel4=4)&(IR4_F >0)&(b1>0&b2>0&b4=2&sw>0&b3>0)  
					                 -> (r4'=5); 
    	//R4 act as backup
	[] (r4=5&(WD2=1|(CT2=1&(r2=2|b2=3))))&(FC1=1)  ->  1-IED:(r4'=1)&(BC4'=1)
			                                   +IED: (r4'=2)&(BC4'=2);
	[] (r4=5&(CT2=2&r2=3))&(FC1=1)  ->   1-IED:(r4'=1)&(BC4'=1)&(False_trip'=true)
			                     +IED:(r4'=2)&(BC4'=2)&(False_trip'=false);
	[] (r4=5&(CT2=3&(r2=2|b2=3)))&(FC1=1)  ->  (r4'=4)&(risk'=true);


endmodule

//Watchdog module to check error
module Watchdog1

         WD1:[0..2];
  	//0: idle
 	//1: Error
	//2: No Error
	[] (WD1=0&CT1=0)&(r1=5&r2=5&(r3=6|(sw=1|b2=1))&(r4=6|(sw=1|b2=1))) 
				          ->  1-WD:(WD1'=2)
			              	      +WD:(WD1'=1);
endmodule

module Watchdog2

 	 WD2:[0..2];
  	//0: idle
 	//1: Error
	//2: No Error

 	[] (WD2=0&CT2=0)&(r2=5&r3=5&r1=6)&(r4=6|(sw=1))
			     ->  1-WD: (WD2'=2)
		                 +WD: (WD2'=1); 
endmodule


// CTM check module
module CT1_Chk
 	CT1:[0..3];
   	// 1: CTM in range (0.3<=CTM<=0.4)
	// 2: CTM out of range (CTM<0.3)
 	//3: CTM out of range (CTM>0.4)

   	[](CT1=0&WD1=2)  -> 1/3:(CT1'=1)
			   +1/3:(CT1'=2)
			   +1/3:(CT1'=3);

endmodule



module CT2_Chk
         CT2:[0..3];
	// 1: CTM in range (0.3<=CTM<=0.4)
	// 2: CTM out of range (CTM<0.3)
 	//3: CTM out of range (CTM>0.4)

   	[](CT2=0&WD2=2)  ->   1/3:(CT2'=1)
			      +1/3:(CT2'=2)
			     +1/3:(CT2'=3);	    	    
endmodule



// LABELS FOR PROPERTIES VERIFICATION

label "Cond1"= FC1=1 & (r1=5&r2=5&(r4=6|sel4=3)&(r3=6|sel3=2));               
label "Succ1"= (CT1=1|CT1=3)&((r1=1 &b1=1 & isol=true)
		  |(r2=1&b2=1& isol=true))
		  |((CT1=2& r2=2& r1=1&b1=1)
		  |(CT1=2& r2=1&b2=3& r1=1&b1=1&False_trip=true))
		  |(WD1=1& (r2=1&b2=1)); 

label "Cond2"= FC1=1& (r2=5&r3=5&(r4=6|sel4=3)&(r1=6|sel1=0));      
label "Succ2"= (CT2=1|CT2=3)&(((r2=1&b2=1 & isol=true)
		   |(r3=1&b3=1& isol=true)))
		   |((CT2=2& r3=2& r2=1&b2=1)
		   |(CT2=2& r3=1&b3=3& r2=1&b2=1&False_trip=true))
		   |(WD2=1& (r3=1&b3=1)); 
		
label "Fail1"  = (WD1=2&(((b1=3&b2=3)|(r1=1&b1=3&r2=2))
		      |(r1=2& b2=3)|(r1=2&r2=2)))
		      |(WD1=1& (r2=2|(r2=1&b2=3)));
label "Fail2"=(WD2=2 & (((b2=3&b3=3)|(r2=1& b2=3&r3=2))
	             |(r2=2& b3=3)|(r2=2&r3=2)))
		     |(WD2=1& (r3=2|(r3=1&b3=3)));

label "False_trip"=(CT1=2&r1=3&r2=1&b2=1& False_trip=true)
                   |(CT2=2&r2=3&r3=1&b3=1& False_trip=true);

label "Risk"= (((CT1=3&r2=4)|(CT2=3&r3=4))&(risk=true));



 


                       



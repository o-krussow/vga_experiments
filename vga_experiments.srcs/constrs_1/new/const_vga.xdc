# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk_100MHz]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk_100MHz]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk_100MHz]
	
	
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets LED_OBUF]

#LED
#set_property PACKAGE_PIN U16 [get_ports {LED}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {LED}]
 
# Switches
#set_property PACKAGE_PIN V17 	 [get_ports {tm_wt_x_in[0]}]					
#set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_x_in[0]}]
#set_property PACKAGE_PIN V16 	 [get_ports {tm_wt_x_in[1]}]					
#set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_x_in[1]}]
#set_property PACKAGE_PIN W16 	 [get_ports {tm_wt_x_in[2]}]					
#set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_x_in[2]}]
#set_property PACKAGE_PIN W17 	 [get_ports {tm_wt_x_in[3]}]					
#set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_x_in[3]}]
#set_property PACKAGE_PIN W15 	 [get_ports {tm_wt_x_in[4]}]					
#set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_x_in[4]}]
#set_property PACKAGE_PIN V15 	 [get_ports {tm_wt_x_in[5]}]					
#set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_x_in[5]}]
#set_property PACKAGE_PIN W14 	 [get_ports {tm_wt_x_in[6]}]					
#set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_x_in[6]}]
#set_property PACKAGE_PIN W13 	 [get_ports {tm_wt_x_in[7]}]					
#set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_x_in[7]}]

#set_property PACKAGE_PIN V2 	 [get_ports {tm_wt_y_in[0]}]					
#set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_y_in[0]}]
#set_property PACKAGE_PIN T3 	 [get_ports {tm_wt_y_in[1]}]					
#set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_y_in[1]}]
#set_property PACKAGE_PIN T2 	 [get_ports {tm_wt_y_in[2]}]					
#set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_y_in[2]}]
#set_property PACKAGE_PIN R3 	 [get_ports {tm_wt_y_in[3]}]					
#set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_y_in[3]}]
#set_property PACKAGE_PIN W2 	 [get_ports {tm_wt_y_in[4]}]					
#set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_y_in[4]}]
#set_property PACKAGE_PIN U1 	 [get_ports {tm_wt_y_in[5]}]					
#set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_y_in[5]}]

#set_property PACKAGE_PIN T1 	 [get_ports {tm_clk}]					
#set_property IOSTANDARD LVCMOS33 [get_ports {tm_clk}]
#set_property PACKAGE_PIN R2 	 [get_ports {tm_val}]					
#set_property IOSTANDARD LVCMOS33 [get_ports {tm_val}]


##VGA Connector
set_property PACKAGE_PIN G19     [get_ports {rgb[0]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[0]}]
set_property PACKAGE_PIN H19     [get_ports {rgb[1]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[1]}]
set_property PACKAGE_PIN J19     [get_ports {rgb[2]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[2]}]
set_property PACKAGE_PIN N19     [get_ports {rgb[3]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[3]}]
set_property PACKAGE_PIN J17     [get_ports {rgb[4]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[4]}]
set_property PACKAGE_PIN H17     [get_ports {rgb[5]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[5]}]
set_property PACKAGE_PIN G17     [get_ports {rgb[6]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[6]}]
set_property PACKAGE_PIN D17     [get_ports {rgb[7]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[7]}]
set_property PACKAGE_PIN N18     [get_ports {rgb[8]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[8]}]
set_property PACKAGE_PIN L18     [get_ports {rgb[9]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[9]}]
set_property PACKAGE_PIN K18     [get_ports {rgb[10]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[10]}]
set_property PACKAGE_PIN J18     [get_ports {rgb[11]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[11]}]
set_property PACKAGE_PIN P19     [get_ports hsync]						
set_property IOSTANDARD LVCMOS33 [get_ports hsync]
set_property PACKAGE_PIN R19     [get_ports vsync]						
set_property IOSTANDARD LVCMOS33 [get_ports vsync]

##Buttons
set_property PACKAGE_PIN U18 	 [get_ports reset]						
set_property IOSTANDARD LVCMOS33 [get_ports reset]


set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets tm_clk_IBUF]

##Pmod Header JA
##Sch name = JA1
set_property PACKAGE_PIN J1 [get_ports {tm_wt_x_in[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_x_in[0]}]
##Sch name = JA2
set_property PACKAGE_PIN L2 [get_ports {tm_wt_x_in[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_x_in[1]}]
##Sch name = JA3
set_property PACKAGE_PIN J2 [get_ports {tm_wt_x_in[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_x_in[2]}]
##Sch name = JA4
set_property PACKAGE_PIN G2 [get_ports {tm_wt_x_in[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_x_in[3]}]
##Sch name = JA7
set_property PACKAGE_PIN H1 [get_ports {tm_wt_x_in[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_x_in[4]}]
##Sch name = JA8
set_property PACKAGE_PIN K2 [get_ports {tm_wt_x_in[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_x_in[5]}]
##Sch name = JA9
set_property PACKAGE_PIN H2 [get_ports {tm_wt_x_in[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_x_in[6]}]
##Sch name = JA10
set_property PACKAGE_PIN G3 [get_ports {tm_wt_x_in[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_x_in[7]}]



##Pmod Header JB
##Sch name = JB1
set_property PACKAGE_PIN A14 [get_ports {tm_wt_y_in[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_y_in[0]}]
##Sch name = JB2
set_property PACKAGE_PIN A16 [get_ports {tm_wt_y_in[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_y_in[1]}]
##Sch name = JB3
set_property PACKAGE_PIN B15 [get_ports {tm_wt_y_in[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_y_in[2]}]
##Sch name = JB4
set_property PACKAGE_PIN B16 [get_ports {tm_wt_y_in[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_y_in[3]}]
##Sch name = JB7
set_property PACKAGE_PIN A15 [get_ports {tm_wt_y_in[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_y_in[4]}]
##Sch name = JB8
set_property PACKAGE_PIN A17 [get_ports {tm_wt_y_in[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_y_in[5]}]
##Sch name = JB9
set_property PACKAGE_PIN C15 [get_ports {tm_wt_y_in[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_y_in[6]}]
##Sch name = JB10 
set_property PACKAGE_PIN C16 [get_ports {tm_wt_y_in[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {tm_wt_y_in[7]}]
 


##Pmod Header JC
##Sch name = JC1
set_property PACKAGE_PIN K17 [get_ports {tm_clk}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {tm_clk}]
##Sch name = JC2
set_property PACKAGE_PIN M18 [get_ports {tm_enable}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {tm_enable}]
##Sch name = JC3
set_property PACKAGE_PIN N17 [get_ports {tm_val}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {tm_val}]
##Sch name = JC4
#set_property PACKAGE_PIN P18 [get_ports {JC[3]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {JC[3]}]
##Sch name = JC7
#set_property PACKAGE_PIN L17 [get_ports {JC[4]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {JC[4]}]
##Sch name = JC8
#set_property PACKAGE_PIN M19 [get_ports {JC[5]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {JC[5]}]
##Sch name = JC9
#set_property PACKAGE_PIN P17 [get_ports {JC[6]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {JC[6]}]
##Sch name = JC10
#set_property PACKAGE_PIN R18 [get_ports {JC[7]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {JC[7]}]


#Pmod Header JXADC
##Sch name = XA1_P
#set_property PACKAGE_PIN J3 [get_ports {vauxp6}]				
#	set_property IOSTANDARD LVCMOS33 [get_ports {vauxp6}]
##Sch name = XA2_P
#set_property PACKAGE_PIN L3 [get_ports {vauxp14}]				
#	set_property IOSTANDARD LVCMOS33 [get_ports {vauxp14}]
##Sch name = XA3_P
#set_property PACKAGE_PIN M2 [get_ports {vauxp7}]				
#	set_property IOSTANDARD LVCMOS33 [get_ports {vauxp7}]
##Sch name = XA4_P
#set_property PACKAGE_PIN N2 [get_ports {vauxp15}]				
#	set_property IOSTANDARD LVCMOS33 [get_ports {vauxp15}]
##Sch name = XA1_N
#set_property PACKAGE_PIN K3 [get_ports {vauxn6}]				
#	set_property IOSTANDARD LVCMOS33 [get_ports {vauxn6}]
##Sch name = XA2_N
#set_property PACKAGE_PIN M3 [get_ports {vauxn14}]				
#	set_property IOSTANDARD LVCMOS33 [get_ports {vauxn14}]
##Sch name = XA3_N
#set_property PACKAGE_PIN M1 [get_ports {vauxn7}]				
#	set_property IOSTANDARD LVCMOS33 [get_ports {vauxn7}]
##Sch name = XA4_N
#set_property PACKAGE_PIN N1 [get_ports {vauxn15}]				
#	set_property IOSTANDARD LVCMOS33 [get_ports {vauxn15}]
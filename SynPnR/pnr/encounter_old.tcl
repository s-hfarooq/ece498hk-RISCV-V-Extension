###################################
# Run the design through Encounter
###################################

# Load LEF Files
#loadLefFile $env(TECH_LEF)
#loadLefFile $env(LIB_LEF)
set init_lef_file "$env(TECH_LEF) $env(LIB_LEF)"

# Setup design and create floorplan
#loadConfig ./encounter.conf 
################################################################################
# Initial setup : replacement for 'source my_design.global'
set my_toplevel          $env(TOP_LEVEL) 
set init_verilog        $env(VLOGOUT_DIR)/$my_toplevel.gate.v
set init_top_cell 		$env(TOP_LEVEL)
set init_design_netlisttype {Verilog}
set init_design_settop {1}

set delaycal_use_default_delay_limit {1000}
set delaycal_default_net_delay {1000.0ps}
set delaycal_default_net_load {0.5pf}
set delaycal_input_transition_delay {120.0ps}

set extract_shrink_factor {1.0}
setLibraryUnit -time 1ns
setLibraryUnit -cap 1pf

set init_pwr_net {VDD}
set init_gnd_net {VSS}

set init_assign_buffer {0}

set init_mmmc_file timingSetup.viewDefinition

################################################################################


init_design

#commitConfig

#Check the design and then save it
saveDesign [format "%s%s" $env(TOP_LEVEL) ".init.enc"]

# Create Floorplan
floorPlan -s 22 16 1 1 1 1
setObjFPlanPolygon cell $env(TOP_LEVEL) 0      0 \
                                        24 18


# Partition Flooplan for sub modules
#setObjFPlanBox Module mydesign/switch 255 30 590 380
# Output pins
editPin	-snap	TRACK	-side	INSIDE	-layer	3	-assign	0	0	-pin	phi1
editPin	-snap	TRACK	-side	INSIDE	-layer	3	-assign	0	1	-pin	phi2
editPin	-snap	TRACK	-side	INSIDE	-layer	3	-assign	0	2	-pin	phi3
editPin	-snap	TRACK	-side	INSIDE	-layer	3	-assign	0	3	-pin	phi12
editPin	-snap	TRACK	-side	INSIDE	-layer	3	-assign	0	4	-pin	sign_RC
editPin	-snap	TRACK	-side	INSIDE	-layer	3	-assign	0	5	-pin	sign_gm


#	Input	pins									
editPin	-snap	TRACK	-side	INSIDE	-layer	3	-assign	24	0	-pin	clk
editPin	-snap	TRACK	-side	INSIDE	-layer	3	-assign	24	1	-pin	rstb
editPin	-snap	TRACK	-side	INSIDE	-layer	3	-assign	24	3.0	-pin	N_ctrl\[0\]
editPin	-snap	TRACK	-side	INSIDE	-layer	3	-assign	24	3.2	-pin	N_ctrl\[1\]
editPin	-snap	TRACK	-side	INSIDE	-layer	3	-assign	24	3.4	-pin	N_ctrl\[2\]
editPin	-snap	TRACK	-side	INSIDE	-layer	3	-assign	24	3.6	-pin	chop_en
editPin	-snap	TRACK	-side	INSIDE	-layer	3	-assign	24	3.8	-pin	loop_sign
#-------------------------------------------------------------------------------------------------
setMultiCpuUsage -localCpu 16

timeDesign -preplace

# Setup Encounter modes
setPlaceMode -congEffort high
setPlaceMode -clkGateAware false
setPlaceMode -placeIoPins false
setPlaceMode -timingDriven true
setPlaceMode -fp true

setCTSMode -routeClkNet true -optAddBuffer true -optLatency true -synthLatencyEffort high -useLibMaxCap true -useLibMaxFanout true -verbose true -engine ck

setOptMode -preserveAssertions			false
setOptMode -leakagePowerEffort			none
#setOptMode -fixHoldAllowSetupTnsDegrade	true
#setOptMode -holdFixingEffort			low
#setOptMode -criticalRange			0.2  (update to next line)
setOptMode -allEndPoints                        true 

setOptMode -fixFanoutLoad			true
setOptMode -holdFixingEffort			high
#setOptMode -yieldEffort			high
setOptMode -effort				high
setOptMode -fixHoldAllowSetupTnsDegrade		false
#setOptMode -reclaimArea			true
#setOptMode -usefulSkew				true


setMaxRouteLayer 6

#setViaGenOption -invoke_verifyGeometry 1 -create_double_row_cut_via 1 -add_pin_to_pin_via 1 -respect_signal_routes 1 (update to next line!)
setViaGenMode -invoke_verifyGeometry true -create_double_row_cut_via 1 -add_pin_to_pin_via true -respect_signal_routes	1

# Add supply rings around core
addRing -spacing {top 0.2 bottom 0.2 left 0.2 right 0.2} -width {top 0.6 bottom 0.6 left 0.6 right 0.6}  -layer {top M2 bottom M2 left M1 right M1} -center 1 -nets {VSS}

setAddStripeMode -break_at {block_ring}
#addStripe -block_ring_top_layer_limit M3 -max_same_layer_jog_length 0.56 -padcore_ring_bottom_layer_limit M1 -number_of_sets 6 -padcore_ring_top_layer_limit M3 -spacing 2.8 -merge_stripes_value 0.28 -layer M4 -block_ring_bottom_layer_limit M1 -width 2 -nets { VSS VDD } -break_stripes_at_block_rings 1
#addStripe -block_ring_top_layer_limit M3 -max_same_layer_jog_length 0.56 -padcore_ring_bottom_layer_limit M2 -number_of_sets 2 -padcore_ring_top_layer_limit M3 -spacing 2.8 -merge_stripes_value 0.28 -layer M4 -block_ring_bottom_layer_limit M2 -width 2 -nets { VSS VDD }


#addEndCap -prefix PwrCap -preCap $env(POWERCAP_CELL) -postCap $env(POWERCAP_CELL) -flipY
addWellTap -cell $env(WELLTAP_CELL) -cellInterval 30 -prefix TAP 

# Avoiding adding antenna diodes initially so that LVS will pass easier. Can change this later when design is more finalized/checked.
setNanoRouteMode -routeInsertAntennaDiode false

# Allow nanoroute to try harder/longer
#setNanoRouteMode -envNumberFailLimit 11

# Place standard cells
placeDesign   
refinePlace -checkRoute 0  -preserveRouting 0 -rmAffectedRouting 0 -swapEEQ 0 -checkPinLayerForAccess 1

# Route power nets
sroute

# Add tie hi lo cells
addTieHiLo -cell $env(TIEHILO_CELL) -createHierPort true -reportHierPort true

# Run in-place optimization
# to fix setup problems
optDesign -preCTS
optDesign -preCTS -drv

group_path -name CLOCK -from $env(DESIGN_CLOCK)
# Run Clock Tree Synthesis
createClockTreeSpec -output encounter.cts
#specifyClockTree -clkfile encounter.cts(update to next line)
specifyClockTree -file encounter.cts 
ckSynthesis -rguide cts.rguide -report report.ctsrpt -macromodel report.ctsmdl -fix_added_buffers

#extractRC
#reportClockTree -postRoute -localSkew -report skew.postRoute.ctsrpt

# Run in-place optimization
optDesign -postCTS 

# Fix all remaining violations
optDesign -postCTS -drv

reset_path_group -name CLOCK
#clearClockDomains
#setClockDomains -fromType register -toType register
optDesign -postCTS -hold
#clearClockDomains

# Add filler cells
#setFillerMode -core $env(FILLER_CELL) -corePrefix FILL -merge true    
#addFiller -cell {FILL1 FILL2 FILL4 FILL8 FILL16 FILL32 FILL64 FILLCAP3 FILLCAP4 FILLCAP8 FILLCAP16 FILLCAP32 FILLCAP64} -prefix FILL -merge true
#addFiller -cell {FILL128A10TL FILL64A10TL FILL32A10TL FILL16A10TL FILLCAP8A10TL FILL4A10TL FILL2A10TL FILL1A10TL} -prefix FILL -merge true
#addFiller

# Run global routing
routeDesign

setDelayCalMode -engine aae -SIAware true
setAnalysisMode -analysisType onChipVariation -cppr both
# Final opt
#optDesign -postRoute -si 
optDesign -postRoute

#clearClockDomains
#   setClockDomains -fromType register -toType register
#   setOptMode -considerNonActivePathGroup true
#   optDesign -postroute -hold
#   clearClockDomains
#   setOptMode -considerNonActivePathGroup false

#optDesign -postRoute -hold

optDesign -postRoute -drv 


# Add filer cells
#setFillerMode -honorPrerouteAsObs true    
#addFiller -cell {FILL128A10TL FILL64A10TL FILL32A10TL FILL16A10TL FILLCAP8A10TL FILL4A10TL FILL2A10TL FILL1A10TL} -prefix FILL -merge true

# Export DEF
defOut -routing -floorplan final.def

## Output GDSII
streamOut final.gds2 -mapFile tsmc065.map -libName DesignLib -merge $env(GDS_LIB) -stripes 1 -mode ALL

## Output Verilog Netlist
## -phys option adds power and ground nets .VDD(VDD) etc. into verilog netlist
#saveNetlist $env(VLOGOUT_DIR)/$env(TOP_LEVEL).pnr.v -excludeTopCellPGPort {VDD VSS} -excludeLeafCell -excludeCellInst {FILL1 FILL2 FILL4 FILL8 FILL16 FILL32 FILL64}
saveNetlist $env(VLOGOUT_DIR)/$env(TOP_LEVEL).pnr.v -flat -includePhysicalCell $env(INCPHY_CELL) -excludeLeafCell -excludeCellInst $env(EXCPHY_CELL)


##create_library_set -name default_libs_min -timing {$env(TSMC_LIB)}
#create_delay_corner -name default_corner_typ -library_set default_libs_min
#create_constraint_mode -name default_mode_setup -sdc_files [list $env(SDC_OUT_DIR)/$env(TOP_LEVEL).gate.sdc]
#create_analysis_view -name default_view_typ -delay_corner default_corner_typ -constraint_mode default_mode_setup
#set_analysis_view -setup {default_view_setup default_view_typ} -hold {default_view_hold default_view_typ}

##write_sdf -version 2.1 -typ_view default_view_typ -min_view default_view_hold -max_view default_view_setup $env(SDF_OUT_DIR)/$env(TOP_LEVEL).pnr.sdf
write_sdf -view slowView -min_period_edges posedge $env(SDF_OUT_DIR)/$env(TOP_LEVEL).pnr.sdf


## Output DSPF RC Data
##write_sdf $env(SDF_OUT_DIR)/$env(TOP_LEVEL).pnr_old.sdf

rcout -spf final.dspf


## Run DRC and Connection checks
verifyGeometry
verifyConnectivity -type all -noAntenna

saveDesign [format "%s%s" $env(TOP_LEVEL) ".finished.enc"]
#
puts "**************************************"
puts "* Encounter script finished          *"
puts "*                                    *"
puts "* Results:                           *"
puts "* --------                           *"
puts "* DEF File:final.def                 *"
puts "* Layout:  final.gds2                *"
puts "* Netlist: final.v                   *"
puts "* Timing:  timing.rep.5.final        *"
puts "*                                    *"
puts "* Type 'win' to get the Main Window  *"
puts "* or type 'exit' to quit             *"
puts "*                                    *"
puts "**************************************"

#exit

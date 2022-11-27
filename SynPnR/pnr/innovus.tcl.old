# innovus -files apr_new.tcl

set apr_dir [pwd]
set rtl_dir $apr_dir/../rtl
set sdc_dir $apr_dir/../sdc
set lib_dir $apr_dir/../lib
set syn_dir $apr_dir/../syn
set syn_output_dir $syn_dir/outputs
set apr_report_dir $apr_dir/reports
set apr_output_dir $apr_dir/outputs

set design_name crxreva_04_digital_sdi

set sdc_file $sdc_dir/$design_name.sdc
# set sdc_file $syn_output_dir/$design_name.gate.sdc
set vlog_file $syn_output_dir/$design_name.gate.v
set lef_files [list $lib_dir/tsmcn28_9lm6X1Z1UUTRDL.tlef $lib_dir/tcbn28hpcplusbwp30p140.lef]
set lib_typical $lib_dir/tcbn28hpcplusbwp30p140tt0p9v25c.lib
set lib_fast    $lib_dir/tcbn28hpcplusbwp30p140ffg1p05vm40c.lib
set lib_slow    $lib_dir/tcbn28hpcplusbwp30p140ssg0p72v125c.lib
set qrc_typical $lib_dir/typical/qrcTechFile
set qrc_rcworst_T $lib_dir/rcworst_T/qrcTechFile
set qrc_rcbest_T $lib_dir/rcbest_T/qrcTechFile
set mmmc_file $lib_dir/mmmc.tcl
set map_file $lib_dir/gdsout_6X1Z1U.map

set tapcell {TAPCELLBWP30P140}
set boundaryleft {BOUNDARY_LEFTBWP30P140}
set boundaryright {BOUNDARY_RIGHTBWP30P140}
set dcap {DCAP4BWP30P140 DCAP8BWP30P140 DCAP16BWP30P140 DCAP32BWP30P140 DCAP64BWP30P140}
set fillcell {FILL2BWP30P140 FILL3BWP30P140 FILL4BWP30P140 FILL8BWP30P140 FILL16BWP30P140 FILL32BWP30P140 FILL64BWP30P140}
set clock_cells {CKND1BWP30P140}

# -- init_design -------------------------------------------------------------

set_message -no_limit
setMultiCpuUsage -localCpu 4
setDesignMode -process 28

set init_design_netlisttype {verilog}
set init_top_cell           $design_name
set init_lef_file           $lef_files
set init_verilog            $vlog_file
set init_mmmc_file          $mmmc_file
# report_analysis_views -type active

set init_pwr_net            {vdd}
set init_gnd_net            {vss}

init_design

# specifyScanChain scanchain -start sdatain -stop sdataout

# -- global connect

proc connectGlobalNets {} {
  globalNetConnect vdd -type pgpin -pin VDD -all -verbose
  globalNetConnect vss -type pgpin -pin VSS -all -verbose
  globalNetConnect vdd -type tiehi
  globalNetConnect vss -type tielo
  applyGlobalNets
}
connectGlobalNets

# -- floorplan

# setDrawView fplan

set height 38.0
set width  38.0
set offset 1.0

floorplan -s $width $height $offset $offset $offset $offset

fit

source "$apr_dir/02_pins.tcl"

# -- power stripes

setAddStripeMode -break_at {block_ring}

addStripe \
  -block_ring_bottom_layer_limit M1   \
  -block_ring_top_layer_limit M6      \
  -padcore_ring_bottom_layer_limit M1 \
  -padcore_ring_top_layer_limit M6    \
  -max_same_layer_jog_length 0.56     \
  -xleft_offset 0                     \
  -layer M6                           \
  -spacing 0.5                        \
  -width 0.5                          \
  -number_of_sets 6                   \
  -nets {vdd vss}

# -- special routing

setViaGenMode -allow_via_expansion true
setViaGenMode -invoke_verifyGeometry true
setViaGenMode -symmetrical_via_only true
setViaGenMode -add_pin_to_pin_via true

sroute \
  -allowJogging 1 \
  -nets {vdd vss}

# -- tap walls

add_tap_walls -cell $boundaryleft -left -prefix boundaryLeft
add_tap_walls -cell $boundaryright -right -prefix boundaryRight

# -- well taps

addWellTap \
  -cell $tapcell \
  -cellInterval 20.0 \
  -checkerBoard \
  -prefix WELLTAP

connectGlobalNets

# -- place design ------------------------------------------------------------

setDesignMode -topRoutingLayer 6

setPlaceMode -place_detail_legalization_inst_gap 2

# setPlaceMode -place_global_exp_allow_missing_scan_chain true
# setPlaceMode -place_global_ignore_scan true
# setPlaceMode -place_global_ignore_scan false
# setPlaceMode -place_global_reorder_scan false

placeDesign

refinePlace \
  -checkRoute 0 \
  -preserveRouting 0 \
  -rmAffectedRouting 0 \
  -swapEEQ 0

connectGlobalNets

# -- clock tree synthesis ----------------------------------------------------

setCTSMode \
  -traceDPinAsLeaf true \
  -traceIoPinAsLeaf true \
  -addClockRootProp true

set_ccopt_property buffer_cells $clock_cells

ccopt_design

# setOptMode -addInst true -addInstancePrefix postCTS
# optDesign -postCTS -Incr -hold -outDir $apr_report_dir/postCTS_hold.rpt

connectGlobalNets

# -- route design ------------------------------------------------------------

setPlaceMode -place_detail_legalization_inst_gap 2
setFillerMode -fitGap true

# -- fillers

setFillerMode -core [list $dcap $fillcell]
addFiller -cell $dcap -prefix dcap
addFiller -cell $fillcell -prefix fill

setNanoRouteMode \
  -routeReserveSpaceForMultiCut true \
  -droutePostRouteSwapVia multiCut \
  -droutePostRouteSpreadWire true

  # -routeWithTimingDriven false \
  # -routeWithSiDriven true \
  # -droutePostRouteWidenWire widen \
  # -drouteMinLengthForWireWidening 0.5
  # -drouteUseMultiCutViaEffort high \

routeDesign -globalDetail

connectGlobalNets

# setOptMode -addInst true -addInstancePrefix postRoute
# optDesign -postRoute -hold -outDir $apr_report_dir/${design_name}_postRoute.rpt

setAnalysisMode -analysisType onChipVariation
timeDesign -postRoute -hold -prefix ${design_name}_postRoute -outDir $apr_report_dir
timeDesign -postRoute -prefix ${design_name}_postRoute -outDir $apr_report_dir

# -- verify and outputs ------------------------------------------------------

verifyConnectivity -type all -report $apr_report_dir/${design_name}_connectivity.rpt

verify_drc -report $apr_report_dir/${design_name}_drc.rpt

summaryReport -noHtml -outfile $apr_report_dir/${design_name}_designSummary.rpt

reportGateCount -outfile $apr_report_dir/${design_name}_gateCount.rpt

setStreamOutMode \
    -pinTextOrientation default \
    -textSize 0.1

streamOut $apr_output_dir/${design_name}.gds -libName $design_name -structureName $design_name -mode ALL -mapFile $map_file

saveNetlist $apr_output_dir/${design_name}.v -includePowerGround -excludeLeafCell -phys

saveNetlist $apr_output_dir/${design_name}_lvs.v -includePowerGround -excludeLeafCell -phys -excludeCellInst "$boundaryleft $boundaryright $tapcell $fillcell"

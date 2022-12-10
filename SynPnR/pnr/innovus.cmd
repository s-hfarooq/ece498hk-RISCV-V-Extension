#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Fri Dec  9 15:13:32 2022                
#                                                     
#######################################################

#@(#)CDS: Innovus v21.10-p004_1 (64bit) 05/18/2021 11:58 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: NanoRoute 21.10-p004_1 NR210506-1544/21_10-UB (database version 18.20.544) {superthreading v2.14}
#@(#)CDS: AAE 21.10-p006 (64bit) 05/18/2021 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: CTE 21.10-p004_1 () May 13 2021 20:04:41 ( )
#@(#)CDS: SYNTECH 21.10-b006_1 () Apr 18 2021 22:44:07 ( )
#@(#)CDS: CPE v21.10-p004
#@(#)CDS: IQuantus/TQuantus 20.1.2-s510 (64bit) Sun Apr 18 10:29:16 PDT 2021 (Linux 2.6.32-431.11.2.el6.x86_64)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
getVersion
getVersion
getVersion
set init_lef_file {/ece498hk/libs/T65GP_RFMIM_2fF_1P0V_2P5V_1p9m_6X1Z1U_ALRDL_OA61_PDK/stdcell_dig/fb_tsmc065gp_rvt_lvt/aci/sc-ad10/lef/tsmc_cln65_a10_6X2Z_tech.lef /ece498hk/libs/T65GP_RFMIM_2fF_1P0V_2P5V_1p9m_6X1Z1U_ALRDL_OA61_PDK/stdcell_dig/fb_tsmc065gp_rvt_lvt/aci/sc-ad10/lef/tsmc65_rvt_sc_adv10_macro.lef}
set init_verilog .././vlogout/toplevel_498.gate.v
set init_top_cell toplevel_498
set init_design_netlisttype Verilog
set init_design_settop 1
set delaycal_use_default_delay_limit 1000
set delaycal_default_net_delay 1000.0ps
set delaycal_default_net_load 0.5pf
set delaycal_input_transition_delay 120.0ps
set extract_shrink_factor 1.0
setLibraryUnit -time 1ns
setLibraryUnit -cap 1pf
set init_pwr_net vdd
set init_gnd_net vss
set init_assign_buffer 0
set init_mmmc_file timingSetup.viewDefinition
init_design
saveDesign toplevel_498.init.enc
floorPlan -s 800 800 0 0 0 0
setObjFPlanPolygon cell toplevel_498 0 0 800 800
editPin -snap TRACK -side INSIDE -layer 3 -assign 2000 4 -pin external_qspi_ck_o
editPin -snap TRACK -side INSIDE -layer 3 -assign 2000 4.4 -pin external_qspi_cs_o
editPin -snap TRACK -side INSIDE -layer 3 -assign 2000 7 -pin {gpio_pins[0]}
editPin -snap TRACK -side INSIDE -layer 3 -assign 2000 7.2 -pin {gpio_pins[1]}
editPin -snap TRACK -side INSIDE -layer 3 -assign 2000 7.4 -pin {gpio_pins[2]}
editPin -snap TRACK -side INSIDE -layer 3 -assign 2000 7.6 -pin {gpio_pins[3]}
editPin -snap TRACK -side INSIDE -layer 3 -assign 2000 7.8 -pin {gpio_pins[4]}
editPin -snap TRACK -side INSIDE -layer 3 -assign 2000 8 -pin {gpio_pins[5]}
editPin -snap TRACK -side INSIDE -layer 3 -assign 2000 8.2 -pin {gpio_pins[6]}
editPin -snap TRACK -side INSIDE -layer 3 -assign 2000 8.4 -pin {gpio_pins[7]}
editPin -snap TRACK -side INSIDE -layer 3 -assign 2000 8.6 -pin {gpio_pins[8]}
editPin -snap TRACK -side INSIDE -layer 3 -assign 2000 8.8 -pin {gpio_pins[9]}
editPin -snap TRACK -side INSIDE -layer 3 -assign 2000 10 -pin {external_qspi_pins[0]}
editPin -snap TRACK -side INSIDE -layer 3 -assign 2000 10.2 -pin {external_qspi_pins[1]}
editPin -snap TRACK -side INSIDE -layer 3 -assign 2000 10.4 -pin {external_qspi_pins[2]}
editPin -snap TRACK -side INSIDE -layer 3 -assign 2000 10.8 -pin {external_qspi_pins[3]}
editPin -snap TRACK -side INSIDE -layer 3 -assign 0 1 -pin clk
editPin -snap TRACK -side INSIDE -layer 3 -assign 0 1.4 -pin rst
editPin -snap TRACK -side INSIDE -layer 3 -assign 0 1.8 -pin set_programming_mode
setMultiCpuUsage -localCpu 4
timeDesign -preplace
setPlaceMode -congEffort high
setPlaceMode -clkGateAware false
setPlaceMode -placeIoPins false
setPlaceMode -timingDriven true
setPlaceMode -fp true
setOptMode -preserveAssertions false
setOptMode -leakagePowerEffort none
setOptMode -allEndPoints true
setOptMode -fixFanoutLoad true
setOptMode -holdFixingEffort high
setOptMode -effort high
setOptMode -fixHoldAllowSetupTnsDegrade false
setRouteMode -earlyGlobalMaxRouteLayer 6
setPinAssignMode -maxLayer 6
setNanoRouteMode -routeTopRoutingLayer 6
setDesignMode -topRoutingLayer M6
setViaGenMode -invoke_verifyGeometry true -create_double_row_cut_via 1 -add_pin_to_pin_via true -respect_signal_routes 1
setAddRingOption -avoid_short 1
addRing -spacing {top 0.2 bottom 0.2 left 0.2 right 0.2} -width {top 0.6 bottom 0.6 left 0.6 right 0.6} -layer {top M1 bottom M1 left M2 right M2} -center 1 -nets {vss vdd}
addStripe -block_ring_top_layer_limit M5 -max_same_layer_jog_length 0.56 -padcore_ring_bottom_layer_limit M1 -number_of_sets 6 -padcore_ring_top_layer_limit M4 -spacing 1.84 -merge_stripes_value 0.28 -layer M5 -block_ring_bottom_layer_limit M1 -width 1 -nets { vss vdd }
sroute
addEndCap -prefix PwrCap -preCap FILLCAP16A10TR -postCap FILLCAP16A10TR -flipY
addWellTap -cell FILLTIE2A10TR -cellInterval 30 -prefix TAP
setNanoRouteMode -routeInsertAntennaDiode false
getPlaceMode -place_hierarchical_flow -quiet
report_message -start_cmd
getRouteMode -maxRouteLayer -quiet
getRouteMode -user -maxRouteLayer
getPlaceMode -place_global_place_io_pins -quiet
getPlaceMode -user -maxRouteLayer
getPlaceMode -quiet -adaptiveFlowMode
getPlaceMode -timingDriven -quiet
getPlaceMode -adaptive -quiet
getPlaceMode -relaxSoftBlockageMode -quiet
getPlaceMode -user -relaxSoftBlockageMode
getPlaceMode -ignoreScan -quiet
getPlaceMode -user -ignoreScan
getPlaceMode -repairPlace -quiet
getPlaceMode -user -repairPlace
getPlaceMode -inPlaceOptMode -quiet
getPlaceMode -quiet -bypassFlowEffortHighChecking
getPlaceMode -exp_slack_driven -quiet
um::push_snapshot_stack
getDesignMode -quiet -flowEffort
getDesignMode -highSpeedCore -quiet
getPlaceMode -quiet -adaptive
set spgFlowInInitialPlace 1
getPlaceMode -sdpAlignment -quiet
getPlaceMode -softGuide -quiet
getPlaceMode -useSdpGroup -quiet
getPlaceMode -sdpAlignment -quiet
getPlaceMode -enableDbSaveAreaPadding -quiet
getPlaceMode -quiet -wireLenOptEffort
getPlaceMode -sdpPlace -quiet
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -sdpPlace -quiet
getPlaceMode -groupHighLevelClkGate -quiet
setvar spgRptErrorForScanConnection 0
getPlaceMode -place_global_exp_allow_missing_scan_chain -quiet
getPlaceMode -place_check_library -quiet
getPlaceMode -trimView -quiet
getPlaceMode -expTrimOptBeforeTDGP -quiet
getPlaceMode -quiet -useNonTimingDeleteBufferTree
getPlaceMode -congEffort -quiet
getPlaceMode -relaxSoftBlockageMode -quiet
getPlaceMode -user -relaxSoftBlockageMode
getPlaceMode -ignoreScan -quiet
getPlaceMode -user -ignoreScan
getPlaceMode -repairPlace -quiet
getPlaceMode -user -repairPlace
getPlaceMode -congEffort -quiet
getPlaceMode -fp -quiet
getPlaceMode -timingDriven -quiet
getPlaceMode -user -timingDriven
getPlaceMode -fastFp -quiet
getPlaceMode -clusterMode -quiet
get_proto_model -type_match {flex_module flex_instgroup} -committed -name -tcl
getPlaceMode -inPlaceOptMode -quiet
getPlaceMode -quiet -bypassFlowEffortHighChecking
getPlaceMode -ultraCongEffortFlow -quiet
getPlaceMode -forceTiming -quiet
getPlaceMode -fp -quiet
getPlaceMode -fp -quiet
getExtractRCMode -quiet -engine
getAnalysisMode -quiet -clkSrcPath
getAnalysisMode -quiet -clockPropagation
getAnalysisMode -quiet -cppr
setExtractRCMode -engine preRoute
setAnalysisMode -clkSrcPath false -clockPropagation forcedIdeal
getPlaceMode -exp_slack_driven -quiet
isAnalysisModeSetup
getPlaceMode -quiet -place_global_exp_solve_unbalance_path
getPlaceMode -quiet -NMPsuppressInfo
getPlaceMode -quiet -place_global_exp_wns_focus_v2
getPlaceMode -enableDistPlace -quiet
getPlaceMode -quiet -clusterMode
getPlaceMode -wl_budget_mode -quiet
setPlaceMode -reset -place_global_exp_balance_buffer_chain
getPlaceMode -wl_budget_mode -quiet
setPlaceMode -reset -place_global_exp_balance_pipeline
getPlaceMode -place_global_exp_balance_buffer_chain -quiet
getPlaceMode -place_global_exp_balance_pipeline -quiet
getPlaceMode -tdgpMemFlow -quiet
getPlaceMode -user -resetCombineRFLevel
getPlaceMode -quiet -resetCombineRFLevel
setPlaceMode -resetCombineRFLevel 1000
setvar spgSpeedupBuildVSM 1
getPlaceMode -tdgpResetCteTG -quiet
getPlaceMode -macroPlaceMode -quiet
getPlaceMode -place_global_replace_QP -quiet
getPlaceMode -macroPlaceMode -quiet
getPlaceMode -enableDistPlace -quiet
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -place_global_ignore_spare -quiet
getPlaceMode -enableDistPlace -quiet
getPlaceMode -quiet -expNewFastMode
setPlaceMode -expHiddenFastMode 1
setPlaceMode -reset -ignoreScan
getPlaceMode -quiet -place_global_exp_auto_finish_floorplan
colorizeGeometry
getPlaceMode -quiet -IOSlackAdjust
getPlaceMode -tdgpCteZeroDelayModeDelBuf -quiet
set_global timing_enable_zero_delay_analysis_mode true
getPlaceMode -quiet -useNonTimingDeleteBufferTree
getPlaceMode -quiet -prePlaceOptSimplifyNetlist
getPlaceMode -quiet -enablePrePlaceOptimizations
getPlaceMode -quiet -prePlaceOptDecloneInv
deleteBufferTree -decloneInv
getPlaceMode -tdgpCteZeroDelayModeDelBuf -quiet
set_global timing_enable_zero_delay_analysis_mode false
getPlaceMode -exp_slack_driven -quiet
all_setup_analysis_views
getPlaceMode -place_global_exp_ignore_low_effort_path_groups -quiet
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -ignoreUnproperPowerInit -quiet
getPlaceMode -quiet -expSkipGP
setDelayCalMode -engine feDc
setDelayCalMode -engine aae
all_setup_analysis_views
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -quiet -tdgpAdjustNetWeightBySlack
get_ccopt_clock_trees *
getPlaceMode -exp_insert_guidance_clock_tree -quiet
getPlaceMode -exp_cluster_based_high_fanout_buffering -quiet
getPlaceMode -place_global_exp_incr_skp_preserve_mode_v2 -quiet
getPlaceMode -quiet -place_global_exp_netlist_balance_flow
getPlaceMode -quiet -timingEffort
getPlaceMode -exp_slack_driven -quiet
all_setup_analysis_views
getPlaceMode -place_global_exp_ignore_low_effort_path_groups -quiet
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -quiet -cong_repair_commit_clock_net_route_attr
getPlaceMode -enableDbSaveAreaPadding -quiet
getPlaceMode -quiet -wireLenOptEffort
setPlaceMode -reset -improveWithPsp
getPlaceMode -quiet -debugGlobalPlace
getPlaceMode -congRepair -quiet
getPlaceMode -fp -quiet
getPlaceMode -nrgrAware -quiet
getPlaceMode -fp -quiet
getPlaceMode -enableCongRepairV3 -quiet
getPlaceMode -user -rplaceIncrNPClkGateAwareMode
getPlaceMode -user -congRepairMaxIter
getPlaceMode -quiet -congRepairPDClkGateMode4
setPlaceMode -rplaceIncrNPClkGateAwareMode 4
getPlaceMode -quiet -expCongRepairPDOneLoop
setPlaceMode -congRepairMaxIter 1
getPlaceMode -quiet -congRepair
getPlaceMode -quiet -congRepairPDClkGateMode4
setPlaceMode -reset -rplaceIncrNPClkGateAwareMode
setPlaceMode -reset -congRepairMaxIter
getPlaceMode -congRepairCleanupPadding -quiet
getPlaceMode -quiet -wireLenOptEffort
all_setup_analysis_views
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -place_global_exp_incr_skp_preserve_mode_v2 -quiet
getPlaceMode -quiet -place_global_exp_netlist_balance_flow
getPlaceMode -quiet -timingEffort
getPlaceMode -tdgpDumpStageTiming -quiet
getPlaceMode -quiet -tdgpAdjustNetWeightBySlack
getPlaceMode -trimView -quiet
getOptMode -quiet -viewOptPolishing
getOptMode -quiet -fastViewOpt
spInternalUse deleteViewOptManager
spInternalUse tdgp clearSkpData
setAnalysisMode -clkSrcPath false -clockPropagation forcedIdeal
getPlaceMode -exp_slack_driven -quiet
setExtractRCMode -engine preRoute
setPlaceMode -reset -relaxSoftBlockageMode
setPlaceMode -reset -ignoreScan
setPlaceMode -reset -repairPlace
getPlaceMode -quiet -NMPsuppressInfo
setvar spgSpeedupBuildVSM 0
getPlaceMode -macroPlaceMode -quiet
getPlaceMode -place_global_replace_QP -quiet
getPlaceMode -macroPlaceMode -quiet
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -enableDistPlace -quiet
getPlaceMode -place_global_ignore_spare -quiet
getPlaceMode -tdgpMemFlow -quiet
setPlaceMode -reset -resetCombineRFLevel
getPlaceMode -enableDistPlace -quiet
getPlaceMode -quiet -clusterMode
getPlaceMode -quiet -place_global_exp_solve_unbalance_path
getPlaceMode -enableDistPlace -quiet
setPlaceMode -reset -expHiddenFastMode
getPlaceMode -tcg2Pass -quiet
getPlaceMode -quiet -wireLenOptEffort
getPlaceMode -fp -quiet
getPlaceMode -quickCTS -quiet
set spgFlowInInitialPlace 0
getPlaceMode -user -maxRouteLayer
spInternalUse TDGP resetIgnoreNetLoad
getPlaceMode -place_global_exp_balance_pipeline -quiet
getDesignMode -quiet -flowEffort
report_message -end_cmd
um::create_snapshot -name final -auto min
um::pop_snapshot_stack
um::create_snapshot -name place_design
getPlaceMode -exp_slack_driven -quiet
refinePlace -checkRoute 0 -preserveRouting 0 -rmAffectedRouting 0 -swapEEQ 0 -checkPinLayerForAccess 1
addTieHiLo -cell {TIEHIX1MA10TR TIELOX1MA10TR} -createHierPort true -reportHierPort true
optDesign -preCTS
optDesign -preCTS -drv
group_path -name CLOCK -from $env(DESIGN_CLOCK)
set_ccopt_property buffer_cells {BUFX16MA10TR BUFX16BA10TR FRICGX11BA10TR BUFX5BA10TR FRICGX13BA10TR INVX16BA10TR INVX9BA10TR}
ccopt_design
optDesign -postCTS
optDesign -postCTS -drv
reset_path_group -name CLOCK
optDesign -postCTS -hold
setFillerMode -core {"FILL128A10TR FILL64A10TR FILL32A10TR FILL16A10TR FILLCAP8A10TR FILL4A10TR FILL2A10TR FILL1A10TR"} -corePrefix FILL -merge true
addFiller
routeDesign -globalDetail
setDelayCalMode -engine aae -SIAware true
setAnalysisMode -analysisType onChipVariation -cppr both
optDesign -postRoute
optDesign -postRoute -drv
defOut -routing -floorplan final.def
streamOut final.gds2 -mapFile tsmc065.map -libName DesignLib -merge /ece498hk/libs/T65GP_RFMIM_2fF_1P0V_2P5V_1p9m_6X1Z1U_ALRDL_OA61_PDK/stdcell_dig/fb_tsmc065gp_rvt_lvt/aci/sc-ad10/gds2/tsmc65_rvt_sc_adv10.gds2 -stripes 1 -mode ALL
saveNetlist .././vlogout/toplevel_498.pnr.v -flat -includePhysicalCell {FILLCAP16A10TR FILLCAP8A10TR} -excludeLeafCell -excludeCellInst {FILL128A10TR FILLTIE128A10TR FILL64A10TR FILLTIE64A10TR FILL32A10TR FILLTIE32A10TR FILL16A10TR FILLTIE16A10TR FILL8A10TR FILLTIE8A10TR FILL4A10TR FILLTIE4A10TR FILL2A10TR FILLTIE2A10TR FILL1A10TR}
write_sdf -view slowView -min_period_edges posedge $env(SDF_OUT_DIR)/$env(TOP_LEVEL).pnr.sdf
saveDrc /tmp/innovus_temp_1318001_ece-498hk-01.ece.illinois.edu_hfaroo9_ndBuTK/vergQTmpBc3Tyi/qthread_src.drc
clearDrc
saveDrc /tmp/innovus_temp_1318001_ece-498hk-01.ece.illinois.edu_hfaroo9_ndBuTK/vergQTmpBc3Tyi/qthread_2.drc
saveDrc /tmp/innovus_temp_1318001_ece-498hk-01.ece.illinois.edu_hfaroo9_ndBuTK/vergQTmpBc3Tyi/qthread_0.drc
saveDrc /tmp/innovus_temp_1318001_ece-498hk-01.ece.illinois.edu_hfaroo9_ndBuTK/vergQTmpBc3Tyi/qthread_1.drc
saveDrc /tmp/innovus_temp_1318001_ece-498hk-01.ece.illinois.edu_hfaroo9_ndBuTK/vergQTmpBc3Tyi/qthread_3.drc
loadDrc -incremental /tmp/innovus_temp_1318001_ece-498hk-01.ece.illinois.edu_hfaroo9_ndBuTK/vergQTmpBc3Tyi/qthread_src.drc
verifyConnectivity -type all -noAntenna
saveDesign toplevel_498.finished.enc
win
pan -158.84550 -21.95650
pan -339.75250 50.11250
zoomBox -456.17300 -97.19400 1622.86150 907.94350
zoomBox 216.15200 404.36750 1138.63150 850.35300
zoomBox 296.94500 463.86000 1081.05300 842.94750
zoomBox 587.32750 671.91300 883.05400 814.88600
zoomBox 636.42750 706.06100 850.09000 809.35900
zoomBox 716.05100 761.43750 796.63500 800.39700
zoomBox 729.76650 769.14250 787.98900 797.29100
zoomBox 470.11200 623.27750 951.67200 856.09400
zoomBox -2108.57200 -825.33650 2577.25400 1440.09000
zoomBox -1690.98950 -595.83550 2291.96250 1329.77700
zoomBox -1336.04450 -401.11850 2049.46450 1235.65200
zoomBox -558.64800 16.44900 1520.47850 1021.63100
pan -86.26550 433.82150
selectWire 719.0500 739.4500 719.1500 764.3500 4 vproc_top_u_core_gen_regfile_ff_register_file_i/FE_OFN713_n1550
zoomBox -109.89900 205.63850 1166.94600 822.94650
deselectAll
selectInst vproc_top_u_core_gen_regfile_ff_register_file_i/U2341
deselectAll
selectInst vproc_top_u_core_gen_regfile_ff_register_file_i/U1734
deselectAll
zoomSelected
selectWire 738.4500 740.0500 738.5500 742.9500 2 {vproc_top_u_core_gen_regfile_ff_register_file_i/rf_reg_q[255]}
deselectAll
selectWire 419.8500 524.2500 421.3500 524.3500 3 vproc_top_v_core_genblk9_0__pipe_genblk2_pipeline/FE_DBTN102_unpack_out_ops_8
deselectAll
selectWire 214.0500 569.0500 214.1500 570.9500 2 CTS_59
deselectAll
selectWire 125.2500 419.8500 129.1500 419.9500 3 vproc_top_v_core_genblk9_0__pipe_genblk2_pipeline/n1827
deselectAll
selectInst FE_OFC517_n9406
deselectAll
selectInst TAP_5737
deselectAll
selectInst U8659
deselectAll
selectInst U9938
deselectAll
selectInst vproc_top_v_core_genblk9_0__pipe_genblk2_pipeline/U45671
deselectAll
selectInst vproc_top_v_core_vregfile/genblk1_0__genblk1_genblk1_1__ram_reg_8__58_
deselectAll
selectInst vproc_top_v_core_vregfile/genblk1_0__genblk1_genblk1_1__ram_reg_3__77_
zoomBox 20.81850 294.54900 1106.13650 819.26100
zoomBox 131.92700 370.12300 1054.44850 816.12850
zoomBox 375.95300 533.66300 942.49600 807.56600
zoomBox 525.81500 634.09650 873.74350 802.30750
zoomBox 541.91350 651.07450 837.65350 794.05400
zoomBox 555.59800 665.50600 806.97700 787.03850
zoomBox 597.08300 685.13700 778.70450 772.94450
deselectAll
selectInst vproc_top_u_core_gen_regfile_ff_register_file_i/rf_reg_q_reg_20__31_
zoomBox 627.05600 699.32050 758.27800 762.76150
zoomBox 639.21150 705.33300 750.75050 759.25800
zoomBox 695.98100 732.03250 714.64750 741.05700
zoomBox 693.96850 731.09750 715.92900 741.71450
zoomBox 691.60100 729.99700 717.43700 742.48800
zoomBox 688.81500 728.70250 719.21100 743.39800
zoomBox 685.53750 727.18000 721.29800 744.46900
zoomBox 681.68150 725.39250 723.75300 745.73250
zoomBox 677.14550 723.28950 726.64150 747.21900
zoomBox 665.53050 717.90500 734.03750 751.02550
zoomBox 457.27050 621.35950 866.65800 819.28350
zoomBox 413.13250 600.94150 894.76550 833.79350
zoomBox 300.11600 548.66050 966.73600 870.94700
pan -89.79100 137.50800
zoomBox 100.53800 410.17750 884.79700 789.33800
zoomBox 34.87500 372.39450 957.53300 818.46600
zoomBox -133.25700 275.64950 1143.77800 893.04950
pan -55.28950 243.03800
deselectAll
zoomBox -3568.68850 -846.44600 1944.87750 1819.16250
zoomBox -5303.06150 -1322.69800 2328.17150 2366.72550
zoomBox -13138.97900 -3474.41100 4059.89750 4840.62000
zoomBox -7575.87450 -2224.18550 2986.38550 2882.28300
zoomBox -3349.90900 -1119.11950 2163.65800 1546.48950
zoomBox -2657.64700 -938.09700 2028.88550 1327.67100
zoomBox -144.19700 32.84250 941.28400 557.63300
zoomBox -213.65450 -23.36850 1063.38200 594.03200
pan -212.71150 114.26300
pan 479.94450 659.48000
pan -211.17600 19.04200
zoomBox -336.61100 7.70950 1165.78450 734.06300
pan 12.64800 59.74150
zoomBox 56.91200 -154.66200 841.17250 224.49950
zoomBox 468.93950 -3.53500 487.60900 5.49100
zoomBox 466.69250 -5.20400 492.53300 7.28900
zoomBox 461.60600 -8.98250 503.68250 11.36000
zoomBox 445.07750 -21.25950 539.90950 24.58850
zoomBox 417.81900 -41.41550 599.48950 46.41550
zoomBox -177.96350 -481.97350 1901.75750 523.49600
pan -493.98050 144.95000
zoomBox 247.57750 533.59700 289.65700 553.94100

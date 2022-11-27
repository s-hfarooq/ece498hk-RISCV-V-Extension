if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name fastLib\
   -timing\
    [list ${::IMEX::libVar}/mmmc/scadv10_cln65gp_rvt_ff_1p1v_m40c.lib]
create_library_set -name slowLib\
   -timing\
    [list ${::IMEX::libVar}/mmmc/scadv10_cln65gp_rvt_ss_0p9v_125c.lib]
create_rc_corner -name default_rc_corner\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0
create_delay_corner -name slowDC\
   -library_set slowLib
create_delay_corner -name fastDC\
   -library_set fastLib
create_constraint_mode -name mode\
   -sdc_files\
    [list ${::IMEX::dataVar}/mmmc/modes/mode/mode.sdc]
create_analysis_view -name slowView -constraint_mode mode -delay_corner slowDC
create_analysis_view -name fastView -constraint_mode mode -delay_corner fastDC
set_analysis_view -setup [list slowView] -hold [list fastView]

/* mmicImportVerilogDesign.il : To import the gds and verilog gate level 

   netlist in TSMC 90nm technology.
*/
/*******************************************************************************
*** THIS IS A SCRIPT for IC616 ***
/* mmicImportVerilogDesign
   To import gds and verilog netlist.
   Example Usage :
   mmicImportVerilogDesign( ?paramFileName <File0> ?strmInTemplate <File1>
   ?verilogInTemplate <File2> ?schGenTemplate <File3> )

   Parameters :
   
   'paramFileName (optional)- File that includes the parameters used by the 
   procedure. These parameters include the GDSII filee, Verilog file, 
   library / cell name and reference library order. See the example file for 
   expected syntax.
   DEFAULT VALUE : ivdParamFile

   'strmInTemplate (optional)- Template file for gds stream in options.
   DEFAULT VALUE : design_streamIn.options.template

   'verilogInTemplate (optional)- Template file for verilogIn options.
   DEFAULT VALUE : design_ihdlParam.template

   'schGenTemplate (optional)- Template file for connectivity to schematic 
   generation options.
   DEFAULT VALUE : design_schGenParam.template

   
   Following log files are created :
   
   PIPO_<username>.log      - GDS import log file.
   VerilogIn_<username>.log - Verilog netlist import log file. 
   conn2sch_<username>.log  - Connectivity to Schematic generation log file.
*/

procedure( mmicImportVerilogDesign( @key (paramFileName "ivdParamFile")
	(strmInTemplate "design_streamIn.options.template")
	(verilogInTemplate "design_ihdlParam.template")
	(schGenTemplate "design_schGenParam.template")
	)
; Load the parameter file
load( paramFileName )


/*******************************************************************************
STEP 1 : GDS Import
*******************************************************************************/
; Load the stream in template file
load( strmInTemplate )

; replace the parameters in streamIn keys
streamInKeys->strmFile = importVerilogDesignKeys->gdsInFile
streamInKeys->topCell = importVerilogDesignKeys->primaryCellName
streamInKeys->library = importVerilogDesignKeys->designLibName
streamInKeys->logFile = strcat("./strmin_YourNetID.log" )

; Create the refLibList file
gdsImportRefLibFile = strcat( "./design_strmin_YourNetID.refLibList" )
gdsOutPort = outfile( gdsImportRefLibFile )
fprintf( gdsOutPort "%s\n" importVerilogDesignKeys->refLibOrder )
close( gdsOutPort )

; Create an import options file
gdsImportOptFile = strcat( "./design_strmin_YourNetID.options" )

; Write to the options file
gdsOutPort = outfile( gdsImportOptFile )
fprintf( gdsOutPort "library \"%s\" \t #<destination library>\n" streamInKeys->library )
fprintf( gdsOutPort "strmFile \"%s\" \t #<input stream file>\n" streamInKeys->strmFile )
fprintf( gdsOutPort "runDir \"%s\" \t #<run directory>\n" streamInKeys->runDir )
fprintf( gdsOutPort "logFile \"%s\" \t #<output log file name>\n" streamInKeys->logFile )
fprintf( gdsOutPort "topCell \"%s\" \t #<toplevel cell to translate>\n" streamInKeys->topCell )
fprintf( gdsOutPort "view \"%s\" \t #<destination view name>\n" streamInKeys->view )
fprintf( gdsOutPort "hierDepth %d \t #<hierarchical depth to translate to>\n" streamInKeys->hierDepth )
fprintf( gdsOutPort "summaryFile \"%s\" \t #<summary file name>\n" streamInKeys->summaryFile )
fprintf( gdsOutPort "cellMap \"%s\" \t #<input cell map file>\n" streamInKeys->cellMap )
fprintf( gdsOutPort "case  %s \t #<upper | lower | preserve >\n" streamInKeys->case )
fprintf( gdsOutPort "layerMap \"%s\" \t #<input layer map file>\n" streamInKeys->layerMap )
fprintf( gdsOutPort "fontMap \"%s\" \t #<input font map file>\n" streamInKeys->fontMap )
fprintf( gdsOutPort "propMap \"%s\" \t #<input property map file>\n" streamInKeys->propMap )
fprintf( gdsOutPort "objectMap \"%s\" \t #<object mapping file>\n" streamInKeys->objectMap )
fprintf( gdsOutPort "viaMap \"%s\" \t #<via mapping file>\n" streamInKeys->viaMap )
fprintf( gdsOutPort "userSkillFile \"%s\" \t #<User skill file>\n" streamInKeys->userSkillFile )
fprintf( gdsOutPort "propSeparator \"%s\" \t #<property separator character>\n" streamInKeys->propSeparator )
fprintf( gdsOutPort "pinAttNum %d \t #< Stream Attribute number 0-127 >\n" streamInKeys->pinAttNum )
fprintf( gdsOutPort "refLibList \"%s\" \t #<Name of the file containing refliblist>\n" gdsImportRefLibFile )
fprintf( gdsOutPort "attachTechFileOfLib \"%s\" \t #<Attach this tech lib with target lib>\n" streamInKeys->attachTechFileOfLib )
fprintf( gdsOutPort "loadTechFile \"%s\" \t #<Ascii tech file>\n" streamInKeys->loadTechFile )
; To convert square brackets to angle brackets by default
fprintf( gdsOutPort "replaceBusBitChar \n" streamInKeys->loadTechFile )
close( gdsOutPort )

; Execute the import command
csh( strcat( "strmin -templateFile " gdsImportOptFile ) )

/*******************************************************************************
STEP 2 : Verilog Netlist Import
*******************************************************************************/
verInTemplPort = infile( verilogInTemplate )

; Write the parameter file
verInParamFile = strcat( "./design_verin_YourNetID.options" )
verInOutPort = outfile( verInParamFile )

fprintf( verInOutPort "-- Verilog In Form\n" )
fprintf( verInOutPort "dest_sch_lib := %s\n" importVerilogDesignKeys->designLibName )
; Convert reference library list into comma separated list
rexCompile("[ \t\n]")
refLibString = rexReplace(importVerilogDesignKeys->refLibOrder ", " 0)
refLibString = strcat( "basic, " refLibString)
fprintf( verInOutPort "ref_lib_list := %s\n" refLibString )

verInLogFile = strcat( "./verilogIn_YourNetID.log" )
fprintf( verInOutPort "log_file_name := %s\n" verInLogFile )

; Take the rest from template file
while( gets(inStr verInTemplPort)
	fprintf( verInOutPort inStr)
	)

close( verInTemplPort )
close( verInOutPort )

; Execute the import command
ihdlExecFile = "ihdl"
csh( strcat( ihdlExecFile " -param " verInParamFile " -cdslib cds.lib "
  importVerilogDesignKeys->verilogInFile ) )

/*******************************************************************************
STEP 3 : Convert Netlist view to Schematic view
*******************************************************************************/
conn2schExecFile = "conn2sch"
csh(strcat(conn2schExecFile " -param " schGenTemplate
    " -lib " importVerilogDesignKeys->designLibName
    " -cell " importVerilogDesignKeys->primaryCellName
    " -view netlist -destView schematic -cdslib cds.lib "
    " -destLib " importVerilogDesignKeys->designLibName
    " -min_crossovers +place_only -verbose "
    " -log mmicImportVerilogDesign_conn2sch_YourNetID.log")
)

/*******************************************************************************
STEP 4 : Add netset ground and power
*******************************************************************************/
; Update the library list
ddUpdateLibList()

mmicAddnetsetToAllInstance( importVerilogDesignKeys->designLibName
	importVerilogDesignKeys->primaryCellName )

) ; procedure


; Execute the procedure mmicAddPinsToSchematic
;mmicAddPinsToSchematic( importVerilogDesignKeys->designLibName
;	importVerilogDesignKeys->primaryCellName )
;
;) ; procedure

/******************************************************************************/
/* AddnetsetToAllInstance
	author: KYU SANG PARK
	date: Feb 21, 2022
	add netset power and ground
*/

procedure( mmicAddnetsetToAllInstance(libName cellName @key (schViewName "schematic")
	(netsetVdd "vdd")
	(netsetVss "vss")
	)

	d_cvId = dbOpenCellViewByType( libName cellName schViewName nil "a" )
	foreach(inst d_cvId~>instances
	  unless(inst~>pin
	    dbReplaceProp(inst "power" "netSet" netsetVdd)
	    dbReplaceProp(inst "ground" "netSet" netsetVss)
	  )
	)
	dbSave( d_cvId )
	dbClose( d_cvId )
) ;procedure

/******************************************************************************/
/* mmicAddPinsToSchematic
   To add pins to the schematic view from symbol view.
   Example Usage :
   mmicAddPinsToSchematic( libName cellName ?schViewName <schview> 
	?pinRefViewName <symview> ?NLPExprVdd <str0>
	?NLPExprVss <str1> ?StartXCoord <num> ?StartYCoord <num> )

   Parameters :
   
   'libName (mandatory)- Library name

   'cellName (mandatory)- Name of the cell which will be modified

   'schViewName (optional)- View name for the schematic
   DEFAULT VALUE : schematic

   'pinRefViewName (optional)- Reference view to generate list of pins
   DEFAULT VALUE : symbol

   'NLPExprVdd (optional)- Net expression for supply pin. This is used to 
   create an inherited supply pin.
   DEFAULT VALUE : [@power:%:VDD!] 

   'NLPExprVss (optional)- Net expression for ground pin. This is used to 
   create an inherited ground pin.
   DEFAULT VALUE : [@ground:%:VSS!] 

   'startXCoord (optional)- X Coordinate from which the pin placement starts.
   DEFAULT VALUE : 0

   'startYCoord (optional)- Y Coordinate from which the pin placement starts. 
   The pins are placed vertically with increasing Y coordinate values.
   DEFAULT VALUE : 0
*/
procedure( mmicAddPinsToSchematic(libName cellName @key (schViewName "schematic")
	(pinRefViewName "symbol")
	(NLPExprVdd "[@power:%:VDD!]")
	(NLPExprVss "[@ground:%:VSS!]")
	(startXCoord 0)
	(startYCoord 0)
	)

/* This procedure assumes that pin placement can start from (0,0) coordinate */ 
XCoord = startXCoord
YCoord = startYCoord

d_cvId = dbOpenCellViewByType( libName cellName schViewName nil "a" )

/* Get the pin names and directions from Reference view */
d_refcvId = dbOpenCellViewByType( libName cellName pinRefViewName nil "r" )
/* Get the list of pins */
l_pinNames = schGetPinOrder( d_refcvId )


ioPinMaster=dbOpenCellViewByType("basic" "iopin" "symbol")
iPinMaster=dbOpenCellViewByType("basic" "ipin" "symbol")
oPinMaster=dbOpenCellViewByType("basic" "opin" "symbol")

foreach( pin l_pinNames
	/* Get the reference term */
	refTerm = dbFindTermByName( d_refcvId pin )

	refTermDir = refTerm~>direction
	case( refTermDir
			( "input"
			schCreatePin( d_cvId iPinMaster refTerm~>name refTerm~>direction nil XCoord:YCoord "R0" )
			)
			( "output"
			schCreatePin( d_cvId oPinMaster refTerm~>name refTerm~>direction nil XCoord:YCoord "R0" )
			)
			( t
			schCreatePin( d_cvId ioPinMaster refTerm~>name refTerm~>direction nil XCoord:YCoord "R0" )
			)
		)	
	YCoord++
	)
dbClose( d_refcvId )

/* Add the VDD/VSS Pins */
schCreatePin( d_cvId ioPinMaster "VDD" "inputOutput" nil XCoord:YCoord "R0" )
YCoord++
schCreatePin( d_cvId ioPinMaster "VSS" "inputOutput" nil XCoord:YCoord "R0" )

dbSetConnCurrent( d_cvId )
schExtractConn( d_cvId )
dbSave( d_cvId )

schTermVdd = dbFindTermByName( d_cvId "VDD" )
schTermVss = dbFindTermByName( d_cvId "VSS" )

dbReplaceTermNetExpr( schTermVdd NLPExprVdd )
dbReplaceTermNetExpr( schTermVss NLPExprVss )

dbSetConnCurrent( d_cvId )
schExtractConn( d_cvId )
dbSave( d_cvId )
dbClose( d_cvId )

dbClose( iPinMaster )
dbClose( oPinMaster )
dbClose( ioPinMaster )
) ;procedure

; Update the library list
ddUpdateLibList()

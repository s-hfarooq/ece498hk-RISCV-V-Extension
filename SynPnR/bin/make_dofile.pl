#!/usr/bin/perl

#-------------------------------------------------------------------------------
# make_dofile.pl
#
#   Create dofile based on byte vector file.  Lines beginning with '#' are 
#   comments.  Command vectors are row-based, space delimited (ex.  03 00 ...).
#   Output is "do_file" using the following do files:
#     begin_spi.do, end_spi.do, 00.do, 01.do, 02.do, ...
#-------------------------------------------------------------------------------


#check for one arguments on command line
if ($#ARGV < -1+1 ) {
  print "Usage:  make_dofile.pl <cmd_file>\n";
  exit;
}


#open command file
open(CMD, $ARGV[0]) or
  die("Cannot open $ARGV[0]\n");

#open output file
open(DOFILE, ">$ENV{'DOFILE_DIR'}/dofile.do") or
  die("Cannot open $ENV{'DOFILE_DIR'}/dofile.do file.\n");


#read in command file
my @cmd_lines = <CMD>;
my $size_cmd = @cmd_lines;


#  ignore lines beginning with '#'
my $i = 0;


#write header information to DOFILE
printf DOFILE "do $ENV{'DOFILE_DIR'}/list.do\n";
printf DOFILE "do $ENV{'DOFILE_DIR'}/initial.do\n";
printf DOFILE "\n";


for ( $i=0; $i<$size_cmd; $i++ ) {

  #split line on white space
  @split_cmd = split(' ', $cmd_lines[$i]);
  $size_split_cmd = @split_cmd;

  #continue if first character of first word in not a '#' or is empty
  # test by printing first word of each line
  $first_char = substr($split_cmd[0],0,1);
  if ( ($first_char ne "#") and ($size_split_cmd ne 0) ) {

    if ( $split_cmd[0] ne "initial_time" ) {
      #ready to parse byte vector
      my $j = 0;
      printf DOFILE "do $ENV{'DOFILE_DIR'}/begin_spi.do\n";

      for ( $j=0; $j<$size_split_cmd; $j++ ) {
        #write calls to appropriate dofile bytes
        printf DOFILE "do $ENV{'DOFILE_DIR'}/$split_cmd[$j].do\n";
      }

      printf DOFILE "do $ENV{'DOFILE_DIR'}/end_spi.do\n\n";
    }
  }
}


#write footer information to DOFILE
printf DOFILE "write list %s/%s.list\n", $ENV{'VECTOR_DIR'}, $ENV{'TOP_LEVEL'};
printf DOFILE "quit -f\n";


#close files
close(CMD);
close(DOFILE);

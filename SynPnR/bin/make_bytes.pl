#!/usr/bin/perl

#-------------------------------------------------------------------------------
# make_bytes.pl
#
#   Create dofiles containing serial byte sequences for "mosi" pin (00.do, 
#   01.do, ..., fe.do, ff.do).  Bits are ordered LSB first.
#-------------------------------------------------------------------------------


#clock period in nano seconds
my $period = 100;


#-------------------------------------------------------------------------------
# do not edit
#-------------------------------------------------------------------------------
my $i = 0;

for ( $i=0; $i<256; $i++ ) {
  #generate file name
  $filename = sprintf("%02x.do",$i);

  #open file for writing
  open(FILE, ">$ENV{'DOFILE_DIR'}/$filename") or
    die("Cannot open dofiles/$filename\n");

  #write to file
  $blah = sprintf("run %fns\n", $period/2);
  printf FILE $blah;

  my $j = 0;
  my $bit = 0;
  for ( $j=0; $j<7; $j++ ) {
    $bit = 0;
    if ( ($i & (2 ** $j)) ne 0) {
      $bit = 1;
    }

    #write to file
    $blah = sprintf("force mosi %d\n", $bit);
    printf FILE $blah;
    $blah = sprintf("run %fns\n", $period);
    printf FILE $blah;
  }
  $bit = 0;
  if ( ($i & (2 ** $j)) ne 0) {
    $bit = 1;
  }

  #write to file
  $blah = sprintf("force mosi %d\n", $bit);
  printf FILE $blah;
  $blah = sprintf("run %fns\n", $period/2);
  printf FILE $blah;

  close(FILE);
}


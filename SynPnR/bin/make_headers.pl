#!/usr/bin/perl

#-------------------------------------------------------------------------------
# make_headers.pl
#
#   Create dofiles containing... 
#     list.do       :  Contains list file setup information
#     initial.do    :  Simulation initialization section
#     begin_spi.do  :  Begin SPI transaction
#     end_spi.do    :  End SPI transaction
#-------------------------------------------------------------------------------


#clock period in nano seconds
my $period = 100;


#-------------------------------------------------------------------------------
# do not edit
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# create list.do
#-------------------------------------------------------------------------------
$filename = "$ENV{'DOFILE_DIR'}/list.do";
open(FILE, ">$filename") or 
  die("Cannot open $filename\n");

#write to file
printf FILE "add list -nodelta\n";
printf FILE "configure list -gateexpr {(cs_n == 0) && sck'rising}\n";
printf FILE "configure list -usegating 1\n";
printf FILE "\n";
printf FILE "add list -notrigger -binary -width 10  -label mosi mosi\n";
printf FILE "add list -notrigger -binary -width 10  -label miso miso\n";
printf FILE "\n";
printf FILE "add list -notrigger -binary -width 10  -label mem00 mem00\n";
printf FILE "add list -notrigger -binary -width 10  -label mem01 mem01\n";
printf FILE "add list -notrigger -binary -width 10  -label mem02 mem02\n";
printf FILE "add list -notrigger -binary -width 10  -label mem03 mem03\n";
printf FILE "add list -notrigger -binary -width 10  -label mem04 mem04\n";
printf FILE "add list -notrigger -binary -width 10  -label mem05 mem05\n";
printf FILE "add list -notrigger -binary -width 10  -label mem06 mem06\n";
printf FILE "add list -notrigger -binary -width 10  -label mem07 mem07\n";
printf FILE "add list -notrigger -binary -width 10  -label mem08 mem08\n";
printf FILE "add list -notrigger -binary -width 10  -label mem09 mem09\n";
printf FILE "add list -notrigger -binary -width 10  -label mem10 mem10\n";
printf FILE "add list -notrigger -binary -width 10  -label mem11 mem11\n";
printf FILE "add list -notrigger -binary -width 10  -label mem12 mem12\n";
printf FILE "add list -notrigger -binary -width 10  -label mem13 mem13\n";
printf FILE "add list -notrigger -binary -width 10  -label mem14 mem14\n";
printf FILE "add list -notrigger -binary -width 10  -label mem15 mem15\n";
printf FILE "\n";

close(FILE);


#-------------------------------------------------------------------------------
# create initial.do
#-------------------------------------------------------------------------------
$filename = "$ENV{'DOFILE_DIR'}/initial.do";
open(FILE, ">$filename") or 
  die("Cannot open $filename\n");

#write to file
printf FILE "force reset_n 0\n";
printf FILE "force cs_n 1\n";
printf FILE "force sck 1\n";
printf FILE "force mosi 1\n";
printf FILE "run %fns\n", 4*$period;
printf FILE "force reset_n 1\n";
printf FILE "run %fns\n", 4*$period;
printf FILE "\n";

close(FILE);


#-------------------------------------------------------------------------------
# create begin_spi.do
#-------------------------------------------------------------------------------
$filename = "$ENV{'DOFILE_DIR'}/begin_spi.do";
open(FILE, ">$filename") or 
  die("Cannot open $filename\n");

#write to file
printf FILE "force cs_n 0\n";
printf FILE "run %fns\n", 4*$period;
printf FILE "force sck 1 0ns, 0 %fns -repeat %fns\n", $period/2, $period;
printf FILE "\n";

close(FILE);


#-------------------------------------------------------------------------------
# create end_spi.do
#-------------------------------------------------------------------------------
$filename = "$ENV{'DOFILE_DIR'}/end_spi.do";
open(FILE, ">$filename") or 
  die("Cannot open $filename\n");

#write to file
printf FILE "noforce sck\n";
printf FILE "force sck 1\n";
printf FILE "run %fns\n", $period;
printf FILE "force mosi 1\n";
printf FILE "force cs_n 1\n";
printf FILE "run %fns\n", 4*$period;
printf FILE "\n";

close(FILE);




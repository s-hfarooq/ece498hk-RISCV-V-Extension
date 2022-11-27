#!/usr/bin/perl

#-------------------------------------------------------------------------------
# make_outvectors.pl
#   Create golden output vector based on dofile.
#-------------------------------------------------------------------------------


#period in nano seconds
my $period = 100;


#check for one argument on command line
if ($#ARGV < -1+1) {
  print "Usage:  make_outvectors.pl <do_file>\n";
  exit;
}


#do file
open(DOFILE, $ARGV[0]) or
  die("Cannot open $ARGV[0]\n");

#open golden_vectors file
open(GOLDEN, ">$ENV{'VECTOR_DIR'}/golden_vectors") or
  die("Cannot open $ENV{'VECTOR_DIR'}/golden_vectors file.\n");

#read in do file
my @do_lines = <DOFILE>;
chomp(@do_lines);
my $size_do = @do_lines;


#print header information to golden vectors file
$blah = sprintf(" %10s %10s %10s","ps","mosi","miso");
printf GOLDEN "$blah";
  #print mem[m][n] LSByte/LSbit first
  for ( $m=0; $m<16; $m++ ) {
    $blah = sprintf("      mem%02d", $m);
    printf GOLDEN "$blah";
  }
  #print 20 blank spaces
  for ( $i=0; $i<20; $i++ ) {
    printf GOLDEN " ";
  }
  printf GOLDEN "\n";

     
#define variables to hold time, mosi, miso, smem[], and mem[] values
my $i = 0;
my $time = 0;
my $mosi = 0;
my $miso = 0;
my @smem = ();
my @mem = ();
my $byte_cnt = 0;
my $cmd = "WAIT";  #WAIT, NOP, RDSM, RDM, WRSM, TF, TFA
my $addr = "00";
my $data_in = "00";
my $data_out_ps = "a5";
my $data_out_ns = "a5";
my $num = 0;


for ( $i=0; $i<16; $i++ ) {
  $smem[$i] = "00";
  $mem[$i] = "00";
}


#begin main loop to parse do file
for ( $i=0; $i<$size_do; $i++ ) {

  #parse line into individual words
  @split_do = split(/\s+|\//, $do_lines[$i]);
  $size_split_do = @split_do;

  #continue if more than zero words in line
  if ( ($size_split_do gt 0) &&
       ($split_do[0] eq "do") &&
       ($split_do[$size_split_do-1] ne "list.do") ) {
    
    if ( $split_do[$size_split_do-1] eq "initial.do" ) {
      $time = $time + (4+4)*$period*1000;
    } elsif ( $split_do[$size_split_do-1] eq "begin_spi.do" ) {
      $time = $time + 4*$period*1000;
      $byte_cnt = 0;
      $cmd = "WAIT";
      $addr = "00";
    } elsif ( $split_do[$size_split_do-1] eq "end_spi.do" ) {
      $time = $time + (1+4)*$period*1000;
    } else {
      @split_num = split("\\.",$split_do[$size_split_do-1]);
      $num = hex($split_num[0]);

      #handle first 7 bits, because smem/mem values can change on 8th bit
      $j = 0;
      $data_out_ps = $data_out_ns;
      for ( $j=0; $j<7; $j++ ) {

        #check for command byte
        if ( $byte_cnt eq 0 ) {
          
          #set command byte
          if ( $num eq 0 ) {
            $cmd = "NOP";
            $data_out_ps = "a5";
            $data_out_ns = "5a";
          } elsif ( $num eq 1 ) {
            $cmd = "RDSM";
            $data_out_ps = "a5";
            $data_out_ns = "01";
          } elsif ( $num eq 2 ) {
            $cmd = "RDM";
            $data_out_ps = "a5";
            $data_out_ns = "02";
          } elsif ( $num eq 3 ) {
            $cmd = "WRSM";
            $data_out_ps = "a5";
            $data_out_ns = "03";
          } elsif ( $num eq 4 ) {
            $cmd = "TF";
            $data_out_ps = "a5";
            $data_out_ns = "04";
          } elsif ( $num eq 5 ) {
            $cmd = "TFA";
            $data_out_ps = "a5";
            $data_out_ns = "05";
          } else {
            $cmd = "NOP";
            $data_out_ps = "a5";
            $data_out_ns = "5a";
          }
        } elsif ( $byte_cnt eq 1 ) {
          if ( $cmd eq "NOP" ) {
            $data_out_ns = "5a";
          } elsif ( $cmd eq "RDSM" ) {
            if ( ($num >= 0) and ($num <= 15) ) {
              $addr = sprintf("%02x",$num);
              $data_out_ns = $smem[hex($addr)];
            } else {
              $addr = sprintf("%02x",16);  #address is out of bounds
              $data_out_ns = $smem[0];
            }
          } elsif ( $cmd eq "RDM" ) {
            if ( ($num >= 0 ) and ($num <= 15) ) {
              $addr = sprintf("%02x",$num);
              $data_out_ns = $mem[hex($addr)];
            } else {
              $addr = sprintf("%02x",16);  #address is out of bounds
              $data_out_ns = $mem[0];
            }
          } elsif ( $cmd eq "WRSM" ) {
            if ( ($num >= 0 ) and ($num <= 15) ) {
              $addr = sprintf("%02x",$num);
            } else {
              $addr = sprintf("%02x",16);  #address is out of bounds
            }
            $data_out_ns = "5a";
          } elsif ( $cmd eq "TF" ) {
            if ( ($num >= 0) and ($num <= 15) ) {
              $addr = sprintf("%02x",$num);
            } else {
              $addr = sprintf("%02x",16);  #address is out of bounds
            }
            $data_out_ns = "5a";
          } elsif ( $cmd eq "TFA" ) {
            $data_out_ns = "5a";
          }
        } elsif ( $byte_cnt > 1 ) {
          $data_in = sprintf("%02x",$num);

          if ( $cmd eq "NOP" ) {
            $data_out_ns = "5a";
          } elsif ( $cmd eq "RDSM" ) {
            if ( (hex($addr)+$byte_cnt-1) > 15 ) {  #addr is out of bounds
              $data_out_ns = $smem[0];
            } else {
              $data_out_ns = $smem[hex($addr)+$byte_cnt-1];
            }
          } elsif ( $cmd eq "RDM" ) {
            if ( (hex($addr)+$byte_cnt-1) > 15 ) {  #addr is out of bounds
              $data_out_ns = $mem[0];
            } else {
              $data_out_ns = $mem[hex($addr)+$byte_cnt-1];
            }
          } elsif ( $cmd eq "WRSM" ) {
            $data_out_ns = "5a";
          } elsif ( $cmd eq "TF" ) {
            $data_out_ns = "5a";
          } elsif ( $cmd eq "TFA" ) {
            $data_out_ns = "5a";
          } 
        }


        #set mosi bit value
        $mosi = 0;
        if ( ($num & (2 ** $j)) ne 0) {
          $mosi = 1;
        }

        #set miso bit value
        $miso = 0;
        if ( (hex($data_out_ps) & (2 ** $j)) ne 0) {
          $miso = 1;
        }


        #print value to golden vector file
        $time = $time + 1*$period*1000;
        $blah = sprintf(" %10s %10s %10s",$time,$mosi,$miso);
        printf GOLDEN "$blah";

        #print mem[m][n] LSByte/LSbit first
        for ( $m=0; $m<16; $m++ ) {
          $blah = sprintf("   %08b", hex($mem[$m]));
          printf GOLDEN "$blah";
        }
        printf GOLDEN " \n";
      }
      #handle 8th bit, writes and transfers occur here


      #set mosi bit value
      $mosi = 0;
      if ( ($num & (2 ** $j)) ne 0) {
        $mosi = 1;
      }

      #set miso bit value
      $miso = 0;
      if ( (hex($data_out_ps) & (2 ** $j)) ne 0) {
        $miso = 1;
      }

      #print values to file
      $time = $time + 1*$period*1000;
      $blah = sprintf(" %10s %10s %10s",$time,$mosi,$miso);
      printf GOLDEN "$blah";

      #print mem[m][n] LSByte/LSbit first
      for ( $m=0; $m<16; $m++ ) {
        $blah = sprintf("   %08b", hex($mem[$m]));
        printf GOLDEN "$blah";
      }
      printf GOLDEN " \n";

      #update smem and mem arrays
      if ( ($byte_cnt eq 1) && ($cmd eq "TFA") ) {
        $k = 0;
        for ( $k=0; $k<16; $k++ ) {
          $mem[$k] = $smem[$k];
        }
      } elsif ( ($byte_cnt > 1) && ($cmd eq "WRSM") ) {
        if ( (hex($addr)+$byte_cnt-2) <= 15 ) {  #address is valid
          $smem[hex($addr)+$byte_cnt-2] = $data_in;
        }
      } elsif ( ($byte_cnt eq 2) && ($cmd eq "TF") ) {
        if ( hex($addr) <= 15 ) {  #address is valid
          $mem[hex($addr)] = $smem[hex($addr)];
        }
      } elsif ( ($byte_cnt > 1) && ($cmd eq "RDSM") ) {
      } elsif ( ($byte_cnt > 1) && ($cmd eq "RDM") ) {
      }



      #increment values
      $byte_cnt++;
    }
  }
}


close(DOFILE);
close(GOLDEN);

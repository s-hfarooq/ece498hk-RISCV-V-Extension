#!/usr/bin/perl

$cpitch = 2.52;
$tpitch = 0.28;

$x = 102.8;
$y = 15-0.14;

$i = 0.0;
$j = 0.0;


for ( $i=0; $i<16; $i++ ) {
  for ( $j=0; $j<8; $j++ ) {
    $y = $y + (3 - 0*($j % 2))*$tpitch;
    if ( ($j ne 0) && (($j % 2) eq 0)) {
      $y = $y + 3*$tpitch;
    }
    printf "editPin -snap TRACK -side INSIDE -layer 3 -assign %6.2f ", $x;
    printf "%6.2f -pin mem%02d\\[%d\\]\n", $y, $i, $j;
  }
  $y = $y + 3*$tpitch;
}


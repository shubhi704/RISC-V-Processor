 unless (open(OUTFILE, ">input.txt")) {
 die ("Output file outfile cannot be opened.\n");
 }
 unless (open(INFILE, "d.txt")) {
 die ("Input file INFILE cannot be opened.\n");
 }  
#  unless (open(FILE2, "deci.txt")) {
#  die ("Input file INFILE cannot be opened.\n");
#  }  
      $num1 = 0x2b;
      $num  = <INFILE>;
      chop($num);
      chop($num);
      for ($count=1; $count <= 64; $count++) {
      $sum  = $num + $num1;
      $nu = sprintf("%x",$num);
      $outstr = sprintf("%x",$sum);
      $numx = sprintf("%x",$num1);
    #  print OUTFILE ($nu,"_",$numx,"_",$outstr);
      print OUTFILE ($nu);
      print OUTFILE ("\n");
      $num = <INFILE>;
      chop($num);
      chop($num);
      # $num1 = <FILE2>;
}


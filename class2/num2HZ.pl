while(1){
	print "please num:(0 to exit)";
	$input = <stdin>;
	chomp($input);
	if($input == 0){
		last;
	}
	if($input>=3750){
		$input += 5;
	}
	$i = $input/94;
	$j = $input%94;
	$result = pack("C*",$i+0xb0,$j+0xa0);
	
	print "HZ is. $result\n";
}
while(1){
	print "please HANZI:(q to exit)";
	$input = <stdin>;
	chomp($input);
	if($input eq "q"){
		last;
	}
	@Array = unpack("C*",$input);
	
	
	
	$n = ($Array[0]-0xb0)*94+$Array[1]-0xa0;
	if($n>=3750){
		$n= $n-5;
	} 
	print "NO. $n\n";
}
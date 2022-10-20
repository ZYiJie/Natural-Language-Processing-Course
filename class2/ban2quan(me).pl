open(FN,"ban.txt");
open(FO,">quan3.txt");
while(<FN>){
	
	$ret = Convert($_);
	print FO "$ret\n";
}
close(FN);
close(FO);


sub Convert{
	my($Line) = @_;
	my $result = " ";
	while(length($Line)>0){
		$len = 1;
		if((ord($Line)&0x80)!=0){
			$len = 2;
			print $Char;
			$Char = substr($Line,0,$len);
			$result .= $Char;
		}else{
			$Char = substr($Line,0,$len);
			
			$result .= Ban2Quan($Char);
		}
		$Line = substr($Line,$len,length($Line)-$len);
	}
	
	return $result;
}

sub Ban2Quan{
	my($Char2) = @_;
	$ret2 = pack("C2",0xa3,ord($Char2)+0xd0-0x50);
	
	return $ret2;
}
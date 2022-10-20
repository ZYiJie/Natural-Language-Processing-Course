use Encode;
use utf8;
Main("abc大家辛苦了！");

sub Main
{
	my($HZS)=@_;
	open (DAT, "hzk.dat");
	binmode (DAT, ":raw");
	GetHZs($HZS,DAT,\@HZArray);
	close(DAT);
	while(1){
		for ($i=0;$i<@{$HZArray[0]};$i++){
			sleep(1);
			system("cls");
			ShowHZS(\@HZArray,$i);
		}
	}
}

sub RetHZOffset
{
	my($HZ)=@_;
	my @HZs=unpack("C*",$HZ);
	$HZOffset=32*(($HZs[0]-0xa1)*94+($HZs[1]-0xa1));
	return $HZOffset;
}

sub GetHZ
{
	my($HZ,$Handle,$RefHZ)=@_;
	$Offset=RetHZOffset($HZ);
	seek($Handle,$Offset,0);
	read($Handle,$Dot,32);
	@DotInfo=unpack("C*",$Dot);

	for( $i=0;$i<16;$i++ ){
		my @Line=();

		for($j=0;$j<8;$j++){
			if ( ( (0x80>>$j) & $DotInfo[2*$i] ) != 0 ){
				push(@Line,"*");
			}else{
				push(@Line," ");
			}
	  }

		for($j=0;$j<8;$j++){
			if ( ( (0x80>>$j) & $DotInfo[2*$i+1] ) != 0 ){
				push(@Line,"*");
			}else{
				push(@Line," ");
			}
	  }
		push(@{$RefHZ},\@Line);
	}
}

sub GetHZs
{
	my($HZS,$Handle,$RefHZS)=@_;
	@AllHZ=$HZS=~/./g;
	@Sep=(" "," ");
	foreach (@AllHZ){
		$GB=encode("gbk",$_);
		$Quan=Banjiao2Quanjiao($GB);
		@HZInfo=();
		GetHZ($Quan,$Handle,\@HZInfo);
		my $i;
		for($i=0;$i<@HZInfo;$i++){
				push(@{${$RefHZS}[$i]},@Sep);
				push(@{${$RefHZS}[$i]},@{$HZInfo[$i]});
		}
	}		
}

sub ShowHZS
{
	my($RefHZS,$No)=@_;
	my $i;
	for($i=0;$i<@{$RefHZS};$i++){
		for($j=$No;$j<@{${$RefHZS}[$i]};$j++){
			print "${${$RefHZS}[$i]}[$j]";						
		}

		for($j=0;$j<$No;$j++){
			print "${${$RefHZS}[$i]}[$j]";			
		}
		print "\n";		
	}		
}

sub Banjiao2Quanjiao
{
	my($Char)=@_;
	$Char_quan=$Char;
	if ( ord($Char) & 0x80 ){
		return $Char_quan;
	}elsif ( ord($Char) > 0x20 ){
		if ( $Char eq "\$" ){
			$Char_quan="＄";
		}elsif ( ord($Char) == 127 ){
			$Char_quan="";
		}else{
			$Char_quan=pack("C*",0xa3,0x80+ord($Char));
		}
	}elsif ( ord($Char) == 0x20 ){
		$Char_quan=pack("C*",0xa1,0xa1);
	}else{
		$Char_quan="";
	}
	return $Char_quan;
}

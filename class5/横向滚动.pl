use Encode;
print "Pls: ";
$String = <stdin>;
chomp($String);
print $String;
Show($String);

sub Show{
	my($String)=@_;
	my @HZs = ();
	my @Final = ();
	Split($String,\@HZs);
	foreach $HZ(@HZs){
		my @HZZX = ();#汉字字形
		GetHZ($HZ,\@HZZX);
		Add2Final(\@HZZX,\@Final);
	}
	ShowFinal(\@Final);
}
sub Split{
	my($String,$RefHZs) = @_;
	$utf8 = decode("gbk",$String);
	@Array = $utf8=~/./g;
	foreach (@Array){
		$Quan = ToQuan($_);
		push(@{$RefHZs},$Quan);
	}
}

sub ToQuan{
	my($HZ)=@_;
	$GB = encode("gbk",$HZ);
	if((ord($GB)&0x80)!=0){#是全角
		print "there is a quan\n";
		return $GB;
	}else{
		print "there is a ban\n";
		if($GB eq ' '){
			$Q = pack("C2",0xa1,0xa1);
		}elsif($GB eq '$'){
			$Q = pack("C2",0xa1,0xe7);
		}else{
			$Q = pack("C2",0xa3,0x80+ord($GB));
		}
		return $Q;
	}
}

sub GetHZ{
	my($HZ,$RefHZZX) = @_;
	$offset = Getoffset($HZ);
	open(Dat,"hzk.dat");
	binmode(Dat,":raw");
	seek(Dat,$offset,0);#定位
	read(Dat,$Str,32);
	@Array = unpack("C*",$Str);####加入unpack
	close(Dat);
	for($i=0;$i<16;$i++){
		my @Line = ();
		for($j=0;$j<8;$j++){
			if((($Array[2*$i]<<$j)&0x80)==0){
				push(@Line," ");
			}else{
				push(@Line,"*");
			}
		}
		for($j=0;$j<8;$j++){
			if((($Array[2*$i+1]<<$j)&0x80)==0){
				push(@Line," ");
			}else{
				push(@Line,"*");
			}
		}
		push(@{$RefHZZX},\@Line);
	}
}

sub Getoffset{
	my($HZ)=@_;
	my @Array = ();
	@Array = unpack("C2",$HZ);
	return ((@Array[0]-0xa1)*94+@Array[1]-0xa1)*32;###32*()
}

sub Add2Final{
	my($RefHZZX,$RefFinal) = @_;
	@Sep = (" "," "," ");
	for($i=0;$i<16;$i++){
		push(@{${$RefFinal}[$i]},@Sep);
		push(@{${$RefFinal}[$i]},@{${$RefHZZX}[$i]});
	}
}

sub ShowFinal{
	my($RefFinal) = @_;
	
	#getc;
	system("cls");#调用dos
	
	$Time = 0;
	while(1){
		sleep(1);
		system("cls");
		
		$No = $Time%@{$RefFinal};
		for($i=0;$i<16;$i++){
			for($j=$No;$j<@{${$RefFinal}[$i]};$j++){
				print "${${$RefFinal}[$i]}[$j]";
			}
			for($j=0;$j<$No;$j++){
				print "${${$RefFinal}[$i]}[$j]";
			}
			print "\n";
		}

		$Time++;
		#last;################
	}
}







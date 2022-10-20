$HZ="Äã";
open(Font,"hzk.dat");
binmode(Font,":raw");
$Offset=GetOffset($HZ);
seek(Font,$Offset,0);
read(Font,$xing,32);
@ZX=unpack("C*",$xing);
Show(\@ZX);
close(Font);


sub GetOffset
{
	my($HZ)=@_;
	my @HZs=unpack("C*",$HZ);
	my $Offset=32*(($HZs[0]-0xa1)*94+($HZs[1]-0xa1));
	return $Offset;
}

sub Show
{
	my($Ref)=@_;
	my $i;
	for($i=0;$i<16;$i++){
		ShowIt(${$Ref}[2*$i]);
		ShowIt(${$Ref}[2*$i+1]);
		print "\n";
	}
}



sub ShowIt
{
	my($Num)=@_;
	my $i;
	for($i=0;$i<8;$i++){
		if ( (($Num<<$i)&0x80) == 0 ){
			print " ";
		}else{
			print "*";
		}
	}
}
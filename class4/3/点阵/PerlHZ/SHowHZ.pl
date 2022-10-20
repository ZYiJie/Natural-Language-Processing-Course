$HZ="Œ“";
open (DAT, "<hzk.dat");
binmode (DAT, ":raw");
$Offset=RetHZOffset($HZ);
seek(DAT,$Offset,0);
read(DAT,$Dot,32);
@DotInfo=unpack("C*",$Dot);
for( $i=0;$i<32;$i++ ){
for($j=0;$j<8;$j++){
	if ( ( (0x80>>$j) & $DotInfo[$i] ) != 0 ){
		printf("*");
	}else{
		printf(" ");
	}
	}
	if(	1==$i%2 ){
		printf("\n");
	}
}
close(DAT);


sub RetHZOffset
{
	my($HZ)=@_;
	my @HZs=unpack("C*",$HZ);
	$HZOffset=32*(($HZs[0]-0xa0-1)*94+($HZs[1]-0xa0-1));
	return $HZOffset;
}

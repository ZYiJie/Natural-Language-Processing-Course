use Encode;

open(FN,"ban.txt");
open(FO,">quan.txt");
while(<FN>){
	chomp;
	$Utf8=decode("gbk",$_);
	@HZ=$Utf8=~/./g;
	foreach (@HZ){
		$GB=encode("gbk",$_);
		$Quan=Banjiao2Quanjiao($GB);
		print FO "$Quan";
	}
	print FO "\n";
}
close(FN);
close(FO);


sub Banjiao2Quanjiao
{
	my($Char)=@_;
	$Char_quan=$Char;
	if ( ord($Char) & 0x80 ){
		return $Char_quan;
	}elsif ( ord($Char) > 0x20 ){
		if ( $Char eq "\$" ){
			$Char_quan="ก็";
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


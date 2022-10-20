#文件采用ANSI编码
Readin("lm.dic",\%Hash,\%$MaxLen);
open(in,"train.txt");
$temp = 0;


while(<in>){
	chomp;
	@sep_line = split(" ",Segment($_,\%Hash,\%MaxLen));
	#print "@sep_line\n";
	if($temp%1000==0){
		print "$temp\n";
	}
	$temp++;
	foreach (@sep_line){
		#print "$_\n";
		$result{$_}++;
	}
	
}
close(in);

open(out,">cipin.txt");
foreach (sort { $result{$b} <=> $result{$a} } keys %result){
	print out "$_ $result{$_}\n";
}
close(out);

sub Readin{
	my($Dic,$RefHash,$refMaxLen) = @_;
	open(In,$Dic);
	$refMaxLen = 0;
	while(<In>){
		chomp;
		#print "$_\n";
		if(/#(.*)/){
			${$RefHash}{$1} = 1;
			if(length($1)>$refMaxLen){
				$refMaxLen = length($1);
			}
		}
	}
	close(In);
}

sub Segment{
	$Seg = "";
	my($Sent,$RefHash,$refMaxLen) = @_;
	while(length($Sent)>0){
		$MaxLen = $refMaxLen;
		if(length($Sent)<$MaxLen){ #比较输入字符串和理论最大长度
			$MaxLen = length($Sent);
		}
		for($Len=$MaxLen;$Len>0;$Len--){
			$ToLook = substr($Sent,0,$Len);
			if(defined ${$RefHash}{$ToLook}){
				last;
			}
		}
		if($Len == 0){
			$Len = 1;
			if((ord($Sent)&0x80) != 0){
				$Len = 2;
				}
		}
		$Word = substr($Sent,0,$Len);
		$Seg .= $Word." ";
		$Sent = substr($Sent,$Len,length($Sent)-$Len);
	}	
	return $Seg;
}





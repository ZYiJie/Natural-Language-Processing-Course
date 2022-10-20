Readin("lm.dic",\%Hash,\$MaxLen);


open(In,"train.txt");
open(Out,">change.txt");
$j=0;
while(<In>)
{
	chomp;
	$Ret=Segment($_,\%Hash,\$MaxLen);
	print Out "$Ret\n";
	if($j%1000==0)
	{
	print"$j\n";
	}
	$j++;
}
close(In);
close(Out);

sub Readin
{
	my($Dic,$RefHash,$refMaxLen)=@_;
	open(In,$Dic);
	while(<In>)
	{
		chomp;
		if(/#(.*)/)
		{
			${$RefHash}{$1}=1;
			if(length($1)>${$refMaxLen})
			{
				${$refMaxLen}=length($1);
			}
		}
	}
	close(In);
}

sub Segment
{
	my($Sent,$RefHash,$refMaxLen)=@_;
	my $Seg="";
	while(length($Sent)>0)
	{
		my $MaxLen=${$refMaxLen};
		if(length($Sent)<$MaxLen)
		{
			$MaxLen=length($Sent);
		}
		for($Len=$MaxLen;$Len>0;$Len--)
		{
			$TOLook=substr($Sent,0,$Len);
			if(defined ${$RefHash}{$TOLook})
			{
				last;
			}
		}
		if($Len==0)
		{
			$Len=1;
			if(ord($Sent)&0x80 != 0)
			{
				$Len=2;
			}
		}
		$Word=substr($Sent,0,$Len);
		$Seg.=$Word."\/";
		$Sent=substr($Sent,$Len,length($Sent)-$Len);
	}
	return $Seg;
}
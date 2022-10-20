use Encode;

open(IN,"train.001");
while(<IN>){
	chomp;
	
	SplitLine($_,\@HZ);
	for($i=0;$i<@HZ;$i++){
		$Hash_Uni{$HZ[$i]}++;
		if( $i>0 ){
			$Hash_Bi{$HZ[$i-1]."_".$HZ[$i]}++;
		}
		$Total++;
	}
}
close(IN);

foreach (sort keys %Hash_Uni){
	$Unigram=log($Hash_Uni{$_}/$Total);
	$GB=encode("gbk",$_);
	print "B_$GB $Unigram\n";
}

foreach $Bi(sort keys %Hash_Bi){
	if($Bi=~/(\S+)_\S+/){
		$Bigram=log($Hash_Bi{$Bi}/$Hash_Uni{$1});
		$GB=encode("gbk",$Bi);
		print "$GB $Bigram\n";
	}
}


sub SplitLine
{
	my($Line,$Ref)=@_;
	@{$Ref}=();
	$Utf8=decode("gbk",$Line);
	@{$Ref}=$Utf8 =~/./g;
}


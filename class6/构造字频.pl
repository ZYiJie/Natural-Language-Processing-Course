use Encode;
open(In,"PINYIN.txt");
while(<In>){
	chomp;
	~s/\d//g;
	#print "$_\n";
	@Array=/\S+/g;
	for($i=1;$i<@Array;$i++){
		push(@{$Hash_P2H{$Array[$i]}},$Array[0]);
	}
}
close(In);

open(In,"train.txt");
while(<In>){#构造文本词频表
	chomp;
	$Utf8 = decode("gbk",$_);
	@HZs=$Utf8=~/./g;
	foreach( @HZs){
		$GB = encode("gbk",$_);
		#print "$GB";
		$Hash{$GB}++;
	}
}
close(In);


foreach $PY(sort keys %Hash_P2H){
	print "$PY ";
	$temp;
	foreach (sort{$Hash{$b}<=>$Hash{$a}} @{$Hash_P2H{$PY}}){#将拼音对应的汉字按字频排序后遍历
		if(!($_ eq $temp)){
			print "$_ ";
		}
		$temp = $_;
	}
	print "\n";
}
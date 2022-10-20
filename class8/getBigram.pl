#文件采用ANSI编码
use Encode;
open(In,"train.txt");
$count = 0;

while(<In>){#构造文本词频表
	chomp;
	#print "$_\n";
	if($count%2000==0){
		print "$count\n";
	}
	$count++;
	$Utf8 = decode("gbk",$_);
	@HZs=$Utf8=~/./g;
	@Shuangs=$Utf8=~/../g;
	foreach( @HZs){
		$numHZ++;
		$GB = encode("gbk",$_);
		#print "$GB";
		$Hash_zi{$GB}++;
	}
	foreach( @Shuangs){
		$numShuang++;
		$GB = encode("gbk",$_);
		#print "$GB\n";
		$Hash_shuang{$GB}++;
	}
}
close(In);

open(out,'>2-gram_1.txt');
foreach (sort { $Hash_zi{$b} <=> $Hash_zi{$a} }keys %Hash_zi){
	$i = log($Hash_zi{$_}/$numHZ);
	print out"$_ $i\n";
}
close(out);
open(out2,'>2-gram_2.txt');
foreach (sort { $Hash_shuang{$b} <=> $Hash_shuang{$a} }keys %Hash_shuang){
	$i = log($Hash_shuang{$_}/$numShuang);
	print out2"$_ $i\n";
}
close(out2);
print "$numHZ $numShuang";
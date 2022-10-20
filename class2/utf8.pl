#要把代码保存为UTF8格式
use Encode;
use utf8;
open(FN,"gb.txt");
open(FO,">sentences.txt");
while(<FN>){
	chomp;
	$Utf8=decode("gb2312",$_);
	$Utf8=~s/([, ，。！？])/$1\n/g;
	$GB=encode("gb2312",$Utf8);
	print FO "$GB";
	
	@HZ=$Utf8=~/./g;
	foreach (@HZ){
		$HashFreq{$_}++;
	}
}
close(FN);
close(FO);

open(FF,">HZFreq.txt");
foreach (sort{$HashFreq{$b}<=>$HashFreq{$a}} keys %HashFreq){
	$GB=encode("gb2312",$_);
	print FF "$GB $HashFreq{$_}\n";
}
close(FF);


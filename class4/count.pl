use Encode;
open(in,"corpus.txt");
while(<in>){
	chomp;
	$utf8Line = decode("gbk",$_);
	@char = $utf8Line=~/./g;
	foreach (@char){
		$hash{$_}++;
	}
}
close(in);

foreach(sort{$hash{$b}<=>$hash{$a}} keys %hash){
	$temp = $_;	
	$gb = encode("gbk",$_);
	print "$gb $hash{$temp}\n";
}
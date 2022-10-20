use Encode;
open(In,"data.txt");
while(<In>){
    chomp;
	$Utf8=decode("gbk",$_);
	@Chars=$Utf8=~/./g;
	foreach(@Chars){
	    $Hash{$_}++;
	}
}
close(In);
foreach(sort{$Hash{$b}<=>$Hash{$a}}keys%Hash){
    $Char=$_;
	$GB=encode("gbk",$_);
	print "$GB $Hash{$Char}\n";
}
use Encode;
use utf8;
open(in,"data.txt");
while(<in>){
	chomp;
	#print $i++;
	$utf8Line = decode("gbk",$_);
	$utf8Line=~s/([。！，])/$1\n/g;
	$gb = encode("gbk",$utf8Line);
	print $gb;
}
close(in);

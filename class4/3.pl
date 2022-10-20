use Encode;
use utf8;
$HZ="¹þ¹þ";
$HZ = decode("gbk",$HZ);

@hzs=$HZ=~/./g;
for($i=0;$)

for($i=0;$i<@hzs;$i++){
	open(Font,"hzk.dat");
	binmode(Font,":raw");
	$offset=GetOffset($HZ);
	seek(Font,$offset,0);
	read(Font,$xing[$i],32);
}
$j = 0;
for($i=0;$i<16;$i++){
	foreach $x(@xing){
	@ZX=unpack("C*",$x);
	$result[$j++]=$ZX[2*$i];
	$result[$j++]=$ZX[2*$i];
	}
}

Show(\@result);
close(Font);

sub GetOffset
{
    my($HZ)=@_;
	my @HZs=unpack("C*",$HZ);
	my $offset=32*(($HZs[0]-0xa1)*94+($HZs[1]-0xa1));
	return $offset;
}

sub Show
{
    my($Ref)=@_;
	my $i;
	for($i=0;$i<32;$i++){
	    ShowIt(${$Ref}[2*$i]);
		ShowIt(${$Ref}[2*$i+1]);
		print "\n";
	}
}

sub ShowIt
{
    my($Num)=@_;
	my $i;
	for($i=0;$i<8;$i++){
	    if((($Num<<$i)&0x80)==0){
		   print " ";
		}
		else{
		   print "*";
		}
	}
}

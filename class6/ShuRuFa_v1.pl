open(In,"P2H.txt");
while(<In>){
	chomp;
	@Array=$_=~/\S+/g;
	for($i=1;$i<@Array;$i++){
		#print "$Array[1]\n";
		push(@{$Hash_P2H{$Array[0]}},$Array[$i]);
	}
}
close(In);

system("cls");
print "Pls: ";
while(1){
	$input = <stdin>;
	chomp $input;
	$i = 1;
	foreach(@{$Hash_P2H{$input}}){
		print "$i.$_ ";
		$i++;
		if($i==11){
			last;
		}
	}
	print "\n";
	$n = <stdin>;
	chomp;
	system("cls");
	push(@result,@{$Hash_P2H{$input}}[$n-1]);
	foreach (@result){
		print "$_";
	}
}




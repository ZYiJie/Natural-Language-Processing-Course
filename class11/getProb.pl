open(in,"pos.out");
while(<in>){
	chomp;
	@W=/(\S+)\/\S+/g;
	@T=/\S+\/(\S+)/g;
	for($i=0; $i<@T; $i++){
		$Hash_T{$T[$i]}++;
		if($i>0){
			$Hash_2T{$T[$i-1]."_".$T[$i]}++;
		}
		${$Hash_WT{$W[$i]}}{$T[$i]}++;#{汉字->词性}->数目
	}
}
close(in);

open(out1,">T2Prob.txt");
foreach $T2(sort keys %Hash_2T){
	if($T2=~/\S+_(\S+)/){
		$P = log($Hash_2T{$T2}/$Hash_T{$1});
		print out1 "$T2 $P\n";
	}
}
close(out1);

open(out2,">WTProb.txt");
foreach $W(sort keys %Hash_WT){
	foreach $T(sort keys %{$Hash_WT{$W}}){
		$P = log(${$Hash_WT{$W}}{$T}/$Hash_T{$T});
		print out2 "$W $T $P\n";
	}
}
close(out2);









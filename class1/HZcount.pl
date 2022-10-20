open(in,"6.out");
while(<in>){
	chomp();
	Sep($_);
}
close(in);
foreach(sort keys @hash){
	print "$_ $hash{$_}\n";
}

sub Sep{
	my($line) = @_;
	while(length($line)>0){
		$len = 1;
		if((ord($line)&0x80)!=0){$len = 2;}
		$hash{substr($line,0,$len)}++;
		$line = substr($line,$len,length($line)-$len);
	}
}
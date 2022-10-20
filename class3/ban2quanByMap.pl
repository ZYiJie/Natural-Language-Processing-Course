load("ban2quanMap.txt",\%map);

open(in2,"ban.txt");
open(out,"1.txt");
while(<in2>){
	chomp;
	$result = ban2quan($_,\%map);
	#print  "$result\n";
	print out "$result\n";
}
close (in2);
close (out);


sub load{
	my($path,$map)=@_;
	open(in,"$path");
	while(<in>){
		chomp;
		if( $_ =~/(\S+)\s+(\S+)/){
		$map{$1} = $2;}
	}
	close in;
}

sub ban2quan{
	my($line,$map) = @_;
	@arr = $line =~/./g;
	$ret = "";
	foreach $e(sort keys %map){
	print "$e  ${$map}{$e}\n";
	}
	print "\n";
	foreach $x(@arr){
		print "$map{$x}";
		if(defined ${$map}{$x}){
			$ret .= ${$map}{$x};
			print "1";
		}else{
			$ret .= $_;
		}
		
	}
	#print "$ret\n";
	return $ret;
}
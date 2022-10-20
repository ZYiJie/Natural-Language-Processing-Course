main();
sub main{
	InitBigram("2-gram_2.txt",\%g_Bigram);
	InitDict("invert.txt");
	while(1){
		$Py=<stdin>;
		chomp($Py);
		$Ret = IME($Py);
		print "$Ret\n";
	}
}

sub InitDict
{
	my($Dict)=@_;
	open(In,"$Dict");
	while(<In>){
		chomp;
		my @HZ=();
		@HZ=/\S+/g;
		$PY = shift(@HZ);
		#print "$PY\n";
		@{$g_Py2HZ{$PY}} = @HZ; #此处创建了拼音对应汉字数组的哈希
	}
	close(In);
	# foreach $i( sort keys %RefHash){
		# print "$i: ";
		# foreach $e(@{$RefHash{$i}}){
			# print "$e ";
		# }
		# print "\n";
	# }
	# print "1";
}

sub InitBigram
{
	my($Prob,$RefHash)=@_;
	open(In,"$Prob");
	while(<In>){
		chomp;
		my @HZ=();
		($Bi,$P)=/\S+/g;
		#print "$Bi,$P\n";
		${$RefHash}{$Bi} = $P;
	}
	close(In);
}


sub IME
{
	my($PY)=@_;
	BuildLattice($PY,\@Lattice);
	# $temp = $Lattice[3][1][0];
	# $temp1 = $Lattice[3][0][1];
	# $temp2 = $Lattice[3][0][2];
	# print("##$temp $temp1 $temp2\n");
	ComputeLattice(\@Lattice);
	$Ret=BackWard(\@Lattice);
	return $Ret;	
}

sub BuildLattice
{
	my($PY,$RefLattice)=@_;
	@PYs=split(" ",$PY);
	push(@PYs,"E");
	unshift(@PYs,"B");
	foreach (@PYs){
		my @Column=();
		GetCandidate($_);#内部生成了一个汉字数组	
		foreach (@HZs){
			my @Unit=();
			push(@Unit,$_);
			push(@Unit,0);
			push(@Unit,0);
			push(@Column,\@Unit);
			#################
			# foreach (@Unit){
				# print "$_ ";
			# }
			# print "\n";
		}
		push(@{$RefLattice},\@Column);	
	}
}

sub GetCandidate
{
	my($PY)=@_;
	@HZs = ();
	if ( defined $g_Py2HZ{$PY} ){
		@HZs=@{$g_Py2HZ{$PY}};
	}
	# foreach (@{$RefHZs}){
		# print "$_ ";
	# }
	# print "\n";
}

sub ComputeLattice
{
	my($RefLattice)=@_;
	for($i=0;$i<@{$RefLattice};$i++){
		print "$i\n";
		$temp = $$RefLattice[$i][0][2];
		print("$temp\n");
		if( $$RefLattice[$i][0][0] == 'H' ){
			next;
		}
		foreach $RefHZ(@{${$RefLattice}[$i]}){ #此处的$RefHZ应该是一个引用类型
			print "$$RefHZ[0]";
			GetMaxProb($RefHZ,${$RefLattice}[$i-1],\$Val,\$RefPrevHZ);
			${$RefHZ}[1]=$Val;
			${$RefHZ}[2]=$RefPrevHZ;
		}
	}
}

sub GetMaxProb
{
	my($RefHZ,$refColumn,$refVal,$RefPrevHZ)=@_; 
	$MaxProb=-100000.0;
	for $RefPrevHZ(@{$refColumn}){
		$Prob=${$RefPrevHZ}[1]+GetBigram(${$RefPrevHZ}[0],${$RefHZ}[0]);
		if( $Prob > $MaxProb){
			$MaxProb=$Prob;
			$MaxRef=$RefPrevHZ;
		}
	}
	$refVal=$MaxProb;
	$RefPrevHZ=$MaxRef;
}

sub GetBigram
{
	my($HZ1,$HZ2)=@_;
	my $Prob = 0;
	if(defined $g_Bigram{$HZ1.$HZ2}){
		$Prob = $g_Bigram{$HZ1.$HZ2};
	}
	return $Prob;
}


sub BackWard
{
	my($RefLattice)=@_;
	$Ref=${$RefLattice[@{$RefLattice}-1][0]}[2];
	my @Ret=();
	while($Ref != 0 ){
		unshift(@Ret,${$Ref}[0]);	
		$Ref=${$Ref}[2];
	}
	$IME=join("",@Ret);
	return $IME;
}


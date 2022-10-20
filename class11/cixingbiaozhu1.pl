main();
sub main
{
	while(1){
		print"Pls:\n";
		$Sent=<stdin>;
		chomp($Sent);
		$Pos=Tagger($Sent);
		print"$Pos\n";
	}
}

sub Tagger
{
	my($Sent)=@_;
	my @Lattice;
	BuildLattice($Sent,\@Lattice);		#建网格
	ComputeLattice(\@Lattice);			#计算网格，算value，point
	$Ret=BackWard(\@Lattice);			#回退，得到结果
	return $Ret;
}

sub BuildLattice
{
	my($Sent,$RefLattice)=@_;
	@W=$Sent=~/\S+/g;
	unshift(@W,"^BEGIN");
	push(@W,"$END");
	
	foreach $Word(@W){
		my @T=();
		GetWordPos($Word,\@T);
		my @Column=();
		foreach $POS(@T){					
			my @Unit=();
			push(@Unit,$POS);
			push(@Unit,$Word);
			push(@Unit,0);			
			push(@Unit,0);
			push(@Column,\@Unit);		
		}
		push(@{$RefLattice},\@Column);
	}
}

sub ComputeLattice
{
	my($RefLattice)=@_;
	for($i=1;$i<@{$RefLattice};$i++){
		foreach $Unit(@{${$RefLattice}{$i}}){
			GetBest($Unit,${$RefLattice}[$i-1],\$Val,\$PrevUnit);
			$Unit[2]=$Val;
			$Unit[3]=$PrevUnit;
		}
	}
}

sub GetBest
{
	my($Unit,$PrevColumn,$ValRef,$PrevUnitRef)=@_;
	$Max=-10000000;
	foreach $PrevUnit(@{$PrevColumn}){
		$Val=${$PrevUnit}[1]+GetBigram(${$PrevUnit}[0],${$Unit}[0])+GetLex(${$Unit}[1],${$Unit}[0]);
		if( $Val > $Max){
			$Max=$Val;				#最大概率
			$MaxRef=$PrevUnit;			#指向。。
		}
	}
	${$ValRef}=$Max;
	$PrevUnitRef=$MaxRef;
}

sub BackWard
{
	my($RefLattice)=@_;
	$UnitRef=${${${$RefLattice}[@{$RefLattice}-1]}[0]}[3];
	my @FinalPOS=();
	my @FinalWord=();
	while($UnitRef != 0 ){
		unshift(@FinalPOS,${$UnitRef}[0]);	
		unshift(@FinalWord,${$UnitRef}[1]);
		$UnitRef=${$UnitRef}[3];
	}
	my $i;
	my $Ref;
	for($i=0;$i<@FinalPOS;$i++){
		$Ref.=$FinalWord[$i]."\/".$FinalPOS[$i]." ";
	}
	return $Ref;
}


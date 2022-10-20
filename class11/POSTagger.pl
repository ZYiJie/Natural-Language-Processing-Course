print "Reading data...\n";
if ( ReadProb("Lex.prob","Trans.prob") == -1 ){
	return;
}

while(1){
	print "Pls input sentence(press q to exit!):\n";
	$Sent=<STDIN>;
	chomp($Sent);
	if ( $Sent eq "q" ){
		exit;
	}
	$TaggingResult=();
	POSTagging($Sent,\$TaggingResult);
	print "$TaggingResult\n";
}

sub ReadProb
{
	my($LexProb,$TransProb)=@_;
	open(FileIn,"$LexProb") or return -1;
	my $Word=();
	my %hashLexProb=();
	while(<FileIn>){
		chomp;
		if ( /^\#(.*)/ ){
			if ( length($Word) > 0 ){
				my %hashLexProbTmp=%hashLexProb;
				$LexiconProb{$Word}=\%hashLexProbTmp;
			}
			%hashLexProb=();
			$Word=$1;
		}else{
			if ( /(\S+)\t(\S+)/){
				$hashLexProb{$1}=$2;
			}
		}
	}
	$LexiconProb{$Word}=\%hashLexProb;
	close(FileIn);

	open(FileIn,"$TransProb") or return -1;
	while(<FileIn>){
		chomp;
		if ( /(.*)\t(.*)/){
			$TransionProb{$1}=$2;
		}
	}
	close(FileIn);
	return 1;
}

sub POSTagging
{
	my ($Sent,$ResultRef)=@_;
	my @Lattich;
	BuildLattich($Sent,\@Lattich);
	for($i=1;$i<@Lattich;$i++){
		my $PrevRef=$Lattich[$i-1];
		my $CurrRef=$Lattich[$i];
		for($j=0;$j<@$CurrRef;$j++){
			my $MaxScore=-1.0e10;
			my $PrevIndex;
			my $CurrNode=${$CurrRef}[$j];
			for($k=0;$k<@$PrevRef;$k++){
				my $PrevNode=${$PrevRef}[$k];
				$Score=GetTransionProb($PrevNode->[1],$CurrNode->[1])+GetLexProb($CurrNode->[0],$CurrNode->[1])+$PrevNode->[2];
				if ( $Score > $MaxScore ){
					$MaxScore=$Score;
					$PrevIndex=$k;
				}
			}
			$CurrNode->[2]=$MaxScore;
			$CurrNode->[3]=$PrevRef->[$PrevIndex];
		}
	}
	
	BackWard(\@Lattich,$ResultRef); 
}

sub BackWard
{
	my ( $LattichRef,$ResultRef)=@_;
	$LattichLen=@$LattichRef;
	my @WordPOSs=();
	$BackwradPointer=$LattichRef->[$LattichLen-1]->[0]->[3];
	while( $BackwradPointer->[3] != 0 ){
		$WordPOS=$BackwradPointer->[0]."/".$BackwradPointer->[1];
		$BackwradPointer=$BackwradPointer->[3];
		unshift(@WordPOSs,$WordPOS);
	}
	$$ResultRef=join(" ",@WordPOSs);
}


sub BuildLattich
{
	my($Sent,$LattichRef)=@_;
	@Words=split(" ",$Sent);
	unshift(@Words,'^BEGIN');
	push(@Words,'$END');
	foreach $OneWord(@Words){
		my @Row;
		my @POSs;
		GetPOS($OneWord,\@POSs);
		foreach $OnPOS(@POSs){
			my @Element;
			push(@Element,$OneWord);
			push(@Element,$OnPOS);
			push(@Element,0);
			push(@Element,0);
			push(@Row,\@Element);
		}
		push(@$LattichRef,\@Row);
	}
}

sub GetPOS
{
	my($Word,$POSRef)=@_;
	if ( defined $LexiconProb{$Word} ){
		$TmpRef=$LexiconProb{$Word};
		@$POSRef=keys(%$TmpRef);
	}else{
		if ( $Word=~/\d+/ ){
			push(@$POSRef,"CD");
		}else{
			push(@$POSRef,"NN");
		}
	}
}

sub GetTransionProb
{
	my($PrevPOS,$CurrPOS)=@_;
	my $POSBig=$PrevPOS." ".$CurrPOS;
	if ( defined $TransionProb{$POSBig} ){
		return $TransionProb{$POSBig};
	}
	return -1.0e10;
}

sub GetLexProb
{
	my($Word,$POS)=@_;
	if ( defined $LexiconProb{$Word} ){
		$POSRef=$LexiconProb{$Word};
		if ( defined $POSRef->{$POS} ){
			return $POSRef->{$POS};
		}else{
			return 1.0e-10;
		}
	}	
	return -1.0e10;
}

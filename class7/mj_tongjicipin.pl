open(In,"change.txt");
open(Out,">cipin.txt");
$i=0;
while(<In>)
{
	chomp;
	@words=split("\/",$_);
	foreach $word (@words)
	{
		if(defined $Hash{$word})
		{
			$Hash{$word}++;
		}
		else
		{
			$Hash{$word}=1;
		}
	}
	if($i%1000==0)
	{print"$i\n"};
	$i++;
}

foreach $menber(sort{$Hash{$a}<=>$Hash{$b}} keys %Hash)
{
	print Out "$menber $Hash{$menber}\n"
}

close(Out);
close(In);

open(In,"lm.dic");
while(<In>){
	chomp;
	push(@file,$_);
	#print "$_\n";
}
close(In);

for($i=0;$i<@file;$i++){
	my $line = $file[$i];
	#print "$line\n";
	if($line=~/PY:(.*)/){
		$line2 = $1;
		$line2=~s/[\d\s]//g;

		push(@PinYins,$line2);
	}
	if($line=~/#(.*)/){
		$line2 = $1;
		push(@HanZis,$line2);
	}
} 
	
for ($i=0;$i<@HanZis;$i++){ #获取拼音对应词列表的哈希
	#print "$PinYins[$i]\n";
	push(@{$result{$PinYins[$i]}},$HanZis[$i]);
	
}

open(In,"cipin.txt");
while(<In>){ #获取词频的哈希表
	chomp;
	@arr = split(" ",$_);
	$Cipin{$arr[0]} = $arr[1];
}
close(In);


foreach (sort keys %result){#按词频排序%result
	@{$result{$_}} = sort { $Cipin{$b} <=> $Cipin{$a} } @{$result{$_}};
}



print "Pls:(q to exit,d to delete)\n"; #以下操作为输入法功能部分
$Sent = <stdin>;
chomp $Sent;
while(1){
	if($Sent eq 'q'){#输入q退出程序
		last;
	}
	deleteLast();#输入d表示删除最后一个字符
	
	while(length($Sent)>0){
		$MaxLen = 20;
		if(length($Sent)<$MaxLen){ #比较输入字符串和理论最大长度
			$MaxLen = length($Sent);
		}
		for($Len=$MaxLen;$Len>0;$Len--){
			$ToLook = substr($Sent,0,$Len);
			if(defined $result{$ToLook}){
				#push(@sentences,${$result{$ToLook}});
				$tempindex = 1;
				foreach $e (@{$result{$ToLook}}){#打印词列表以供选择
					print "$tempindex.$e ";
					$tempindex++;
				}
				print "\nChoose num(0 to change,-1 to cancel): ";
				chooseFunc();#对拼音对应的单词挑进行操作
			}
		}
		$Sent = substr($Sent,$Len,length($Sent)-$Len);
	}
	nextInput();
}

sub nextInput{#下一次输入所需的操作
	system("cls");
	foreach (@sentences){
		print "$_";
	}
	print "\nPls:(q to exit,d to delete)\n";
	$Sent = <stdin>;
	chomp $Sent;
}

sub deleteLast{
	if($Sent eq 'd'){
		$lastWord = $sentences[@sentences-1];
		$lastWordLen = length($sentences[@sentences-1]);
		if($lastWordLen==2){#单字符情况
			pop @sentences;
		}else{
			$sentences[@sentences-1] = substr($sentences[@sentences-1],0,length($sentences[@sentences-1]-1));
		}
		nextInput();
		next;
	}
}

sub chooseFunc{
	$temp_in = <stdin>;
	chomp $temp_in;
	if($temp_in==0){#0表示不使用当前长拼音，继续缩短
		next;
	}elsif($temp_in == -1){#-1表示舍弃当前输入的所有拼音
		last;
	}else{
		push(@sentences,${$result{$ToLook}}[$temp_in-1]);#否则将截取到的最大拼音串对应的词push进入@sentences
		last;
	}
}




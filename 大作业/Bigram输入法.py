def InitUnigram(filename):
    f = open(filename, 'r')
    hash = {}
    for line in f:
        temp = line.strip('\n').split(' ')
        hash[temp[0]] = float(temp[1])
    return hash

def InitBigram(filename):
    #返回双字对应的最大似然值
    f = open(filename,'r')
    hash = {}
    for line in f:
        temp = line.strip('\n').split(' ')
        hash[temp[0]] = float(temp[1])
    return hash

def InitDict(filename):
    #返回拼音对应汉字数组的哈希
    f = open(filename, 'r')
    hash = {}
    for line in f:
        arr = line.strip('\n').split(' ')
        hash[arr[0]] = arr[1:]
    return hash

def BuildLattice(line):
    PYs = line.strip('\n').split(' ')
    PYs.insert(0,'B')
    PYs.append('E')
    lattice = [] #保存需要返回的三层数组
    for py in PYs:
        Hzs = Py2Hz[py] #保存某拼音对应的汉字们
        column = []
        for hz in Hzs:
            temp = [hz, 0, '']
            column.append(temp)
        lattice.append(column)
    return lattice


def ComputeLattice(lattice):
    for i in range(len(lattice)):
        part = lattice[i] #part是某拼音对应的二维数组
        if(part[0][0]=='B'):
            #跳过首位的辅助占位元素
            continue
        for hz_num in part:
            res = GetMaxProb(hz_num,lattice[i-1])
            #temp123 = input()
            hz_num[1] = res[0]
            hz_num[2] = hz_num[2] + res[1]

def GetMaxProb(hz, lastList):
    MaxProb = -10000
    MaxHz = ''
    for part in lastList:
        prob = part[1] + GetUnigram(hz[0]) + GetBigram(part[0],hz[0])
		# 此处不仅加了转移概率Bigram，也加了单字的概率Unigram
        #print(part[0],hz[0],part[1],GetBigram(part[0],hz[0]),prob)
        if prob > MaxProb:
            MaxProb = prob
            MaxHz = part[2]+hz[0]
    return MaxProb,MaxHz

def GetUnigram(a):
    res = -20
    if a in UnigramHash:
        res = UnigramHash[a]
    return  res

def GetBigram(a,b):
    # 获得两个字符合并后在BigramHash的概率估计
    res = -50
    if(a+b in BigramHash):
        res = BigramHash[a+b]
    return res

UnigramHash = InitUnigram("2-gram_1.txt")
BigramHash = InitBigram("2-gram_2.txt")
Py2Hz = InitDict("invert.txt")
while(True):
    line = input("Pls:")
    Lattice = BuildLattice(line)
    ComputeLattice(Lattice)
    res = Lattice[len(Lattice)-1][0][2]
    print(res[:-1])
def InitWTHash(filename):
    #构建 单词 -> 词性 -> 概率 的双层hash
    f = open(filename, 'r')
    hash = {}
    for line in f:
        arr = line.strip('\n').split(' ')
        if arr[0] in hash:
            hash[arr[0]][arr[1]] = float(arr[2])
        else:
            tempHash = {}
            tempHash[arr[1]] = float(arr[2])
            hash[arr[0]] = tempHash
    return hash

def InitT2Hash(filename):
    #返回双词性对应的概率
    f = open(filename,'r')
    hash = {}
    for line in f:
        temp = line.strip('\n').split(' ')
        hash[temp[0]] = float(temp[1])
    return hash

def BuildLattice(line):
    Words = line.strip('\n').split(' ')
    Words.insert(0,'^BEGIN')
    #Words.append('E')
    lattice = [] #保存需要返回的三层数组
    for word in Words:
        WTs = WTHash[word].keys()  # 某单词对应的所有词性的数组
        column = []
        for t in WTs:
            column.append([t,word,0,''])
            # 注意此处插入的是 [词性，单词，概率，结果]
        lattice.append(column)
    return lattice

def ComputeLattice(lattice):
    for i in range(1,len(lattice)):
        part = lattice[i] #part是某单词对应的二维数组
        for wtProb in part:
            res = GetMaxProb(wtProb,lattice[i-1])
            wtProb[2] = res[0]
            wtProb[3] = res[1]

def GetMaxProb(wordProb, lastList):
    MaxProb = -10000
    MaxHz = ''
    for part in lastList:
        prob = part[2] + WTHash[wordProb[1]][wordProb[0]] + T2Hash[part[0]+"_"+wordProb[0]]
        # 当前单词的概率 = 上一节点概率 + 该单词的该词性的概率 + 词性的转移概率
        # print(part[0],hz[0],part[1],GetBigram(part[0],hz[0]),prob)
        if prob > MaxProb:
            MaxProb = prob
            MaxHz = part[3]+" "+wordProb[1]+"/"+wordProb[0]
    return MaxProb,MaxHz


WTHash = InitWTHash("WTProb.txt")
T2Hash = InitT2Hash("T2Prob.txt")

while(True):
    line = input("Pls:")
    Lattice = BuildLattice(line)
    ComputeLattice(Lattice)
    res = Lattice[len(Lattice)-1][0][3]
    print(res)
    # Eg: Mr. Vinken is chairman of Elsevier N.V. , the Dutch publishing group
def InitDict(filename):
    #返回分词结果对应概率的哈希
    f = open(filename, 'r')
    hash = {}
    for line in f:
        arr = line.strip('\n').split(' ')
        hash[arr[0]] = float(arr[1])
    return hash

def BuildLattice(line):
    line = line.strip('\n')
    line = 'B' + line
    # line.append('E')
    lattice = []  # 保存需要返回的三层数组
    for n in range(len(line)):
        allCi = []
        for index in range(n):
            word = line[index:n+1]  # 以line[n]这个字为结尾的词
            if word in Dict:
                allCi.append([word,Dict[word],''])
        allCi.append([line[n],-50,''])
        """
        此处直接向二位数组中加入 [词，词的概率，指针位]
        词是以line[n]这个字为结尾的词，比如"原子组成"
        第一列 第二列第三列第四列
         原     子   组   成
               原子      组成
                       原子组成 
        """
        lattice.append(allCi)
    return lattice


def ComputeLattice(lattice):
    for i in range(1,len(lattice)):
        part = lattice[i]  # part是某拼音对应的二维数组
        for hz_num in part:
            length = len(hz_num[0])
            # print(i,hz_num,lattice[i-length])
            res = GetMaxProb(hz_num,lattice[i-length])
            hz_num[1] = res[0]
            hz_num[2] = hz_num[2] + res[1]
            # print(hz_num[2])


def GetMaxProb(hz, lastList):
    MaxProb = -10000
    MaxHz = ''
    for part in lastList:
        prob = part[1] + hz[1]
        #print(part[2]+hz[0],prob)
        if prob > MaxProb:
            MaxProb = prob
            MaxHz = part[2]+'/'+hz[0]
    return MaxProb,MaxHz

Dict = InitDict("Prob_Ci.txt")

while(True):
    line = input("Pls:")
    Lattice = BuildLattice(line)
    ComputeLattice(Lattice)
    res = Lattice[len(Lattice)-1][0][2]
    print(res)
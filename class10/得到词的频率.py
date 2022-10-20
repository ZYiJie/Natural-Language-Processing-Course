import math
def InitCipin(filename):
    f = open(filename, 'r')
    hash = {}
    for line in f:
        temp = line.strip('\n').split(' ')
        hash[temp[0]] = int(temp[1])
    f.close()
    return hash

hash = InitCipin("cipin.txt")
sum = 0
for i in hash.items():
    sum += i[1]
#print(sum)
for i in hash.keys():
    hash[i] = math.log(hash[i]/sum)
with open('temp.txt','w') as f:
    for i in hash.items():
        f.write("%s %.8f\n"%(i[0],i[1]))
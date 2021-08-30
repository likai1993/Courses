import random
import numpy
from statistics import mean,stdev
from scipy.stats.stats import pearsonr
a=[1,2,3,4,5,6,7,8,9,10]
b=[p*2 for p in a]
c=random.sample(range(100), 10)


print("Scipy pearson")
print("ab", pearsonr(a,b))
print("bc", pearsonr(b,c))
print("ca", pearsonr(c,a))



print("Numpy pearson")
print("ab", numpy.corrcoef(a,b))
print("bc", numpy.corrcoef(b,c))
print("ca", numpy.corrcoef(c,a))


print("cov")
ma=mean(a)
mb=mean(b)
mc=mean(c)


def pr(x, y):
    # Assume len(x) == len(y)
    n = len(x)
    sum_x = float(sum(x))
    sum_y = float(sum(y))
    sum_x_sq = sum(xi*xi for xi in x)
    sum_y_sq = sum(yi*yi for yi in y)
    psum = sum(xi*yi for xi, yi in zip(x, y))
    num = psum - (sum_x * sum_y/n)
    den = pow((sum_x_sq - pow(sum_x, 2) / n) * (sum_y_sq - pow(sum_y, 2) / n), 0.5)
    if den == 0: return 0
    return num / den


sab=0
sbc=0
sca=0
for i in range(0,10):
    sab=sab + ((a[i] - ma) * (b[i]-mb))
    sbc=sbc +( (b[i] - mb) * (c[i]-mc))
    sca=sca +( (c[i] - mc) * (a[i]-ma))
covab=sab/9
covbc=sbc/9
covca=sca/9

corab=covab/(stdev(a)+stdev(b))
corbc=covbc/(stdev(b)+stdev(c))
corca=covca/(stdev(c)+stdev(a))


print(pr(a,b),pr(b,c),pr(c,a))
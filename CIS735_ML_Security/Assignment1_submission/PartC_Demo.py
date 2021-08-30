import pandas as pd
import itertools
import numpy as np
from scipy.spatial import distance

users=["A","B"]
df=pd.read_csv('Features.csv')
df=df.drop(["User"],axis=1)
print(df)
distancelist=[]
for i in range(0,10):
    for j in range (i+1,10):
        a = df.iloc[i].tolist()
        no1=a.pop(0)
        print(a)
        b = df.iloc[j].tolist()
        no2=b.pop(0)
        print(b)
        Euclid=distance.euclidean(a, b)
        Manhattan=sum(abs(p-q) for p, q in zip(a,b))
        print (Euclid)
        print (Manhattan)
        u1 = "A" if i<5 else "B"
        u1+="_"+str(int(no1))
        u2 = "A" if j<5 else "B"
        u2+="_"+str(int(no2))
        distancelist.append([u1,u2,Euclid,Manhattan])

print(distancelist)
dis_column=["FV1_User","FV2_User","Euclidean_Distance","Manhattan_Distance"]
distance_df=pd.DataFrame(data=distancelist,columns=dis_column)
print(distance_df)
distance_df.to_csv("Distance.csv",index=False)


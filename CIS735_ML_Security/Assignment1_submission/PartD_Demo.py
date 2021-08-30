import pandas as pd
from statistics import mean


test_sample=['Test1','Test2','Test3']
test_folder="TestSamples"
columns=["Xvalue","Yvalue","Zvalue"]

traindf=pd.read_csv('Features.csv')
traindfA=traindf[traindf['User']=='A'].drop(["User"],axis=1)
traindfB=traindf[traindf['User']=='B'].drop(["User"],axis=1)
#print(traindfA)

for test in test_sample:
    testdf=pd.read_csv('TestSamples/'+test+'.csv')
    feature_vector=[]
    for axis in columns:
        feature_vector=feature_vector+[round(testdf[axis].mean(),2),round(testdf[axis].std(),2),round(testdf[axis].max(),2),round(testdf[axis].min(),2),round(testdf[axis].sum(),2)]
    
    Adist=[]
    for index, row in traindfA.iterrows():
        Adist=Adist+[round(sum((p-q)**2 for p, q in zip(row, feature_vector)) ** .5,2)]
    Bdist=[]
    for index, row in traindfB.iterrows():
        Bdist=Bdist+[round(sum((p-q)**2 for p, q in zip(row, feature_vector)) ** .5,2)]
    print(Adist)
    print(Bdist)
    if mean(Adist) <= mean(Bdist):
        print(test+" belongs to User A")
    else:
        print(test+" belongs to User B")

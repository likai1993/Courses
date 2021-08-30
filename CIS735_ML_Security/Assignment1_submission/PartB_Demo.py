import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns


users = ["A","B"]
s_no= [1,2,3,4,5]
data_folder="DataSamples"
columns=["Xvalue","Yvalue","Zvalue"]

user="A"
s=1
axis="Xvalue"
features=["mean_X","std_X","max_X","min_X","sum_X"]

output=[]
for user in users:
    for s in s_no:
        feature_vector=[]
        df=pd.read_csv(data_folder+"/User"+user+"_"+str(s)+".csv")
        feature_vector=feature_vector+[df[axis].mean(),df[axis].std(),df[axis].max(),df[axis].min(),df[axis].sum()]
        feature_vector=[user] + [s] + feature_vector
        output.append(feature_vector)

print(output)
#feature_df=pd.DataFrame(data=[feature_vector],columns=["User"]+features)
feature_df=pd.DataFrame(data=output,columns=["User", "Sample no."]+features)
print(feature_df)
feature_df.to_csv("Features.csv",index=False)

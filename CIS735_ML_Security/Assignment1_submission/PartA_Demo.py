import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
users = ["A","B"]
s_no= [1,2,3,4,5]
data_folder="DataSamples"


label_size='x-large'

#read data
df1=pd.read_csv('DataSamples/UserA_1.csv',index_col="EID")
df1=df1.reset_index(drop=True)

#plot
lines=df1.plot.line()
plt.ylabel('Acceleration force', fontsize=label_size)
plt.xlabel('Event ID', fontsize=label_size)
plt.savefig("DemoUserA_1.png")
plt.show()
plt.clf()

u1xarray=df1["Xvalue"].tolist()
sns.distplot(df1['Xvalue'], hist = False, kde = True,
             kde_kws = {'linewidth': 2},
             label = "UA1_Xvalue")

plt.legend(prop={'size': 12}, title = 'Acc')
plt.xlabel('Accelerometer X value ')
plt.ylabel('Density')
plt.savefig("DemoDensityCurves_A.png")
plt.clf()


#user B
df1=pd.read_csv('DataSamples/UserB_1.csv',index_col="EID")
df1=df1.reset_index(drop=True)

#plot
lines=df1.plot.line()
plt.ylabel('Acceleration force', fontsize=label_size)
plt.xlabel('Event ID', fontsize=label_size)
plt.savefig("DemoUserB_1.png")
plt.show()
plt.clf()

u1xarray=df1["Xvalue"].tolist()
sns.distplot(df1['Xvalue'], hist = False, kde = True,
             kde_kws = {'linewidth': 2},
             label = "UA1_Xvalue")

plt.legend(prop={'size': 12}, title = 'Acc')
plt.xlabel('Accelerometer X value ')
plt.ylabel('Density')
plt.savefig("DemoDensityCurves_B.png")

#u2xarray=df2["Yvalue"].tolist()
#u2xarray=df2["Zvalue"].tolist()

#plot density


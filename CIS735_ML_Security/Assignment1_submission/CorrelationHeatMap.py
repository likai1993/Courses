import seaborn as sns

import matplotlib.pyplot as plt

import pandas as pd

df=pd.read_csv("Features.csv")
df=df.drop(["User"],axis=1)

sns.heatmap(df.corr())
#print(df.corr())
plt.show()
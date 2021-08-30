#!/usr/bin/env python
from scipy import stats
import math
import numpy as np
from collections import Counter

base = {
        'shannon' : 2.,
        'natural' : math.exp(1),
        'hartley' : 10.
}

def get_ent_from_map(maps, idx, value):
    ent = 0
    ocurs = []
    sumup=0
    for cls in maps.keys():
        values = maps[cls][idx]
        #print(cls, idx, value, values)
        ocur = values.count(value)
        if ocur > 0:
            #print(value, idx, ocur)
            sumup += ocur
            ocurs.append(ocur)
    for item in ocurs:
        ent -= float(item/sumup) * float(math.log(item/sumup, 2))
    print(ent)
    return ent
        
S1=[2, 5, 3, 8, 6, 6, 5, 5, 5, 7, 6, 6, 5]
S2=[3, 4, 4, 3, 3, 4, 3, 5, 3, 3, 6, 3, 2]
S3=[5, 1, 1, 5, 5, 3, 1, 1, 1, 4, 3, 4, 4]
S4=[4, 0, 0, 2, 2, 2, 0, 2, 0, 1, 1, 1, 1]
Labels=[0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 2, 2, 2]

Features=[S1, S2, S3, S4]

Maps={}
for index in range(len(Labels)):
   label = Labels[index]
   if label not in Maps.keys():
       Maps[label]={}
   for feature in Features:
       idx = Features.index(feature)+1
       if idx not in Maps[label].keys():
           Maps[label][idx]=[]
       Maps[label][idx].append(feature[index])

entropys={}
print(Maps)
for feature in Features:
    idx = Features.index(feature)+1
    entropy = 0 
    counts = Counter(feature)
    #print(counts)
    for key, value in counts.items():
        entropy -= value/len(feature) * get_ent_from_map(Maps, idx, key) 
        #print(key, value, entropy)
    #    if ()
    #for idx, items in Maps.items():
    #    print(idx, items)
#print(Maps)
index = 1

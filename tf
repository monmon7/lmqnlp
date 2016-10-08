# -*- coding: utf-8 -*-
"""
Created on Wed Sep 14 11:48:23 2016

@author: Administrator
"""

from Jaccard_sim1 import *
import numpy as np
import os
import re
import jieba
from dbLMQ import *

'''
fin——dict_yanji_C.txt
fsplit
ftem——t3
f2temp
3temp
fout--3

fin ftem 
'''
def doo(fin,fsplit,ftem,f2tem,fout) :
    
    dbsc(fin,fsplit,ftem) 
    '''
    算tf
    '''
    listTag = []
    listCount = []
    temp = []
    c = []
    c.append('1')
    f0 = open(ftem,'r')
    
    for line in f0.readlines():
        if line.strip()!= '' :      
            if line.strip('\n').split('\t')[0] in c :
                listTag.append(line.strip('\n').split('\t')[2])
                continue 
            c.append(line.strip('\n').split('\t')[0])
            temp = []
            for item in listTag :
                unit = []
                if item not in temp:
                    unit.append(item)
                    unit.append(listTag.count(item))
                    listCount.append(unit)
                    temp.append(item)
            listCount.sort(key=lambda x:x[1],reverse=True)
            for j in range(1) :
                print listCount[j][0],'  TF:',str(listCount[j][1])
                with open(f2tem, 'a') as f:
                    f.write(str(listCount[j][0]+'  TF:'))           
                    f.write(str(listCount[j][1]))
                    f.write('\n')
            listCount = []
            listTag = []        
            listTag.append(line.strip('\n').split('\t')[2])
    for item in listTag :
        unit = []
        if item not in temp:
            unit.append(item)
            unit.append(listTag.count(item))
            listCount.append(unit)
            temp.append(item)
    listCount.sort(key=lambda x:x[1],reverse=True)
    for j in range(1) :
#        print listCount[j][0],'  TF:',str(listCount[j][1])
        with open(f2tem, 'a') as f:
            f.write(str(listCount[j][0]+'  TF:'))           
            f.write(str(listCount[j][1]))
            f.write('\n')
    f0.close()
    '''
    近义词合并
    '''
    f = open(f2tem,'r')
    f2 = open('D:\\zmm\\tools_by_zmm\\tools_to_multi_files\\all_dataSet_split.txt.vec','r') #词向量文件
    
    #################################
    #   得到基于所有评论的词典mapping   #
    #################################
    #encoding=utf-8
    import sys;
    reload(sys);
    sys.setdefaultencoding("utf8")
    
    source=(f2.readlines())[1:]
#    l1=source[0].split(' ')
    word=[]
    vec=[]#6296个list,每个list100个str类型的数据
    for item in source:
        word.append((item.split(' ')[0]))
        vec.append(item.split(' ')[1:])
    mapping={}#必须有这个，不然会出现NameError
    mapping=dict(zip(word,vec))
    
    a=0.7  
    allArray = []
    tf1=[]
    for li in f.readlines() :   #给片段分词
        l = []
        tf =[]
        if li.strip()!='' :    
            tf.append(li.strip('\n').split('  ')[0])
            tf.append(int(li.strip('\n').split('  ')[1].split(':')[1]))
            tf1.append(tf)
            seg_list = list(jieba.cut(li.strip('\n').split('  ')[0]))
            for it in seg_list :
                it = it.encode('utf-8')
                l.append(it)
        
            arraylist = []
            for i in l :
                if i in mapping.keys() :
                    arraylist.append(np.array(map(float,mapping.get(i))))
            allArray.append(arraylist)
    
    
    for i in range(len(allArray)-1,-1,-1):
       # print i
        for j in range(0,i)[::-1]:
        #    print j
            if len(allArray[i])==1 and len(allArray[j])==1 :
                 if cos(allArray[i][0],allArray[j][0]) >= 0.7 :
                    print tf1[i][1],tf1[i][0],tf1[j][1],tf1[j][0],cos(allArray[i][0],allArray[j][0])
                    tf1[j][1] = tf1[i][1]+tf1[j][1]
                    tf1[i][1] = 0
                    break
            if jaccard_sim(a,allArray[i],allArray[j]) >= 0.6 :
                print tf1[i][1],tf1[i][0],tf1[j][1],tf1[j][0],jaccard_sim(a,allArray[i],allArray[j])
                tf1[j][1] = tf1[i][1]+tf1[j][1]
                tf1[i][1] = 0
               # allArray[i] = 0
                break
            
            
    f3 = open(fout,'a')        
    for i in range(len(tf1)):
        if tf1[i][1] != 0 :
            f3.write(tf1[i][0]+'\t'+'tf:'+str(tf1[i][1])+'\n')
    f.close()
    f2.close()
    f3.close()
            
            

#doo('D:\\zmm - fb\\wheels_by_zmm\\dbscan\\t1.txt','D:\\zmm - fb\\wheels_by_zmm\\dbscan\\1temp.txt','D:\\zmm - fb\\wheels_by_zmm\\dbscan\\1.txt')
#doo('D:\\zmm - fb\\wheels_by_zmm\\dbscan\\t2.txt','D:\\zmm - fb\\wheels_by_zmm\\dbscan\\2temp.txt','D:\\zmm - fb\\wheels_by_zmm\\dbscan\\2.txt')
#doo('D:\\zmm - fb\\wheels_by_zmm\\dbscan\\t3.txt','D:\\zmm - fb\\wheels_by_zmm\\dbscan\\3temp.txt','D:\\zmm - fb\\wheels_by_zmm\\dbscan\\3.txt')            
#doo('D:\\zmm - fb\\wheels_by_zmm\\dbscan\\t4.txt','D:\\zmm - fb\\wheels_by_zmm\\dbscan\\4temp.txt','D:\\zmm - fb\\wheels_by_zmm\\dbscan\\4.txt')
#doo('D:\\zmm - fb\\wheels_by_zmm\\dbscan\\t5.txt','D:\\zmm - fb\\wheels_by_zmm\\dbscan\\5temp.txt','D:\\zmm - fb\\wheels_by_zmm\\dbscan\\5.txt') 
#doo('D:\\zmm - fb\\wheels_by_zmm\\dbscan\\t6.txt','D:\\zmm - fb\\wheels_by_zmm\\dbscan\\6temp.txt','D:\\zmm - fb\\wheels_by_zmm\\dbscan\\6.txt')  

#do('dict_yanji_C.txt','_split2.txt','t2.txt') 
#do('dict_taici_C.txt','_split3.txt','t3.txt') 

#doo(fin,fsplit,ftem,f2temp,fout) :
    
doo('dict_yanji_C.txt','_split2.txt','t2.txt','D:\\zmm - fb\\wheels_by_zmm\\dbscan\\2temp.txt','D:\\zmm - fb\\wheels_by_zmm\\dbscan\\2.txt')
doo('dict_taici_C.txt','_split3.txt','t3.txt','D:\\zmm - fb\\wheels_by_zmm\\dbscan\\3temp.txt','D:\\zmm - fb\\wheels_by_zmm\\dbscan\\3.txt')

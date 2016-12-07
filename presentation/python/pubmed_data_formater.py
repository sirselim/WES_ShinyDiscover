
import re
pubmed = 'pubmed_data.txt'
counts=[]

fname = "r/pubmed_rr_search.txt"
with open(fname, 'r') as f:
    read_data = f.read().split('\n')
    #print read_data
    for number in read_data:
        if len(number) >= 1:
            year = number.split(',')[0]
            count = number.split(',')[1]
            items = [year, count]
            counts.append(items)

output = sorted(counts)
for o in output:
    print o[0]
    #write results to file in Highcharts.js format
    with open(pubmed,"a") as myfile:
        myfile.write('[Date.UTC(%s,1,1),%s],\n'% (o[0],o[1]))

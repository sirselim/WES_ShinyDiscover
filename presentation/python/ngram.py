
import re
#matchcount = 'ngram_matchcounts.txt'
#pagecount = 'ngram_pagecounts.txt'
bookcount = 'ngram_bookcounts_1000s.txt'

fname = "googlebooks-eng-all-totalcounts-20120701.txt"
with open(fname, 'r') as f:
    read_data = f.read()
    # four numbers
    # 1) year
    # 2) match_count
    # 3) page_count
    # 4) book_count
    get_numbers = re.findall('[0-9]+,[0-9]+,[0-9]+,[0-9]+', read_data)
    #split by comma
    #store index 0 (date) with 1,2,3
    for number in get_numbers:
        year = number.split(',')[0]
        #match_count = number.split(',')[1]
        #page_count = number.split(',')[2]
        book_count = int(number.split(',')[3])/1000.00

        #write results to file in Highcharts.js format
        #with open(matchcount,"a") as myfile:
        #    myfile.write('[Date.UTC(%s,0,0),%s],\n'% (year, match_count))
        #with open(pagecount,"a") as myfile:
        #    myfile.write('[Date.UTC(%s,0,0),%s],\n'% (year, page_count))
        with open(bookcount,"a") as myfile:
            myfile.write('[Date.UTC(%s,1,1),%s],\n'% (year, book_count))

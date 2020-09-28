from requests_html import HTMLSession
import csv

session = HTMLSession()

file = open('c:/Users/LENG/Desktop/movies.csv', 'w', newline='')
csvwriter = csv.writer(file)
csvwriter.writerow(['名称', '年份'])

links = ['https://movie.douban.com/subject/1292052/',\

         'https://movie.douban.com/subject/1962665/',\
         
         'https://movie.douban.com/subject/26752088/']

for link in links:
    r = session.get(link)
    title = r.html.find('#content > h1 > span:nth-child(1)', first=True)
    year = r.html.find('#content > h1 > span.year:nth-child(2)', first=True)
    csvwriter.writerow([title.text, year.text+'\t'])

file.close()

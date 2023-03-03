import pandas as pd
import requests
from bs4 import BeautifulSoup



# Web URL
base_url = 'https://finance.detik.com/ekonomi-bisnis/indeks/'

# Number of pages to be crawl
num_pages = 4

#news date
tgl='?date=11/22/2021'


titles_list = []

for i in range(1, num_pages+1):
    # Membuat URL untuk setiap halaman
    #print (base_url+str(i)+tgl)
    #liss='list'+str(i)+' ='
    response = requests.get(base_url+str(i)+tgl)
    


# Making BeautifulSoup object from the data
    soup = BeautifulSoup(response.text, 'html.parser')

# Find all tags with <h3> and class = "media_title" 
    news_titles = soup.find_all('h3', class_='media__title')
    

# List the title
    for title in news_titles:
        titles_list.append(title.text)

# Print the list of news

    print(titles_list)

    num_pages += 1

df = pd.DataFrame(titles_list)
df
# import to excel
df.to_excel('beritadetik5.xlsx',encoding='utf8', index=False)

import pandas as pd
import requests
from bs4 import BeautifulSoup


# Web URL
base_url = 'https://money.kompas.com/search/'
#https://money.kompas.com/search/2021-11-18/1

# Number of pages to be crawl
num_pages = 4

#news date
tgl='2021-11-22/'


titles_list = []
for i in range(1, num_pages+1):
    # Making URL per page
    response = requests.get(base_url+tgl+str(i))
    

# Making BeautifulSoup object from the data
    soup = BeautifulSoup(response.text, 'html.parser')

# Find all tags with <h2> and class = "terkiini_title" 
    news_titles = soup.find_all('h2', class_='terkini__title')
    
    

# List the title
    for title in news_titles:
        titles_list.append(title.text)

    
# Print the list of news
    print(titles_list)

    num_pages += 1
    
    
df = pd.DataFrame(titles_list)
df
# import to excel
df.to_excel('beritakompas5.xlsx',encoding='utf8', index=False)

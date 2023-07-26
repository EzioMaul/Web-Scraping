import pandas as pd

import requests
from bs4 import BeautifulSoup



# URL situs web yang akan di-crawl
base_url = 'https://www.bisnis.com/index/page/'

# Jumlah halaman yang akan di-crawl
num_pages = 5

#tanggal berita
tgl='?c=43&d=2021-11-22&per_page='


titles_list = []

for i in range(1, num_pages+1):
    # Membuat URL untuk setiap halaman
    #print (base_url+str(i)+tgl)
    #liss='list'+str(i)+' ='
    response = requests.get(base_url+tgl+str(i))
    

# Membuat objek BeautifulSoup dari data yang diambil
    soup = BeautifulSoup(response.text, 'html.parser')

# Mencari semua elemen HTML yang memiliki tag <> dan class ""
    news_titles = soup.find_all('div', class_='col-sm-8')
    

# Menambahkan setiap judul berita ke dalam list
    for title in news_titles:
        titles_list.append(title.text)

    

# Menampilkan list judul berita yang telah diambil

    #print(liss,titles_list)
    #print(liss)
    print(titles_list)

    num_pages += 1


df = pd.DataFrame(titles_list)
df
df.to_excel('beritabisnis5.xlsx',encoding='utf8', index=False)

import pandas as pd

import requests
from bs4 import BeautifulSoup



# URL situs web yang akan di-crawl
base_url = 'https://www.cnnindonesia.com/ekonomi/indeks/5/'
#https://www.cnnindonesia.com/ekonomi/indeks/5/7?date=2021/11/18

# Jumlah halaman yang akan di-crawl
num_pages = 7

#tanggal berita
tgl='?date=2021/11/22'


titles_list = []
#for page in range(1, num_pages+1):
#  url = base_url + f'/{page}' +tgl
for i in range(1, num_pages+1):
    # Membuat URL untuk setiap halaman
    #print (base_url+str(i)+tgl)
    #liss='list'+str(i)+' ='
    response = requests.get(base_url+str(i)+tgl)
    

# Membuat objek BeautifulSoup dari data yang diambil
    soup = BeautifulSoup(response.text, 'html.parser')

# Mencari semua elemen HTML yang memiliki tag <a> dan class "news-title"
    news_titles = soup.find_all('span', class_='box_text')
    

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
df.to_excel('beritacnn5.xlsx',encoding='utf8', index=False)

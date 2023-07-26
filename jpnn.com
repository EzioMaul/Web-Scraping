import pandas as pd
import requests
from bs4 import BeautifulSoup



# URL situs web yang akan di-crawl
base_url = 'https://m.jpnn.com/indeks'
#https://m.jpnn.com/indeks?id=216&d=18&m=11&y=2021&tab=all&page=1

# Jumlah halaman yang akan di-crawl
num_pages = 4

#tanggal berita
tgl='?id=216&d=27&m=11&y=2021&tab=all&page='


titles_list = []
#for page in range(1, num_pages+1):
#  url = base_url + f'/{page}' +tgl
for i in range(1, num_pages+1):
    # Membuat URL untuk setiap halaman
    #print (base_url+str(i)+tgl)
    #liss='list'+str(i)+' ='
    response = requests.get(base_url+tgl+str(i))
    

# Membuat objek BeautifulSoup dari data yang diambil
    soup = BeautifulSoup(response.text, 'html.parser')

# Mencari semua elemen HTML yang memiliki tag <a> dan class "news-title"
    news_titles = soup.find_all('div', class_='content-left')
    

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


df.to_excel('beritajpnn10.xlsx',encoding='utf8', index=False)

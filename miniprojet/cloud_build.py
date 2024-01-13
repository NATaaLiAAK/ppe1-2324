from multiprocessing.spawn import old_main_modules
from os import listdir
from os.path import isfile, join
import codecs
from wordcloud import WordCloud
import jieba
import matplotlib.pyplot as plt


# read data
mypath = 'contexts/'
font_filename = 'fonts/STFangSong.ttf'
files = [f for f in listdir(mypath) if isfile(join(mypath, f))]

text_list=[]
text=''
for file in files:
    with open(mypath+file) as f:
        lines = f.readlines()
        text = text + ' '.join(lines)


text = ' '.join(jieba.cut(text.replace(" ", "")))

stopwords_filename = 'stopwords.txt'
stopwords = set([line.strip()
                    for line in codecs.open(stopwords_filename, 'r', 'utf-8')])

# build wordcloud
wordcloud = WordCloud(font_path=font_filename, 
                      prefer_horizontal=1,stopwords=stopwords,
                      max_font_size=260, width=1000, height=860, max_words=200).generate(text)

plt.figure()
plt.imshow(wordcloud, interpolation="bilinear")
plt.axis("off")
plt.show()

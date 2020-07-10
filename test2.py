from bs4 import  BeautifulSoup
for i in range(1, 6):
    text = open(f'{i}.txt', 'r', encoding='UTF-8').read()

    siup = BeautifulSoup(text, 'lxml')

    a = text.find('Situation=')
    sitution = text[a+10:a+14].strip(' ').strip('"')
    print(sitution)
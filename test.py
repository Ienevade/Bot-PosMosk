from bs4 import BeautifulSoup

# from main import send_new_alarm
import datetime

time = str(datetime.datetime.now()).split('.')
lim = 200
file_op = str(open('a/response.xml', 'r', encoding="utf-8").read())
file = open('выручка.txt', 'w', encoding="utf-8")
soup = BeautifulSoup(file_op, 'lxml')
summary = 0
count = 0
sums = soup.find_all('sum_all')
for one_sum in sums:
    if count == 0:
        file.write('*****ОБЩАЯ ВЫРУЧКА*****' + '\n')
    count = + 1
    litr = one_sum.get('sum').split("'")
    a = float(litr[0])
    summary = summary + a
count = 0
if summary >= lim:
    с = str(f'На {time} сумма выручки превысила {lim} рублей')
    bet = 'рассылка_по_выручке.txt'
    print('выручка')
    # send_new_alarm(с, bet )
file.write(str(summary))

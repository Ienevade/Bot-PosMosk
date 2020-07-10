import xml.etree.ElementTree as ET
import configparser
import os
from bs4 import BeautifulSoup
import addons

config = configparser.ConfigParser()  # создаём объекта парсера
config.read("settings.ini")  # читаем конфиг


def detect_situation(message, bot, lock):
    a = message.find('Situation=')
    sitaution = message[a + 10:a + 14].strip(' ').strip('"')
    if sitaution == '16':
        delprech(message, bot, lock)
    if sitaution == '5':
        close_check(message, lock)
    if sitaution == '3':
        temp_check(message, bot, lock)
    if sitaution == '14':
        delcheck(message, bot, lock)


def close_check(text, lock):
    with lock:
        soup = BeautifulSoup(text, 'lxml')
        table = soup.find('closecheck').get('table')
        if os.path.exists(f'temp_table/{table}.txt'):
            os.remove(f'temp_table/{table}.txt')
        if os.path.exists(f'temp_eat/{table}.txt'):
            os.remove(f'temp_eat/{table}.txt')
        if os.path.exists(f'temp_discount/{table}.txt'):
            os.remove(f'temp_discount/{table}.txt')
    pays = soup.find_all('pay')
    for pay in pays:  # добавление выручки в файл отчётча
        name = pay.get('name')
        sum = pay.get('sum')
        summary(name, sum, lock)
    eats = soup.find_all('checkline')
    for eat in eats:  # добавление расхода блюд в файл отчётча
        name = eat.get('name')
        sum = eat.get('qnt')
        all_eat(name, sum)


def delprech(text, bot, lock):
    soup = BeautifulSoup(text, 'lxml')
    delpre = soup.find('deleteprecheck')
    logper = soup.find('loginperson')
    time = delpre.get('time')
    table = delpre.get('table')
    name = logper.get('name')
    if len(open('temp_reports/deleted_prech.txt', 'r', encoding='UTF-8').read()) == 0:
        format_text_delprech(time[0:10])
    strs = str(f'       Удаление пречека\n'
               f'-----------------------------------------\n')
    stre = str(f'{time} \n'
               f'официант {name}\n'
               f'Стол #{table}\n')
    file = open('temp_reports/deleted_prech.txt', 'a', encoding='UTF-8')
    file.write(stre)
    file.close()
    with open(f'temp_table/{table}.txt', 'r', encoding='UTF-8') as file:
        tenp_text = file.read()
        send_message = strs + stre + '\n\n' + tenp_text
    addons.send_new_alarm(send_message, 'subscrubers/Alarm_subs.txt', bot, lock)


def format_text_delprech(day):
    file = open('temp_reports/deleted_prech.txt', 'w', encoding='UTF-8')
    text = str(f'           Удалённые пречеки\n\n         кассовый день {day}\n\n'
               f'----------------------------------------\n')
    file.write(text)
    file.close()


def delcheck(text, bot, lock):
    soup = BeautifulSoup(text, 'lxml')
    delpre = soup.find('deletecheck')
    logper = soup.find('loginperson')
    time = delpre.get('time')
    table = delpre.get('table')
    name = logper.get('name')
    check = delpre.get('checknumber')
    if len(open('temp_reports/deleted_check.txt', 'r', encoding='UTF-8').read()) == 0:
        format_text_delchek(time[0:10])
    strs = str(f'       Удаление чека\n'
               f'------------------------------\n')
    stre = str(f'{time} \n'
               f'официант {name}\n'
               f'Чек #{check}\n'
               f'Стол #{table}\n\n\n')
    file = open('temp_reports/deleted_check.txt', 'a', encoding='UTF-8')
    file.write(stre)
    file.close()
    addons.send_new_alarm(strs + stre, 'subscrubers/Alarm_subs.txt', bot, lock)


def format_text_delchek(day):
    file = open('temp_reports/deleted_check.txt', 'w', encoding='UTF-8')
    text = str(f'           Удалённые чеки\n\n         кассовый день {day}\n\n'
               f'----------------------------------------\n')
    file.write(text)
    file.close()


def all_eat(name, sum):
    # with lock:
    file = open('temp_reports/eaten_eat.txt', 'r', encoding='UTF-8')
    is_find = False
    old_data = file.read()
    if len(old_data) != 0:
        file.seek(0)
        datas = file.readlines()
        file.close()
        for data in datas:
            want_name = data.split('%%')[0]
            old_sum = data.split('%%')[1]
            if want_name == name:
                new_data = old_data.replace(f'{want_name}%%{old_sum}',
                                            f'{want_name}%%{float(sum) + float(old_sum)}\n')
                is_find = True
                file = open('temp_reports/eaten_eat.txt', 'w', encoding='UTF-8')
                file.write(new_data)
                file.close()
                break
        if not is_find:
            file.close()
            file = open('temp_reports/eaten_eat.txt', 'a', encoding='UTF-8')
            file.write(f'{name}%%{sum}\n')
            file.close()

    else:
        file.close()
        file = open('temp_reports/eaten_eat.txt', 'w', encoding='UTF-8')
        file.write(f'{name}%%{sum}\n')
        file.close()


def summary(name, sum, lock):
    with lock:
        file = open('temp_reports/current_money.txt', 'r', encoding='UTF-8')
        is_find = False
        old_data = file.read()
        if len(old_data) != 0:
            file.seek(0)
            datas = file.readlines()
            file.close()
            for data in datas:
                want_name = data.split('%%')[0]
                old_sum = data.split('%%')[1]
                if want_name == name:
                    new_data = old_data.replace(old_sum, str(float(sum) + float(old_sum)) + '\n')
                    is_find = True
                    file = open('temp_reports/current_money.txt', 'w', encoding='UTF-8')
                    file.write(new_data)
                    file.close()
                    break
            if not is_find:
                file.close()
                file = open('temp_reports/current_money.txt', 'a', encoding='UTF-8')
                file.write(f'{name}%%{sum}\n')
                file.close()

        else:
            file.close()
            file = open('temp_reports/current_money.txt', 'w', encoding='UTF-8')
            file.write(f'{name}%%{sum}\n')
            file.close()


def temp_check(text, bot, lock):
    with lock:
        delete_disc = False
        soup = BeautifulSoup(text, 'lxml')
        table = soup.find('screencheck').get('table')
        summary = soup.find('screencheck').get('sum')
        time = soup.find('sysparams').get('time')
        offic = soup.find('loginperson').get('name')
        datases = soup.find_all('checkline')
        datas = list()
        first = True

        for datasess in datases:
            name = datasess.get("name")
            qnt = datasess.get("qnt")
            tempor = f'{name}%%{qnt}'
            finded = False
            if first:
                datas.append(tempor)
                first = False
                continue
            for i in range(0, len(datas)):
                if name == datas[i].split('%%')[0]:
                    more_qnt = float(datas[i].split('%%')[1])
                    datas[i] = f'{name}%%{str(float(qnt) + more_qnt)}'
                    finded = True
                    break
            if not finded:
                datas.append(tempor)
        a = str()
        disc_text = str()
        coutn = 0
        for data in datas:
            name = data.split('%%')[0]
            qnt = data.split('%%')[1]
            delete_eat(name, qnt, lock, table, offic, bot, time)
            a += format_prech(name, qnt, datases[coutn].get("price"))
            coutn += 1
        try:
            disc_name = soup.find('discount').get('name')
            disc_sum = soup.find('discount').get('sum')
            disc_text = str(f'\n{disc_name}             {disc_sum}\n')
            if not os.path.exists(f'temp_discount/{table}.txt'):
                with open('temp_reports/discount.txt', 'a', encoding="UTF-8") as piz:
                    piz.write(str(f'{disc_name}             {disc_sum}\n'))
                file = open(f'temp_discount/{table}.txt', 'x', encoding='UTF-8')
                file.write('Нечего тут лазить, выйдите из папки')
                file.close()
        except:
            if os.path.exists(f'temp_discount/{table}.txt'):
                delete_disc = True
        spaces = " " * (27 - len(summary))
        new_summary = spaces + summary
        if delete_disc:
            with open(f'temp_table/{table}.txt', 'r', encoding='UTF-8')as file:
                text = file.read()
            headers = '     ВНИМАНИЕ, УДАЛЕНА СКИДКА\n\n'
            message = headers + text
            addons.send_new_alarm(message, 'subscrubers/Alarm_subs.txt', bot, lock)
            os.remove(f'temp_discount/{table}.txt')
        head = str(f'          Стол№ {table}\n'
                   f'Печать {time}\n'
                   f'Официант: {offic}\n'
                   f'\n'
                   f'Блюдо                   Кол-во     Сумма\n'
                   f'----------------------------------------\n'
                   f'{a}'
                   f'----------------------------------------\n'
                   f'Итого к оплате{new_summary}\n'
                   f'{disc_text}'
                   f'----------------------------------------')

        if os.path.exists(f'temp_table/{table}.txt'):
            file = open(f'temp_table/{table}.txt', 'w', encoding='UTF-8')
            file.write(head)
            file.close()
        else:
            file = open(f'temp_table/{table}.txt', 'x', encoding='UTF-8')
            file.write(head)
            file.close()


def format_prech(name, num, price):
    if len(name) > 21:
        new_name1 = name[0:20]
        new_name4 = name[20:len(name)]
        parts = new_name1.split(' ')
        new_name3 = parts[-1]
        new_name2 = new_name3 + new_name4
        new_name1 = str('')
        for i in range(0, len(parts) - 1):
            new_name1 += parts[i] + ' '
        if len(new_name1) < 21:
            need = 21 - len(new_name1)
            strr = ' ' * need
            new_name1 += strr
        if len(num) < 8:
            spaces = " " * (8 - len(num))
            new_num = spaces + num
        if len(str(float(price) * float(num))) < 12:
            spaces = " " * (12 - len(str(float(price) * float(num))))
            new_price = spaces + str(float(price) * float(num))
        text = str(f"{new_name1}{new_num}{new_price}\n"
                   f"{new_name2}\n")
    else:
        new_name1 = name
        if len(new_name1) < 21:
            need = 21 - len(new_name1)
            strr = ' ' * need
            new_name1 += strr
        if len(num) < 8:
            spaces = " " * (8 - len(num))
            new_num = spaces + num
        if len(str(float(price) * float(num))) < 12:
            spaces = " " * (12 - len(str(float(price) * float(num))))
            new_price = spaces + str(float(price) * float(num))
        text = str(f"{new_name1}{new_num}{new_price}\n")
    return (text)


def delete_eat(name, new_qnt, lock, table, oficc, bot, time):
    with lock:
        if os.path.exists(f'temp_eat/{table}.txt'):
            file = open(f'temp_eat/{table}.txt', 'r', encoding='UTF-8')
            is_find = False
            old_data = file.read()
            file.seek(0)
            datas = file.readlines()
            file.close()
            for data in datas:
                want_name = data.split('%%')[0]
                old_qnt = data.split('%%')[1]
                if want_name == name:
                    if float(old_qnt) > float(new_qnt):
                        message = str(f'        ВНИМАНИЕ УДАЛЕНИЕ БЛЮДА\n'
                                      f'-----------------------------------\n'
                                      f'Официант {oficc}\n'
                                      f'Стол {table}\n'
                                      f'Дата {time}\n'
                                      f'Удалено {name}\n'
                                      f'Было {old_qnt}\n'
                                      f'Cтало {new_qnt}')
                        addons.send_new_alarm(message, 'subscrubers/Alarm_subs.txt', bot, lock)
                    new_data = old_data.replace(old_qnt, new_qnt + '\n')
                    is_find = True
                    file = open(f'temp_eat/{table}.txt', 'w', encoding='UTF-8')
                    file.write(new_data)
                    file.close()
                    break
            if not is_find:
                file.close()
                file = open(f'temp_eat/{table}.txt', 'a', encoding='UTF-8')
                file.write(f'{name}%%{new_qnt}\n')
                file.close()

        else:
            file = open(f'temp_eat/{table}.txt', 'x', encoding='UTF-8')
            file.write(f'{name}%%{new_qnt}\n')
            file.close()

# close_check(open('5.txt', 'r', encoding='UTF-8').read())

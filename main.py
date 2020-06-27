import configparser
import datetime
import subprocess
import time
import telebot
from telebot import types, apihelper
import threading
from bs4 import BeautifulSoup

PROXY = 'socks5://127.0.0.1:9050'
apihelper.proxy = {'https': PROXY}
lock = threading.RLock()

config = configparser.ConfigParser()  # создаём объекта парсера
config.read("settings.ini")  # читаем конфиг
bot = telebot.TeleBot(config['settings']['token'], threaded=True)  # Инициализация бота
menu_markup = 'markup_report'
markup_start = types.ReplyKeyboardMarkup(row_width=2)
markup_start.add('Привет')
markup_start.add('Подписки на расслыки')
markup_start.add('Отчёт')
markup_start.add('Пока')

markup_send_al = types.ReplyKeyboardMarkup(row_width=2)
markup_send_al.add('Подписки-> скидки')
markup_send_al.add('Подписки-> выручка')
markup_send_al.add('Назад->')


@bot.message_handler(commands=['start'])  # Вывод первого меню по команде \start
def start_message(message):
    global markup_start, menu_markup
    bot.send_message(message.chat.id, 'Привет, ты написал мне /start', reply_markup=markup_start)
    menu_markup = 'markup_start'


@bot.message_handler(content_types=['text'])  # Начало хендлера
def send_text(message):
    global menu_markup

    print(message.from_user.username, 'в чате', message.chat.title, message.chat.id, 'написал',
          # мониторинг сообщений от пользователей
          message.text.lower())

    if message.text.lower() == 'тест':
        a = message.chat.id
        bot.send_message(message.chat.id, a)

    elif message.text.lower() == 'пока':
        bot.send_message(message.chat.id, 'Прощай')

    elif message.text.lower() == 'привет':
        bot.send_message(message.chat.id, 'Дороу')

    elif message.text.lower() == 'меня зовут маргарита':
        bot.send_message(message.chat.id, 'Ты самая лучшая жена')

    elif message.text.lower() == 'создатель':
        bot.send_message(message.chat.id, 'Gupye, vk.com/gupye, +79788781055')

    elif message.text.lower() == 'отчёт->сформировать':
        res = xml_work()
        if res:
            bot.send_message(message.chat.id, 'Отчёт сформирован')
        else:
            bot.send_message(message.chat.id, 'Не удалось сформировать')

    elif message.text.lower() == 'подписки на расслыки':  # Вывод меню для подписок

        bot.send_message(message.chat.id, 'выберите тип подписки', reply_markup=markup_send_al)
        menu_markup = 'markup_send_al'

    elif message.text.lower() == 'назад->':  # Вывод меню для получения отчёта
        if menu_markup == 'markup_report':
            bot.send_message(message.chat.id, 'назад ', reply_markup=markup_start)
        elif menu_markup == 'markup_send_al':
            bot.send_message(message.chat.id, 'назад ', reply_markup=markup_start)
        elif menu_markup == 'markup_cancel_send':
            bot.send_message(message.chat.id, 'назад ', reply_markup=markup_send_al)
            menu_markup = 'markup_send_al'
        elif menu_markup == 'markup_cancel_send_allmon':
            bot.send_message(message.chat.id, 'назад ', reply_markup=markup_send_al)
            menu_markup = 'markup_send_al'

    elif message.text.lower() == 'отчёт':  # Вывод меню для получения отчёта
        markup_report = types.ReplyKeyboardMarkup(row_width=2)
        markup_report.add('Отчёт->операции')
        markup_report.add('Отчёт->скидки')
        markup_report.add('Отчёт->выручка')
        markup_report.add('Отчёт->время начала работы')
        markup_report.add('Отчёт->сформировать')
        markup_report.add('Назад->')
        bot.send_message(message.chat.id, 'выберите тип отчёта', reply_markup=markup_report)
        menu_markup = 'markup_report'

    elif message.text.lower() == 'отчёт->время начала работы':  # Вывод отчёта по времени начала работы
        with lock:
            f = open('Первая_операция.txt', 'r', encoding="utf-8")
            a = f.read()
            f.close()
            if len(a) != 0:
                bot.send_message(message.chat.id, f'Время начала работы {a}')
            else:
                bot.send_message(message.chat.id, 'Отчёт пуст')

    elif message.text.lower() == 'отчёт->выручка':  # Вывод отчёта по выручке
        with lock:
            f = open('выручка.txt', 'r', encoding="utf-8")
            a = f.read()
            f.close()
            if len(a) != 0:
                bot.send_message(message.chat.id, a)
            else:
                bot.send_message(message.chat.id, 'Отчёт пуст')

    elif message.text.lower() == 'отписаться-> выручка':
        with lock:
            file = open('рассылка_по_выручке.txt', 'r', encoding='UTF-8')
            mans = file.readlines()
            file.close()
        del_man = str(message.chat.id)
        file.close()
        if len(mans) > -1:
            for i in range(0, len(mans)):
                if del_man in str(mans[i]).strip():
                    del mans[i]
                    bot.send_message(message.chat.id, 'Вы отписались', reply_markup=markup_send_al)
                    break
        with lock:
            file = open('рассылка_по_выручке.txt', 'w', encoding='UTF-8')
            for man in mans:
                file.write(man)
            file.close()

    elif message.text.lower() == 'отписаться->скидки':
        with lock:
            file = open('send_disc.txt', 'r', encoding='UTF-8')
            mans = file.readlines()
            file.close()
        del_man = str(message.chat.id)
        file.close()
        if len(mans) > -1:
            for i in range(0, len(mans)):
                if del_man in str(mans[i]).strip():
                    del mans[i]
                    bot.send_message(message.chat.id, 'Вы отписались', reply_markup=markup_send_al)
                    break
        with lock:
            file = open('send_disc.txt', 'w', encoding='UTF-8')
            for man in mans:
                file.write(man)
            file.close()

    elif message.text.lower() == 'подписки-> выручка':
        with lock:
            file = open('рассылка_по_выручке.txt', 'r', encoding='UTF-8')
            mans = file.readlines()
            file.close()
            file = open('рассылка_по_выручке.txt', 'a', encoding='UTF-8')
            have = False
            new_man = str(message.chat.id)
            if len(mans) > 0:
                for i in range(0, len(mans)):
                    man = str(mans[i].strip())
                    if man == new_man:
                        have = True
                        break

            if have:
                file.close()
                markup_cancel_send_allmon = types.ReplyKeyboardMarkup(row_width=2)
                markup_cancel_send_allmon.add('Отписаться-> выручка')
                markup_cancel_send_allmon.add('Назад->')
                menu_markup = 'markup_cancel_send_allmon'
                bot.send_message(message.chat.id, 'Вы уже подписаны, отписаться?',
                                 reply_markup=markup_cancel_send_allmon)
            else:
                bot.send_message(message.chat.id, 'Вы добавлены в список рассылки')
                file.write(new_man + '\n')
                file.close()
    elif message.text.lower() == 'подписки-> скидки':
        with lock:
            file = open('send_disc.txt', 'r', encoding='UTF-8')
            mans = file.readlines()
            file.close()
            file = open('send_disc.txt', 'a', encoding='UTF-8')
            have = False
            new_man = str(message.chat.id)
            if len(mans) > 0:
                for i in range(0, len(mans)):
                    man = str(mans[i].strip())
                    if man == new_man:
                        have = True
                        break

            if have:
                file.close()
                markup_cancel_send = types.ReplyKeyboardMarkup(row_width=2)
                markup_cancel_send.add('Отписаться->скидки')
                markup_cancel_send.add('Назад->')
                menu_markup = 'markup_cancel_send'
                bot.send_message(message.chat.id, 'вы уже подписаны, отписаться?', reply_markup=markup_cancel_send)
            else:
                bot.send_message(message.chat.id, 'Вы добавлены в список рассылки')
                file.write(new_man + '\n')
                file.close()

    elif message.text.lower() == 'отчёт->скидки' or message.text.lower() == 'отчет->скидки':  # Вывод отчёта по скидкам
        with lock:
            f = open('Скидки.txt', 'r', encoding="utf-8")
            a = f.read()
            f.close()
            if len(a) != 0:
                bot.send_message(message.chat.id, a)
            else:
                bot.send_message(message.chat.id, 'Отчёт пуст')

    elif message.text.lower() == 'отчёт->операции' or message.text.lower() == 'отчет->операции':
        # Вывод отчёта по операциям

        with lock:
            f = open('Операции.txt', 'r', encoding="utf-8")
            a = f.read()
            f.close()
        if len(a) != 0:
            bot.send_message(message.chat.id, a)
        else:
            bot.send_message(message.chat.id, 'Отчёт пуст')


def send_new_alarm(message, send_name):
    with lock:
        file = open(send_name, 'r', encoding='UTF-8')
        mans = file.readlines()
        file.close()
    for man in mans:
        manw = str(man).strip()
        bot.send_message(manw, message)


def send_func():
    while True:
        try:
            xml_work()
            time.sleep(int(config['settings']['delay']))
        except Exception as e:
            print(e)
        time.sleep(15)


def polling():
    try:
        bot.polling(none_stop=True)
    except Exception as e:
        print(e)
    time.sleep(15)


def xml_work():
    file = open('посл_скидка.txt', 'r', encoding='UTF-8')
    last_disc = file.read()
    file.close()
    addr = config['settings']['ip_addres']
    port = config['settings']['port']
    req = config['settings']['xml_request']
    resp = config['settings']['xml_response']
    log = config['settings']['log_rkeeper']
    pasw = config['settings']['pass_rkeeper']
    tem = f'xmltest.exe {addr}:{port} {req} {resp} / {log}:{pasw}'
    a = subprocess.run(tem, check=True, shell=True, cwd='a', stdout=subprocess.PIPE).stdout.decode(encoding='UTF-8')
    if 'Succes' in a:
        res = True
    else:
        res = False
    count = int(0)
    file_op = str(open('a/response.xml', 'r', encoding="utf-8").read())
    a = open('Операции.txt', 'w', encoding="utf-8")
    soup = BeautifulSoup(file_op, 'lxml')

    operations = soup.find_all('row')
    fop = []
    lists = []
    for operation in operations:
        if count == 0:
            a.write('*****ОПЕРАЦИИ*****' + '\n')
            count = + 1
        alp = operation.get('datetime')
        if operation.get('datetime') != '':
            # print(operation.get('datetime'), operation.get('operation'), operation.get('operator'))
            c = str(
                operation.get('datetime') + ' ' + operation.get('operation') + ' ' + operation.get('operator') + '\n')
            lists.append(c)
        fop.append(alp)
    first_op = sorted(fop)
    first_op_file = open('Первая_операция.txt', 'w', encoding='UTF-8')
    first_op_file.write(first_op[0])
    first_op_file.close()
    sort_list = sorted(lists)
    if len(sort_list) != 0:
        for st in sort_list:
            a.write(st)
    lists = []
    count = int(0)
    a.close()
    t = open('Скидки.txt', 'w', encoding="utf-8")
    discounts = soup.find_all('skidk')

    for discount in discounts:
        if count == 0:
            t.write('*****СКИДКИ*****' + '\n')
            count = + 1
        if discount.get('discount') != 0:
            for operation in operations:
                if operation.get('visit') == discount.get('visit'):
                    bolls = True
                    break
            c = str(operation.get('datetime') + ' ' + discount.get('discount') + ' ' + discount.get(
                'author') + ' ' + discount.get('sum') + ' ' + discount.get(
                'chargesource') + '\n')
            if last_disc == '':
                last_disc = operation.get('datetime')
            elif last_disc < operation.get('datetime'):
                bet = 'send_disc.txt'
                send_new_alarm(c, bet)
                last_disc = operation.get('datetime')
                print('последнее время', last_disc)
        lists.append(c)

    sort_list = sorted(lists)
    last_file = open('посл_скидка.txt', 'w', encoding='UTF-8')
    last_file.write(last_disc)
    if len(sort_list) != 0:
        for st in sort_list:
            t.write(st)
    t.close()
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
        с = str(f'На {time[0]} сумма выручки превысила {lim} рублей')
        bet = 'рассылка_по_выручке.txt'
        send_new_alarm(с, bet)
    file.write(str(summary))
    return res


p2 = threading.Thread(target=polling, args=())
p1 = threading.Thread(target=send_func, args=())
p2.start()
p1.start()
p2.join()
p1.join()

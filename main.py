import configparser
import time
import telebot
from telebot import types
import threading
import addons
import server

config = configparser.ConfigParser()  # создаём объекта парсера
config.read("settings.ini")  # читаем конфиг
lock = threading.RLock()
bot = telebot.TeleBot(config['settings']['token'], threaded=True)
menu_markup = 'markup_report'
markup_start = types.ReplyKeyboardMarkup(row_width=2)
markup_start.add('Привет')
markup_start.add('Подписки на расслыки')
markup_start.add('Отчёты')

markup_send_al = types.ReplyKeyboardMarkup(row_width=2)
markup_send_al.add('Подписки-> Автоотчёт общей смены')
markup_send_al.add('Подписки-> Тревожные действия')
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
          message.text)

    if message.text.lower() == 'привет':
        bot.send_message(message.chat.id, 'Дороу')

    elif message.text.lower() == 'создатель':
        bot.send_message(message.chat.id, 'Gupye, vk.com/gupye, +79788781055')

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

    elif message.text.lower() == 'отчёты':  # Вывод меню для получения отчёта
        markup_report = types.ReplyKeyboardMarkup(row_width=2)
        markup_report.add('Отчёт->Текущий баланс')
        markup_report.add('Отчёт->скидки')
        markup_report.add('Отчёт->расход блюд')
        markup_report.add('Отчёт->удаления')
        markup_report.add('Назад->')
        bot.send_message(message.chat.id, 'выберите тип отчёта', reply_markup=markup_report)
        menu_markup = 'markup_report'

    elif message.text.lower() == 'отчёт->расход блюд':  # Вывод отчёта по выручке
        send_rep('temp_reports/eaten_eat.txt', message)

    elif message.text.lower() == 'отчёт->удаления':  # Вывод отчёта по выручке
        send_rep('temp_reports/deleted_prech.txt', message)
        send_rep('temp_reports/deleted_check.txt', message)

    elif message.text.lower() == 'отчёт->скидки' or message.text.lower() == 'отчет->скидки':
        send_rep('temp_reports/discount.txt', message)

    elif message.text.lower() == 'отчёт->текущий баланс' or message.text.lower() == 'отчет->Текущий баланс':
        send_rep('temp_reports/current_money.txt', message)

    elif message.text.lower() == 'отписаться-> автоотчёт общей смены':
        del_subscription('subscrubers/end_of_shift_subs.txt', message)

    elif message.text.lower() == 'отписаться-> тревожные действия':
        del_subscription('subscrubers/Alarm_subs.txt', message)

    elif message.text.lower() == 'подписки-> автоотчёт общей смены':
        menu_markup = 'markup_cancel_send'
        subscription('subscrubers/end_of_shift_subs.txt', message, 'Отписаться-> Автоотчёт общей смены')

    elif message.text.lower() == 'подписки-> тревожные действия':
        menu_markup = 'markup_cancel_send'
        subscription('subscrubers/Alarm_subs.txt', message, 'Отписаться-> Тревожные действия')


def del_subscription(file_name, message):
    with lock:
        file = open(file_name, 'r', encoding='UTF-8')
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
        file = open(file_name, 'w', encoding='UTF-8')
        for man in mans:
            file.write(man)
        file.close()


def subscription(file_name, message, markup_up):
    markup_send_subs = types.ReplyKeyboardMarkup(row_width=2)
    markup_send_subs.add(markup_up)
    markup_send_subs.add('Назад->')
    with lock:
        file = open(file_name, 'r', encoding='UTF-8')
        mans = file.readlines()
        file.close()
        file = open(file_name, 'a', encoding='UTF-8')
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
            bot.send_message(message.chat.id, 'вы уже подписаны, отписаться?', reply_markup=markup_send_subs)
        else:
            bot.send_message(message.chat.id, 'Вы добавлены в список рассылки')
            file.write(new_man + '\n')
            file.close()


def send_rep(file_name, message, head=''):
    with lock:
        f = open(file_name, 'r', encoding="utf-8")
        a = f.read()
        a += head
        f.close()
        if len(a) != 0:
            bot.send_message(message.chat.id, a)


def start_server():
    server.server_pooling(bot, lock)


def check_buffer():
    with lock:
        file = open('temp_reports/buffer.txt', 'r', encoding='UTF-8')
        all_mess = file.read().split('\n')
        file.close()
        file = open('temp_reports/buffer.txt', 'w', encoding='UTF-8')
        file.close()
        clast = str()
    if len(all_mess) != 0:
        for al in all_mess:
            if "ienevade_point" not in al:
                clast += (al + '\n')
            else:
                raw = al.split('[')
                all_man = raw[1].split(',')
                for man in all_man:
                    ser = str(man)
                    sers = ser.strip(']').strip(' ').strip("'").strip("\\n")
                    bot.send_message(sers, clast)
                    clast = str()


def polling():
    global bot
    while True:
        if addons.check_connection():
            try:
                check_buffer()
                bot.polling(none_stop=True)

            except Exception as e:
                print(e)
                continue
        else:
            time.sleep(10)


p3 = threading.Thread(target=start_server, args=())
p2 = threading.Thread(target=polling, args=())
p3.start()
p2.start()
p3.join()
p2.join()

import configparser
import requests


def send_new_alarm(message, send_filename, bot, lock):
    with lock:
        file = open(send_filename, 'r', encoding='UTF-8')
        mans = file.readlines()
        file.close()
    for man in mans:
        manw = str(man).strip()
        if check_connection():
            with lock:

                file = open('text.txt', 'w', encoding='UTF-8')
                file.write(message)
                file.close()
            image_send(bot, manw)
        else:
            with lock:
                file = open('temp_reports/buffer.txt', 'a', encoding='UTF-8')
                file.write(message + 'ienevade_point' + str(mans) + '\n')
                break


def check_connection():
    try:
        req = requests.get("http://www.google.com")
        return True
    except:
        return False


def image_send(bot, chat, filed='text.txt'):
    config = configparser.ConfigParser()  # создаём объекта парсера
    config.read("settings.ini")
    split_lines = int(config['image']['split_lines'])
    file = open(filed, 'r', encoding='UTF-8')
    message = file.readlines()
    file.seek(0)
    count = 0

    mes = str()
    if len(message)>=split_lines:
        message.append(' ')
        for i in range(0, len(message)):
            mes += message[i]
            count += 1
            if count >= split_lines:
                count = 0
                bot.send_message(chat, f'<pre>{mes}</pre>', parse_mode='HTML')
                mes = ''
        if mes != '':
            bot.send_message(chat, f'<pre>{mes}</pre>', parse_mode='HTML')
    else:

        message.append(' ')
        for i in range(0, len(message)):
            mes += message[i]
        bot.send_message(chat, f'<pre>{mes}</pre>', parse_mode='HTML')
    file.close()

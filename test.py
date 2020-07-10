from bs4 import BeautifulSoup

import addons


def delcheck(text, bot, lock):
    soup = BeautifulSoup(text, 'lxml')
    delpre = soup.find('deletecheck')
    logper = soup.find('loginperson')
    time = delpre.get('time')
    table = delpre.get('table')
    name = logper.get('name')
    check = delpre.get('cheknumber')
    if len(open('temp_reports/deleted_check.txt', 'r', encoding='UTF-8').read()) == 0:
        format_text_delprech(time[0:10])
    strs = str(f'       Удаление чека\n'
               f'------------------------------\n')
    stre = str(f'{time} \n'
               f'официант {name}\n'
               f'Чек #{check}'
               f'Стол #{table}\n\n\n')
    file = open('temp_reports/deleted_check.txt', 'a', encoding='UTF-8')
    file.write(stre)
    file.close()
    addons.send_new_alarm(strs + stre, 'subscrubers/Alarm_subs.txt', bot, lock)

def format_text_delprech(day):
    file = open('temp_reports/deleted_check.txt', 'w', encoding='UTF-8')
    text = str(f'           Удалённые чеки\n\n         кассовый день {day}\n\n'
               f'----------------------------------------\n')
    file.write(text)
    file.close()
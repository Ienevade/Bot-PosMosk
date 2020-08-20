import subprocess

from bs4 import BeautifulSoup
import configparser
import addons

config = configparser.ConfigParser()  # создаём объекта парсера
config.read("settings.ini")  # читаем конфиг


def parse_disc_report():
    addr = config['settings']['ip_addres']
    port_xml = config['settings']['port_xml']
    req = "disc_req.xml"
    resp = "disc_report.xml"
    log = config['settings']['log_rkeeper']
    pasw = config['settings']['pass_rkeeper']
    tem = f'xmltest.exe {addr}:{port_xml} {req} {resp} / {log}:{pasw}'
    try:
        a = subprocess.run(tem, check=True, shell=True, cwd='a', stdout=subprocess.PIPE).stdout.decode(encoding='UTF-8')

        res = True
    except:
        res = False
    text = open("a/disc_report.xml", 'r', encoding="UTF-8").read()
    soup = BeautifulSoup(text, "lxml")
    count = soup.text
    asss = count.split("\n")
    tempmess = []
    endmess = str()
    firstmin = True
    count_cont = 0
    for i in range(0, len(asss) - 6):
        if count_cont > 0:
            count_cont -= 1
            continue
        if normal_str(asss[i]) == 'ok':
            tempmess.append(asss[i])
            if i < len(asss):
                if normal_str(asss[i + 1]) != 'ok':
                    if firstmin:
                        for a in tempmess:
                            endmess += centr(a) + '\n'
                    else:
                        endmess += centr2_disc(tempmess)
                    tempmess = []

        elif normal_str(asss[i]) == 'space':
            tempcnt = 0
            for d in range(i, len(asss) - 6):
                if normal_str(asss[d]) == 'space':
                    tempcnt += 1
                    if tempcnt >= 4:
                        count_cont = tempcnt - 1
                else:
                    break
            endmess += '\n'
        elif normal_str(asss[i]) == 'minus':
            firstmin = False
            endmess += asss[i] + '\n'
    endmessage = delete_space(endmess)
    open('temp_reports/discount.txt', 'w', encoding='UTF-8').write(endmessage)


def centr2_disc(text, four=True):
    a = str()
    firstword = True
    if len(text) == 3:
        for i in text:
            if firstword:
                if len(i) < 20:
                    i = i + " " * (21 - len(i))
                else:
                    i = i[0: 20] + ' '
                a += i
                firstword = False
            else:
                if len(i) < 8:
                    i = i + " " * (8 - len(i))
                else:
                    i = i[0: 7]
                a += i
        return a + '\n'
    else:
        for i in text:
            a += i
        return a + '\n'


def parse_del_report():
    # head = str()
    addr = config['settings']['ip_addres']
    port_xml = config['settings']['port_xml']
    req = "del_req.xml"
    resp = "del_report.xml"
    log = config['settings']['log_rkeeper']
    pasw = config['settings']['pass_rkeeper']
    tem = f'xmltest.exe {addr}:{port_xml} {req} {resp} / {log}:{pasw}'
    try:
        a = subprocess.run(tem, check=True, shell=True, cwd='a', stdout=subprocess.PIPE).stdout.decode(encoding='UTF-8')

        res = True
    except:
        res = False
    text = open("a/del_report.xml", 'r', encoding="UTF-8").read()
    soup = BeautifulSoup(text, "lxml")
    count = soup.text
    asss = count.split("\n")
    tempmess = []
    endmess = str()
    firstmin = True
    count_cont = 0
    for i in range(0, len(asss) - 6):
        if count_cont > 0:
            count_cont -= 1
            continue
        if normal_str(asss[i]) == 'ok':
            tempmess.append(asss[i])
            if i < len(asss):
                if normal_str(asss[i + 1]) != 'ok':
                    if firstmin:
                        for a in tempmess:
                            endmess += centr(a) + '\n'
                    else:
                        endmess += centr2_del(tempmess)
                    tempmess = []
        elif normal_str(asss[i]) == 'space':
            tempcnt = 0
            for d in range(i, len(asss) - 6):
                if normal_str(asss[d]) == 'space':
                    tempcnt += 1
                    if tempcnt >= 5:
                        count_cont = tempcnt - 1
                else:
                    break
            endmess += '\n'
        elif normal_str(asss[i]) == 'minus':
            firstmin = False
            endmess += asss[i] + '\n'
    endmessage = delete_space(endmess)
    open('temp_reports/deleted_check.txt', 'w', encoding='UTF-8').write(endmessage)


def centr2_del(text, four=True):
    if len(text) < 7: return text[0]
    a = f'{text[0]}\n' \
        f'{text[1]} {text[2]}\n' \
        f'{text[3]}{text[5]}\n' \
        f'{text[4]}{text[6]}\n'
    return a


def parse_eat_report():
    addr = config['settings']['ip_addres']
    port_xml = config['settings']['port_xml']
    req = "eat_req.xml"
    resp = "eat_report.xml"
    log = config['settings']['log_rkeeper']
    pasw = config['settings']['pass_rkeeper']
    tem = f'xmltest.exe {addr}:{port_xml} {req} {resp} / {log}:{pasw}'
    try:
        a = subprocess.run(tem, check=True, shell=True, cwd='a', stdout=subprocess.PIPE).stdout.decode(encoding='UTF-8')

        res = True
    except:
        res = False

    text = open("a/eat_report.xml", 'r', encoding="UTF-8").read()

    soup = BeautifulSoup(text, "lxml")
    count = soup.text
    asss = count.split("\n")
    tempmess = []
    endmess = str()
    firstmin = True
    count_cont = 0
    for i in range(0, len(asss) - 6):
        if count_cont > 0:
            count_cont -= 1
            continue
        if normal_str(asss[i]) == 'ok':

            tempmess.append(asss[i])
            if i < len(asss):
                # if normal_str(asss[i + 1]) == 'minus':
                #     endmess+= '\n'
                if normal_str(asss[i + 1]) != 'ok':
                    if firstmin:
                        for a in tempmess:
                            endmess += centr(a) + '\n'
                    else:
                        endmess += centr2_eat(tempmess)
                    tempmess = []

        elif normal_str(asss[i]) == 'space':
            tempcnt = 0
            for d in range(i, len(asss) - 6):
                if normal_str(asss[d]) == 'space':
                    tempcnt += 1
                    if tempcnt >= 5:
                        count_cont = tempcnt - 1
                else:
                    break
            endmess += '\n'
        elif normal_str(asss[i]) == 'minus':
            firstmin = False
            endmess += asss[i] + '\n'
    endmessage = delete_space_eat(endmess)
    open('temp_reports/eaten_eat.txt', 'w', encoding='UTF-8').write(endmessage)


def centr2_eat(text, four=True):
    a = str()
    secondword = True
    firstword = True
    if len(text) == 3:
        a += 15 * " "
        for i in text:
            if len(i) < 10:
                i = i + " " * (10 - len(i))

            else:
                i = i[0: 9]

            a += i
        return a + '\n'
    elif len(text) == 4:
        for i in text:
            if firstword:
                if len(i) < 4:
                    i = i + " " * (4 - len(i))
                else:
                    i = i[0: 14] + ' '
                a += i
                firstword = False
            elif not firstword and secondword:
                if len(i) < 23:
                    i = i + " " * (23 - len(i))
                else:
                    i = i[0: 22] + ' '
                a += i
                secondword = False
            elif not secondword:
                if len(i) < 8:
                    i = i + " " * (8 - len(i))
                else:
                    i = i[0: 7]
                a += i
        return a
    else:
        for i in text:
            a += i
        return a + '\n'


def parse_balance_report():
    addr = config['settings']['ip_addres']
    port_xml = config['settings']['port_xml']
    req = "balance_req.xml"
    resp = "balance_report.xml"
    log = config['settings']['log_rkeeper']
    pasw = config['settings']['pass_rkeeper']
    tem = f'xmltest.exe {addr}:{port_xml} {req} {resp} / {log}:{pasw}'
    try:
        a = subprocess.run(tem, check=True, shell=True, cwd='a', stdout=subprocess.PIPE).stdout.decode(encoding='UTF-8')
        print(a)
        res = True

    except:
        res = False
        print('неудалось')

    text = open("a/balance_report.xml", 'r', encoding="UTF-8").read()
    soup = BeautifulSoup(text, "lxml")
    count = soup.text
    asss = count.split("\n")
    tempmess = []
    endmess = str()
    firstmin = True
    count_cont = 0
    for i in range(0, len(asss) - 6):
        if count_cont > 0:
            count_cont -= 1
            continue
        if normal_str(asss[i]) == 'ok':
            tempmess.append(asss[i])
            if i < len(asss):
                if normal_str(asss[i + 1]) != 'ok':
                    if firstmin:
                        for a in tempmess:
                            endmess += centr(a) + '\n'
                    else:
                        endmess += centr2(tempmess)
                    tempmess = []

        elif normal_str(asss[i]) == 'space':
            tempcnt = 0
            for d in range(i, len(asss) - 6):
                if normal_str(asss[d]) == 'space':
                    tempcnt += 1
                    if tempcnt >= 3:
                        count_cont = tempcnt - 1
                else:
                    # endmess += '\n'
                    break
            endmess += '\n'
        elif normal_str(asss[i]) == 'minus':
            firstmin = False
            endmess += asss[i] + '\n'

    endmessage = delete_space_bal(endmess)

    open('temp_reports/current_money.txt', 'w', encoding='UTF-8').write(endmessage)


def delete_space(endmess):
    prop = False
    message = str()
    ten = endmess.split('\n')
    for i in range(0, len(ten) - 1):
        if prop:
            prop = False
            continue
        if normal_str(ten[i]) == 'space':

            if normal_str(ten[i + 1]) == 'space':
                prop = True
        elif normal_str(ten[i])=='minus':
            message += ('-'*40) + '\n'
            continue
        message += ten[i] + '\n'
    return (message)


def normal_str(stru):
    if stru == '':
        return 'space'
    elif "----------" in stru:
        return 'minus'
    else:
        return 'ok'


def centr2(text, four=True):
    a = str()
    firstword = True
    if len(text) == 3:
        a += 15 * " "
        for i in text:
            if len(i) < 10:
                i = i + " " * (10 - len(i))

            else:
                i = i[0: 9]

            a += i
        return a + '\n'
    elif len(text) == 4:
        for i in text:
            if firstword:
                if len(i) < 15:
                    i = i + " " * (15 - len(i))
                else:
                    i = i[0: 14] + ' '
                a += i
                firstword = False
            else:
                if len(i) < 9:
                    i = i + " " * (8 - len(i))
                else:
                    i = i[0: 8]
                a += i
        return a + '\n'
    else:
        for i in text:
            a += i
        return a + '\n'


def centr(text):
    fir = ((41 - len(text)) // 2) * " "
    sec = (41 - (len(fir) + len(text))) * " "
    a = fir + text + sec
    return a

def delete_space_bal(endmess):
    prop = False
    message = str()
    ten = endmess.split('\n')
    count_min = 0
    dva_prop = False
    for i in range(0, len(ten) - 1):
        if not dva_prop:
            if normal_str(ten[i]) == 'ok' and normal_str(ten[i + 1]) == 'minus':
                message += ten[i] + '\n' + '\n'
                continue
            if normal_str(ten[i]) == 'minus':
                count_min += 2
            if count_min == 2:
                dva_prop = True
            if prop:
                prop = False
                continue
            if normal_str(ten[i]) == 'space':

                if normal_str(ten[i + 1]) == 'space':
                    prop = True
            elif normal_str(ten[i]) == 'minus':
                message += ('-' * 40) + '\n'
                continue
        else:
            if normal_str(ten[i]) == 'space':
                continue
            elif normal_str(ten[i]) == 'minus':
                message += ('-' * 43) + '\n'
                continue
        if normal_str(ten[i])=='minus':
            message += ('-'*40) + '\n'
            continue
        message += ten[i] + '\n'
    return message


def delete_space_eat(endmess):
    prop = False
    message = str()
    ten = endmess.split('\n')
    count_min = 0
    dva_prop = False
    for i in range(0, len(ten) - 1):
        if not dva_prop:
            if normal_str(ten[i]) == 'ok' and normal_str(ten[i + 1]) == 'minus':
                message += ten[i] + '\n' + '\n'
                continue
            if normal_str(ten[i]) == 'minus':
                count_min += 2
            if count_min == 2:
                dva_prop = True
            if prop:
                prop = False
                continue
            if normal_str(ten[i]) == 'space':

                if normal_str(ten[i + 1]) == 'space':
                    prop = True
        else:
            if normal_str(ten[i]) == 'space':
                continue

        message += ten[i] + '\n'
    return message

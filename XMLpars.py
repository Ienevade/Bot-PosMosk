from bs4 import BeautifulSoup
import subprocess




def xmlpars():
    file = open('посл_скидка.txt', 'r', encoding='UTF-8')
    last_disc = file.read()
    file.close()
    a = open('a/as1.bat').read()
    try:
        subprocess.run(a, check=True, shell=True, cwd='a')
        print('Отчёт взят')

    except:
        print('Не получилось взять отчёт')
    count = int(0)
    operation = str(open('a/response.xml', 'r', encoding="utf-8").read())
    a = open('Операции.txt', 'w', encoding="utf-8")
    soup = BeautifulSoup(operation, 'lxml')
    operations = soup.find_all('row')
    lists = []
    for operation in operations:
        if count == 0:
            a.write('*****ОПЕРАЦИИ*****' + '\n')
            count = + 1

        if operation.get('datetime') != '':
            # print(operation.get('datetime'), operation.get('operation'), operation.get('operator'))
            c = str(
                operation.get('datetime') + ' ' + operation.get('operation') + ' ' + operation.get('operator') + '\n')
            lists.append(c)

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
                # send_new_alarm(c)
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
    print('отчёт сформирован')


if __name__ == '__main__':
    xmlpars()

from bs4 import BeautifulSoup

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
            else:
                bolls = False
        if bolls:
            c = str(operation.get('datetime') + ' ' + discount.get('discount') + ' ' + discount.get(
                    'author') + ' ' + discount.get('sum') + ' ' + discount.get(
                    'chargesource') + '\n')
        else:
             c = str(discount.get('shiftdate') + ' ' + discount.get('discount') + ' ' + discount.get(
                        'author') + ' ' + discount.get('sum') + ' ' + discount.get(
                        'chargesource') + '\n')
    lists.append(c)

sort_list = sorted(lists)

if len(sort_list) != 0:
    for st in sort_list:
        t.write(st)
t.close()
print('отчёт сформирован')

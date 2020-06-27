Взаимодействие с кассовым сервером с помощью XML запросов-ответов
Надо
1) добавить интерфейс "XML Interface for Windows" на закладку "Устройства" у сервера и выставить порт
2) создать активный элемент в справочнике "Интерфейсы"
3) Можно создать свои макеты по образцам макетов, содержащих в названии XML
4) Вызывать через RK7XML.dll, интерфейсный модуль RK7XMLi.pas

  Функция CallRK7XMLRPC Параметры:
  AddressName - адрес:порт
  Request - XML запрос
  RequestSize - длина XML запроса
  ResultFile - имя файла, куда свалить результат
  ErrorBuf - куда можно записать ошибку связи и т.п.
  ErrorBufSize - размер ErrorBuf

  Функция CallRK7XMLRPCToStream - то же самое, но результат пишет в IStream
  Параметры:
  AddressName - адрес:порт
  Request - XML запрос
  RequestSize - длина XML запроса
  ResultStream - IStream - поток, куда свалить результат
  ErrorBuf - куда можно записать ошибку связи и т.п.
  ErrorBufSize - размер ErrorBuf

  Функция SetUseTempFileLimit - задать лимит, при большем размере результата будет создан временный файл. По умолчанию - 1000000.

  Функция GetDLLVersion - получить версию DLL

  Функция SetCryptKey - установить ключ для шифрования (может быть разный для разных кассовых серверов, устанавливается в параметре XML интерфейса)


Версия протокола 2 предназначена для осуществления контроля за выполнением команд сервером. В прошлой версии было невозможно узнать, выполнился ли последний запрос, если возникал разрыв связи после начала обработки запроса.
Сейчас для этого существует новые функции GetLastXMLResult и GetLastXMLResultToStream. Если ответ после выполнения запроса не удалось отправить, он хранится на сервере вплоть до специального запроса (при вызове этих функций) или до следующего запроса. Если ответ был успешно отослан, он на сервере не хранится. В любом случае всегда можно узнать номер последнего выполненного запроса (для конкретного ConnectName).

ConnectName - произвольная Null-terminated строка - идентификатор коннекта
RequestNum - последовательный номер запроса, ведётся по кждому идентификаотру коннекта отдельно. Надо передвать 0, иначе будет использован переданный номер запроса.

function CallRK7XMLRPC2(AddressName: PChar; ConnectName:PChar;
  Request: PChar; RequestSize: integer;
  var RequestNum: DWord; //в обе стороны. Если 0, то генерируется сервером.
  ResultFile: PChar;
  ErrorBuf: PChar; ErrorBufSize: integer):BOOL;stdcall;
function CallRK7XMLRPCToStream2(AddressName: PChar; ConnectName,
  Request: PChar; RequestSize: integer;
  var RequestNum: DWord; //в обе стороны. Если 0, то генерируется сервером.
  ResultStream: IStream;
  ErrorBuf: PChar; ErrorBufSize: integer):BOOL;stdcall;
function GetLastXMLResult(AddressName: PChar; ConnectName:PChar;
  out RequestNum: DWord; //всегда возвращается номер последнего выполненного запроса
  ResultFile: PChar; //результат заполнен, если была ошибка передачи данных результата, после успешной передачи стирается
  ErrorBuf: PChar; ErrorBufSize: integer):BOOL;stdcall;
function GetLastXMLResultToStream(AddressName: PChar; ConnectName: PChar;
  out RequestNum: DWord; //всегда возвращается номер последнего выполненного запроса
  ResultStream: IStream; //результат заполнен, если была ошибка передачи данных результата, после успешной передачи стирается
  ErrorBuf: PChar; ErrorBufSize: integer):BOOL;stdcall;

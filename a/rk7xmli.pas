unit rk7xmli;

interface

uses windows,activex;

function CallRK7XMLRPC(AddressName: PChar; Request: PChar;
  RequestSize: integer; ResultFile: PChar;
  ErrorBuf: PChar; ErrorBufSize: integer):BOOL;stdcall;
function CallRK7XMLRPCToStream(AddressName: PChar; Request: PChar;
  RequestSize: integer; ResultStream: IStream;
  ErrorBuf: PChar; ErrorBufSize: integer):BOOL;stdcall;
procedure SetUseTempFileLimit(aLimit:integer);stdcall;
function GetDLLVersion:integer;stdcall;
procedure SetCryptKey(Key:PChar);stdcall;//начиная с версии 134 (1.3.4.4)
//версия протокола 2:
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

implementation

function CallRK7XMLRPC(AddressName: PChar; Request: PChar;
  RequestSize: integer; ResultFile: PChar;
  ErrorBuf: PChar; ErrorBufSize: integer):BOOL;external 'RK7XML.dll';
function CallRK7XMLRPCToStream(AddressName: PChar; Request: PChar;
  RequestSize: integer; ResultStream: IStream;
  ErrorBuf: PChar; ErrorBufSize: integer):BOOL;stdcall;external 'RK7XML.dll';
procedure SetUseTempFileLimit(aLimit:integer);stdcall;external 'RK7XML.dll';
function GetDLLVersion:integer;stdcall; external 'RK7XML.dll';
function CallRK7XMLRPC2(AddressName: PChar; ConnectName:PChar;
  Request: PChar; RequestSize: integer;
  var RequestNum: DWord; //в обе стороны. Если 0, то генерируется сервером.
  ResultFile: PChar;
  ErrorBuf: PChar; ErrorBufSize: integer):BOOL;stdcall; external 'RK7XML.dll';
function CallRK7XMLRPCToStream2(AddressName: PChar; ConnectName,
  Request: PChar; RequestSize: integer;
  var RequestNum: DWord; //в обе стороны. Если 0, то генерируется сервером.
  ResultStream: IStream;
  ErrorBuf: PChar; ErrorBufSize: integer):BOOL;stdcall; external 'RK7XML.dll';
function GetLastXMLResult(AddressName: PChar; ConnectName:PChar;
  out RequestNum: DWord; //всегда возвращается номер последнего выполненного запроса
  ResultFile: PChar; //результат заполнен, если была ошибка передачи данных результата, после успешной передачи стирается
  ErrorBuf: PChar; ErrorBufSize: integer):BOOL;stdcall; external 'RK7XML.dll';
function GetLastXMLResultToStream(AddressName: PChar; ConnectName: PChar;
  out RequestNum: DWord; //всегда возвращается номер последнего выполненного запроса
  ResultStream: IStream; //результат заполнен, если была ошибка передачи данных результата, после успешной передачи стирается
  ErrorBuf: PChar; ErrorBufSize: integer):BOOL;stdcall; external 'RK7XML.dll';
procedure SetCryptKey(Key:PChar);stdcall; external 'RK7XML.dll';

end.

unit rkXMLConst;

interface

// "!" в комментарии означает обязательность атрибута
// Q... - для запросов
// R... - для ответов

const
  QueryMainTag='RK7Query';

  {--> Выполнить одну команду }
  QueryCMDTag='RK7CMD'; 
    QAttrCmdName='CMD'; // Команда, значения QCmd...
    QAttrReqSysVer = 'ReqSysVer'; //Требуемая версия обработки
  {<-- Выполнить одну команду }

  {--> Выполнить много команд за один раз }
  QTagRK7Command='RK7Command';// c 7.3.4.0 вложенный тэг в RK7Query - может быть много
    //QAttrCmdName='CMD'; // Команда, значения QCmd...
  {<-- Выполнить много команд за один раз }

  ResultMainTag='RK7QueryResult';
    RAttrProcessed='Processed';// c 7.3.4.0 количество успешно выполненных (не откатанных) команд (в случае QueryCMDTag 1 или 0)
    RAttrStatus='Status';
      RStatusOk='Ok';
      RStatusNoChanges = 'No changes'; // Если с предыдущего запроса xml не изменился (с версии 2)
      RStatusStarted='Execution Started';
      RStatusQueryParseError='Query Parse Error';
      RStatusBadParameters='Bad Query Parameters';
      RStatusQueryExecutingError='Query Executing Error';
      RStatusResultWritingError='Result Writing Error';
      RStatusResultInternalError='Query Processing Internal Error';
    RAttrErrorText='ErrorText';
    RAttrRK7ErrorN='RK7ErrorN';
    RAttrServerVersion='ServerVersion';//c 7.3.3.3
  RTagCommandResult='CommandResult';//c 7.3.4.0 вложенный в ResultMainTag, если используется QTagRK7Command, а не QueryCMDTag
    RAttrCmdName = QAttrCmdName;
    //RAttrStatus='Status';
    //RAttrErrorText='ErrorText';
    //RAttrRK7ErrorN='RK7ErrorN';
    RAttrWorkTime='WorkTime';

  {Запросы информации Общие для кассового сервера и сервера отчётов (с 7.3.3.18)}
  QCmdGetSystemInfo='GetSystemInfo';
    //возвраты
    RTagInfo = 'SystemInfo';
     RAttrCashServVer = 'CashServerVersion';
     RAttrSystemTime  = 'SystemTime';
     RAttrShiftDate   = 'ShiftDate';
     RAttrNetName = 'NetName';
     RAttrReqSysVer = QAttrReqSysVer;
  QCmdGetReferenceList='GetRefList';// Получить список коллекций
    // No parameters
    //возврат
    RTagReferencesList = 'RK7RefList';
      RTagReference = 'RK7Reference';
        RAttrReferenceName = 'RefName';
        RAttrDataVersion = 'DataVersion';
        RAttrCount='Count';

  QCmdGetReferenceData='GetRefData';// Получить коллекцию
    QAttrReferenceName='RefName';// ! Название коллекции
    QAttrRefItemIdent='RefItemIdent';// с 7.1.17.10 Идентификатор элемента (если надо запросить один элемент), если задан, то атрибуты тэга RK7Reference не пишутся, маска (см. QAttrPropMask) задаётся для свойств элемента (а не коллекции!)
    QAttrPropMask='PropMask';// с 7.1.17.10 Маска свойств - можно запроить ограниченный список свойств. * - все свойства, пусто - ничего. Для вложенных объектов необходимо указывать полный путь к свойству, либо использовать круглые скобки для общего префикса - свойства типа объект. Для перечисления свойств элементов коллекции нужно использовать свойство "items.(...)"  или "{...}". В случае использования фигурных скобок свойства самой коллекции необходимо перечислить до свойств элементов. Например: "*,RIChildItems.(!AltName),{Name}"
    QAttrWithMacroProp='WithMacroProp'; // 7.3.2.16 - если 1, то добавлять генерируемые свойства
    QAttrMacroPropTags='MacroPropTags'; // 7.4.2.17 - если 1, то добавлять генерируемые свойства подтэгами PropXXX, где XXX общая часть имени подсвойства (до ^)
    QAttrWithChildItems='WithChildItems';// 7.3.3.0 - если 0-без дочерних элементов, 1 - только иерархия внутри справочника в разделе RIChildItems коллекции, 2 - дети в разделе items только из других справочников, 3 - и иерархия внутри справочника и дети из других справочников в разделе RIChildItems коллекции. Добавляется псевдосвойство RIChildItems, может использоваться в маске. Тэги детей совпадают с именами классов
    QAttrIgnoreEnums='IgnoreEnums';// 7.3.3.0 - если 0 - перечисляемые типы как строки, 1 - перечисляемые типы и их множества как числа
    QAttrIgnoreDefaults='IgnoreDefaults';// 7.3.3.2 - если 1 - не писать аттрибуты, если значения свойств "по умолчанию"
    QAttrOnlyActive='OnlyActive';//7.4.2.0 - если 1 пишутся только активные элементы

    //назад
    RAttrBlobNames='BlobNames';//список имён BLOB полей
    RTagItems='Items';
      RTagItem='Item';
        RAttrIdent='Ident';
    RTagChildItems='RIChildItems';
    RTagPropPrefix='Prop';//с 7.4.2.17 Если MacroPropTags=1 - префикс имени подтэга генерируемых свойств
      RTagProperty='Property';//Тэг внутри тэга генерируемого свойства
        //RAttrIdent='Ident'; - идентификатор генерируемого свойства (идентификатор модифицирующего объекта)
        RAttrValue='Value';// значение генерируемого свойства
  //QCmdGetRefItemBlob='GetRefItemBlob'; - устаревший // с 7.1.17.0 Получить BLOB значение элемента коллекции - возвращается текстом (возможно, закодированным base64)
    //QAttrReferenceName='RefName';// ! Название коллекции
    //QAttrRefItemIdent='RefItemIdent';// ! Идентификатор элемента
    //QAttrEncodeBase64='EncodeBase64';// если 1 то надо кодировать base64, если 0 или не задано - не кодируется. Не рекомендуется использовать 0, так как не ANSI символы ломают XML (он не раскодируется как UTF-8)
  QCmdGetItemBlob='GetItemBlob';// с 7.3.4.0 Получить BLOB значение элемента коллекции - возвращается текстом закодированным base64
    //QAttrReferenceName='RefName';// ! Название коллекции
    //QAttrRefItemIdent='RefItemIdent';// ! Идентификатор элемента
    QAttrEncodeBase64='EncodeBase64';// если 1 или не задано(отличие от устаревшего QCmdGetRefItemBlob), то надо кодировать base64, если 0 - не кодируется. Не рекомендуется использовать 0, так как не ANSI символы ломают XML (он не раскодируется как UTF-8)
    QAttrRefBlobName='RefBlobName';// Имя BLOB (поля), если не задано - берётся первое
    QAttrUnpackedBlob='UnpackedBlob';// если 1 - блоб распакуется, если хранится в сжатом виде

  { --> Работа с файлами с 7.3.4.0, общие для кассового сервера и сервера отчётов }
  QCmdGetFile='GetFile'; //Содержимое файла внутри тэга результата
    QAttrPathName='PathName';// ! имя файла с относительным путём
    QAttrFileOffset='FileOffset';
    QAttrFileSize='FileSize';
  QCmdGetDirectory='GetDirectory'; //Содержимое директории
    //QAttrPathName='PathName';// ! имя директории с относительным путём
    QAttrFileMask='FileMask'; // необязательная маска, по умолчанию *.*
    QAttrWithContent='WithContent'; // при значении 1 внутри RTagFile содержимое файла
    //возврат
    RTagFile='File';
      RAttrFileName='FileName';
      RAttrSize='Size';
      RAttrDate='Date';//YYYYMMDD
      RAttrTime='Time';//HH:MM:SS
  QCmdPutFile='PutFile'; //Содержимое файла внутри тэга
    //QAttrPathName='PathName';// ! имя файла с относительным путём
    //QAttrFileOffset='FileOffset'; при значении -1(по умолчанию) файл полностью заменяется, при знчении 0 перекрывается начало
  QCmdDelFile='DelFile'; //Содержимое файла внутри тэга
    //QAttrPathName='PathName';// ! имя файла с маской и относительным путём
    //возврат
    RAttrFilesProcessed='FilesProcessed';// количество удалённых файлов
  { <-- Работа с файлами }

    

implementation
end.
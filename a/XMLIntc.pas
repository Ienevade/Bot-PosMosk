unit XMLIntc;

interface
// ВАЖНО: Комментарии в этом файле не являются комментариями, а используются с
//        целью исключения дублированности 

// "!" в комментарии означает обязательность атрибута
// Q... - для запросов
// R... - для ответов

const
(* Перенесенo в rkXMLConst
  QueryMainTag='RK7Query';
  QueryCMDTag='RK7CMD'; // только для одной команды
    QAttrCmdName='CMD'; //Значения QCmd...
    QAttrReqSysVer = 'ReqSysVer'; //Требуемая версия обработки
  QTagRK7Command='RK7Command';// c 7.3.4.0 вложенный тэг в RK7Query - может быть много
    //QAttrCmdName='CMD'; //Значения QCmd...

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
    RAttrErrorText='ErrorText';
    RAttrRK7ErrorN='RK7ErrorN';
    RAttrServerVersion='ServerVersion';//c 7.3.3.3
  RTagCommandResult='CommandResult';//c 7.3.4.0 вложенный в ResultMainTag, если используется QTagRK7Command, а не QueryCMDTag
    RAttrCmdName = QAttrCmdName;
    //RAttrStatus='Status';
    //RAttrErrorText='ErrorText';
    //RAttrRK7ErrorN='RK7ErrorN';
    RAttrWorkTime='WorkTime';

//   *** Команды ***

      {Запросы информации Общие для кассового сервера и сервера отчётов (с 7.3.3.18)}
      QCmdGetSystemInfo='GetSystemInfo';
        //возвраты
        RTagInfo = 'SystemInfo';
         // RAttrCashServVer = 'CashServerVersion';
         // RAttrSystemTime  = 'SystemTime';
         // RAttrShiftDate   = 'ShiftDate';
         RAttrNetName = 'NetName';
         RAttrReqSysVer = QAttrReqSysVer;
         RCash = 'Cash';                // Текущаем кассовая станция (при запросе к кассе), refItem   
         RCashGroup = 'CashGroup';      // Текущий кассовый сервер, refItem   
         RRestaurant = 'Restaurant';    // Текущий ресторан, refItem   
      QCmdGetReferenceList='GetRefList';// Получить список коллекций
        // No parameters
        //возврат
        RTagReferencesList = 'RK7RefList';
          RTagReference = 'RK7Reference';
            RAttrReferenceName = 'RefName';
            RAttrDataVersion = 'DataVersion';
            //RAttrCount='Count';
      QCmdGetReferenceData='GetRefData';// Получить коллекцию
        QAttrReferenceName='RefName';// ! Название коллекции
        QAttrRefItemIdent='RefItemIdent';// с 7.1.17.10 Идентификатор элемента (если надо запросить один элемент), если задан, то атрибуты тэга RK7Reference не пишутся, маска (см. QAttrPropMask) задаётся для свойств элемента (а не коллекции!)
        QAttrPropMask='PropMask';// с 7.1.17.10 Маска свойств - можно запроить ограниченный список свойств. * - все свойства, пусто - ничего. Для вложенных объектов необходимо указывать полный путь к свойству, либо использовать круглые скобки для общего префикса - свойства типа объект. Для перечисления свойств элементов коллекции нужно использовать свойство "items.(...)"  или "{...}". В случае использования фигурных скобок свойства самой коллекции необходимо перечислить до свойств элементов. Например: "*,RIChildItems.(!AltName),{Name}"
        QAttrWithMacroProp='WithMacroProp'; // 7.3.2.16 - если 1, то добавлять генерируемые свойства
        QAttrWithChildItems='WithChildItems';// 7.3.3.0 - если 0-без дочерних элементов, 1 - только иерархия внутри справочника в разделе RIChildItems коллекции, 2 - дети в разделе items только из других справочников, 3 - и иерархия внутри справочника и дети из других справочников в разделе RIChildItems коллекции. Добавляется псевдосвойство RIChildItems, может использоваться в маске. Тэги детей совпадают с именами классов
        QAttrIgnoreEnums='IgnoreEnums';// 7.3.3.0 - если 0 - перечисляемые типы как строки, 1 - перечисляемые типы и их множества как числа
        QAttrIgnoreDefaults='IgnoreDefaults';// 7.3.3.2 - если 1 - не писать аттрибуты, если значения свойств "по умолчанию"
        QAttrOnlyActive='OnlyActive';//с 7.4.2.0 - если 1 пишутся только активные элементы
        QAttrMacroPropTags='MacroPropTags'; // 7.4.2.17 - если 1, то добавлять генерируемые свойства подтэгами PropXXX, где XXX общая часть имени подсвойства (до ^)
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
        RTagChildItems='RIChildItems';
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
      { <-- Работа с файлами }*)

{
    <xs:complexType name="refitem">
      <xs:choice>
        <xs:attribute name="id" type="xs:positiveInteger"/>
        <xs:attribute name="code" type="xs:positiveInteger"/>
      </xs:choice>
    </xs:complexType>
}
      // Получить информацию о системе (ver 2)
      QCmdGetSystemInfo2 = 'GetSystemInfo2';
        RTagInfo = 'SystemInfo';
//       RAttrRestCode  = 'RestCode';
         RAttrProcessID = 'ProcessID';
         RCash = 'Cash';           // Текущаем кассовая станция (при запросе к кассе), refItem
         RCashGroup = 'CashGroup'; // Текущий кассовый сервер, refItem
         RRestaurant= 'Restaurant';// Текущий ресторан, refItem
         RCommonShift = 'CommonShift';
//         RAttrShiftDate   = 'ShiftDate';  // Логическая дата, dateTime
           RAttrShiftNum    = 'ShiftNum';   // Номер общей смены
           RAttrShiftStartTime = 'ShiftStartTime'; // Начало общей смены, dateTime

      {Запросы информации только кассовый сервер}
      {--> Получить значение параметра }
      QCmdGetParamValue = 'GetParamValue';
        QAttrParamName = 'ParamName';    // ! Системное имя параметра
//      QAttrVisitID = 'VisitID';        // ID визита
//      QAttrOrderID = 'OrderID';        // ID заказа
//      QAttrDateTime    = 'DateTime';   // Время, на которое нужно получить значение параметра (dd.mm.yyyy hh:mm или YYYYMMDD hh:mm)
        QAttrStationID   = 'StationID';  // ID станции, если не задан то используется StationCode
        QAttrStationCode = 'StationCode';// Код станции
        QAttrWaiterID   = 'WaiterID';    // ID официанта, если не задан, то используется WaiterCode
        QAttrWaiterCode = 'WaiterCode';  // Код официанта
        QAttrTableID   = 'TableID';      // ID стола, если не задан, то используется TableCode
        QAttrTableCode = 'TableCode';    // Код стола
        QAttrGuestTypeID  = 'GuestTypeID';  // ID типа гостей, если не задан, то используется GuestTypeCode
        QAttrGuestTypeCode= 'GuestTypeCode';// Код типа гостей


        // Ответный xml
        RAttrParamName = QAttrParamName;
        RAttrParamValue = 'Value'; // Значение параметра
      {<-- Получить значение параметра }

      {--> Получить текущее значение для использования }
      QCmdGetUsageValue = 'GetUsageValue';
        QAttrUsageName = 'name';         // ! Имя использования
        QAttrUsageParam = 'param';       // Параметр для использования
//      QAttrDateTime    = 'dateTime';   // Время, если не задано то текущее
//      QOrder          = 'Order';       // Заказ, orderElement
//      QStation      = 'Station';       // Станция, refItem
//      QWaiter           = 'Waiter';    // Работник, refItem
//      QTable        = 'Table';         // Стол, refitem
//      QGuestType    = 'GuestType';     // Тип гостей, refitem
        // Ответный xml
        RAttrUsageName = 'name';    // Имя использования
        RAttrUsageParam = 'param';  // Параметр для использования
        RUsageValue = 'Value'; // Выбранный объект, refItem
      {<-- Получить значение параметра }

      {-->  Обработка MCR алгоритма }
      QCmdParseMCR = 'ParseMCR';
        QAttrData = 'data'; // Текстовые данные
      // Ответный xml
        RMcrItemTag = 'Item';
//        RAttrCardCode = 'cardCode'; //! Код карты
          RAttrScope = 'scope';       // Область, string
          RMCRItem = 'MCR';           // !MCR алгоритм
          RObjectItem = 'Object';     // Объект, refItem
      {<--  Обработка MCR алгоритма }


      QCmdGetOrders='GetOrders';//См. макет 12043 "Orders list for XML"
        //возврат
//        RTagOrderLists='OrdersList';
      QCmdGetReceipts='GetReceipts';
        //возврат
        RTagReceipts='ReceiptsList';
          RAttrCount='Count';
      QCmdGetReceiptList='GetReceiptList';
//      QAttrLineGuid = 'line_guid';         // Фильтр по guid чека
//      QROrder       = 'Order';             // Фильтр по заказу
//      RTagReceipts='ReceiptsList';
          RReceiptItem = 'Receipt';
//          QROrder       = 'Order';
            QRCloseStation= 'CloseStation';   // Станция, на которой оплачен чек, refItem
            QRPrintStation= 'PrintStation';   // Станция, на которой чек был распечатан, refItem
            QRCashier     = 'Cashier';        // Кассир, refItem
//          QRAttrLineGuid= 'lineguid';       // guid чека
            RsAttrCheckNum = 'checknum';      // Номер чека, int
            RAttrSum      = 'sum';            // Сумма чека, int
            RsAttrDeleteTime= 'deletetime';   // Время удаления чека, dateTime
            RsAttrPrintTime= 'printtime';     // Время печати чека, dateTime
            RsAttrStartDateTime= 'starttime'; // Время начала обслуживания чека, dateTime
            RsAttrBillTime = 'billtime';      // Время печати пречека, dateTime
            RAttrState    = 'state';          // Статус чека, int
//          QRAttrSeat    = 'seat';           // Номер посадочного места, int
            RDeleteManager = 'DeleteManager'; // Менеджер, удаливший чек, refItem
            RDeleteReason  = 'DeleteReason';  // Причина, на которую удален чек, refItem

      QCmdGetPrintLayout='GetPrintLayout'; // Получить данные для печати (результат через CDATA)
        QLayout = 'Layout';           // Макет печати, refItem
        QDocument = 'Document';       // Тип документа, refItem. Используется, если не задан Layout. Берется первый подходящий макет
        //QAttrEncodeBase64='EncodeBase64'; // Закодировать ответ в base64
//      QOrder  = 'Order';            // Заказ, orderElement
        QReceiptNum = 'ReceiptNum';   // Номер чека, int
          QAttrLayoutFilters='LayoutFilters'; // Фильтры макета вида <поле>=значение[{;<поле=значение>}]
          QAttrDataSourceParams='DataSourceParams'; // Параметры кубов вида <поле>=значение[{;<поле=значение>}]
          QAttrFileFormat  = 'format';      // Формат отчета: text, xml, xls

      QCmdGetDocByLayout='GetDocByLayout';// получить двнные по макету печати
//      QLayout = 'Layout';           // !Макет печати, refItem
//      QOrder  = 'Order';            // Заказ, orderElement
        QAttrReceiptNum='ReceiptNum'; // Номер чека, должен быть задан, если макет чека/пречека, либо c 7.1.17.10 можно задать QAttrOrderName или QAttrVisit+QAttrOrderIdent
        QAttrVisit='Visit';
        QAttrOrderIdent='OrderIdent';
        QAttrOrderName='OrderName'; // c 7.1.17.17 имя заказа, может быть задан вместо QAttrReceiptNum или QAttrVisit+QAttrOrderIdent
        //QAttrLayoutParams='LayoutParams'; Устаревший // Параметры отчёта вида <поле>=значение[{;<поле=значение>}]
//      QAttrLayoutFilters='LayoutFilters'; // c 7.3.4.0 фильтры макета вида <поле>=значение[{;<поле=значение>}]
//      QAttrDataSourceParams='DataSourceParams'; // c 7.3.4.0 Параметры кубов вида <поле>=значение[{;<поле=значение>}]
        QAttrTextReport='TextReport';// с 7.4.3.4 - при 1 выводить отчёт в виде текста (а не XML)
        //возврат
        RAttrLayoutResultTag='LayoutResult';
          RAttrLayoutCode='LayoutCode';
          RAttrLayoutFilters=QAttrLayoutFilters;
          RAttrDataSourceParams=QAttrDataSourceParams;

      { <-- Запросы информации }

      {Только кассовый сервер}
      QCmdDeleteReceipt='DeleteReceipt';
        //QAttrReceiptNum='ReceiptNum'; // ! Номер чека
        QAttrManagerPassword='ManagerPassword';// ! Пароль менеджера, на которого запишется удаление, не пустой
        QDeleteReason='DeleteReason'; // !Причина удаления чека, refItem
        QMaket = 'Maket'; // ! Представление документа для удаления чека, refItem
        QManager = 'Manager';//! Менеджер, на которого запишется удаление, refItem
      QCmdUndoReceipt='UndoReceipt';//Анулирование
        //PAttrReceiptNum='ReceiptNum'; !
        //QAttrManagerPassword='ManagerPassword';// ! Пароль менеджера, на которого запишется удаление, не пустой
        //QManager = 'Manager' //! Менеджер, на которого запишется аннулирование, refItem
        //QDeleteReason='DeleteReason'; // Причина аннулирования чека, refItem
        //QMaket = 'Maket'; // ! Представление документа для аннулирования чека, refItem
      QCmdWaiterMessage='WaiterMessage';//Послать сообщение официанту
//      QWaiter           = 'Waiter';     // !Работник, которому отсылается сообщение, refItem
//      QManager          = 'Manager';    // Менеджер, от имени которого посылается сообщение, refItem
        QRAttrText        = 'text';       // !Tекст сообщения
        QRAttrExpireTime  = 'expireTime'; // !Время жизни сообщения
        QRAttrParam       = 'param';      // Параметр для сообщения (для числового пейджера - 1 цифра)
        QRAttrMessageType = 'messageType';// Тип сообщения, string rkClass.MessageTypes
        // Ответный xml
        QRMessage         = 'Message';
          QRAttrMessageID = 'id';         // id сообщения
      QCmdGetWaiterMessages='GetWaiterMessages';//Получить список сообщений официанта
        QRWaiter          = 'Waiter';     // Официант, refitem
//      QRMessage         = 'Message';
//        RAttrMessageID  = 'id';         // id сообщения
//        QRAttrText      = 'text';       // Текст сообщения
//        QRAttrParam     = 'param';      // Параметр сообщения
          RAttrCreateTime = 'createTime'; // Время создания сообщения
//       QRAttrExpireTime = 'expireTime'; // Время устаревания сообщения
          RAttrRepeatCount= 'repeatCount';// Число повторений
//       QRAttrMessageType= 'messageType';// Тип сообщения
      QCmdDelWaiterMessages = 'DelWaiterMessages';// Удалить сообщения официанта (список id)
//      QRMessage         = 'Message';    // Сообщение
//        QRAttrMessageID = 'id';         // id сообщения

      {-->  Получить остаток по блюду }
      QCmdGetDishesRest = 'GetDishRest';
//      QDishItem     = 'Dish';       // Блюдо, refitem
        // xml-ответ
//      QAttrQuantity='quantity';   // ! Целое количество в тысячных долях
      {<--  Получить остаток по блюду }
      {-->  Получить список остатков блюд, включая запрещенные блюда }
      QCmdGetDishesRests = 'GetDishRests';
        // xml-ответ
      RDishRestItem = 'DishRest';           // Блюдо, refitem
//        RAttrQuantity='quantity';   // Количество (в тысячных долях)
        RAttrProhibited='prohibited'; // Флаг - блюдо запрещено к продаже
      {<--  Получить список остатков блюд, включая запрещенные блюда }

      {-->  Изменить остатки блюд }
      QCmdSetDishRests='SetDishRests';//с 7.3.3.0 Установить остатки блюд - внутри набор тэгов QDishRest
        QAuthor = 'Author'; // Работник, refItem
        QDishRest = 'DishRest';// Блюдо, refItem + unbounded
          QAttrQuantity = 'Quantity';//!Целое количество в тысячных долях
          QAttrProhibited = 'prohibited'; // Флаг - блюдо запрещено к продаже
      {<--  Изменить остатки блюд }
       
      QCmdSetDishRate='SetDishRate';//Добавить блюду рейтинг/комментарий
        //QAttrDishIdent  = 'DishIdent'; // ИД Блюда    (integer)
        QAttrGuestCode    = 'GuestCode'; // ИД Гостя    (string, необязательный)
        QAttrRating       = 'Rating';    // Рейтинг     (integer, 2 знака: 4,51 = 451, необязательный)
        //QAttrComment    = 'Comment';   // Комментарий (UTF8String, необязательный)
      QCmdProcessOperation='ProcessOperation';//с 7.3.4.5 Вызвать обработку операции сервером так, как будто операция была выполнена на кассе
        QAttrOperationIdent='OperationIdent';//! Ident операции
        QAttrParameter='Parameter';//Параметр операции
//      QAttrStationID   = 'StationID'; // ID станции
        QAttrPerson      = 'Person'; //Ident менеджера операции
        QAttrSessionUNI  = 'SessionUNI';
        //QAttrVisit='Visit'; // внутренний идентификатор визита, используется совместно с QAttrOrderIdent
        //QAttrOrderIdent='OrderIdent';// внутренний идентификатор заказа в визите, используется совместно с QAttrVisit
        QAttrMenuItemIdent='MenuItemIdent';// Идентификатор блюда
        //QAttrQuantity='Quantity';//Целое количество в тысячных долях
      { --> Команды для КДС  }
      QCmdKDSGetRefsData='KDSGetRefsData'; // Получить данные справочников
        QAttrDataBuildMode='BuildMode';
        QAttrXMLUOTFldName='UOTField';
        QAttrXMLTblFldName='TableField';
        QAttrXMLUseCharset='UseCharset';
      QCmdKDSGetDishData='KDSGetDishData'; // Получить данные заказов/блюд
      QCmdKDSSetDishData='KDSSetDishData'; // Задать данные заказов/блюд
      QCmdKDSSetDishFlag='KDSSetDishFlag'; // Задать данные заказов/блюд
        QAttrDishIdent = 'DishIdent'; // KDSIdent
        QAttrDishState = 'DishState'; // Состояние блюда (dsSent, dsInit, dsDone, dsTake)
        QAttrDishFlag  = 'DishFlag';  // Флаг блюда (kdfCanDelete)
        QAttrDishFlagValue = 'Value';
      QCmdKDSGetSystemInfo='KDSGetSystemInfo';// Запросить некоторую инфо
        //возврат
        RTagKDSInfo = 'KDSSystemInfo';
          RAttrCashServVer = 'CashServerVersion';
          RAttrSystemTime  = 'SystemTime';
          RAttrShiftDate   = 'ShiftDate';   //текущая дата смены YYYYMMDD, может быть 0, если не открыта
          RAttrShiftNumber = 'ShiftNumber'; //номер текущей общей смены, может быть 0, если не открыта
          RAttrRestCode    = 'RestCode';
          RBusunessPeriod   = 'BusinessPeriod'; // Бизнес период, refItem
      { <-- Команды для КДС  }
      { --> Команды для Brunswick }
      QCmdBrunswickData = 'VectorBrunswickData'; // Пришли данные от Brunswick Vector
        QAttrReceiptID  = 'receipt_id';   // ! Номер чека
        QAttrReceiptDate= 'receipt_date'; // ДатаВремя чека
        QAttrTotalMoney = 'total_money';  // ! The sum of the entire receipt, NOT including any transaction tax.
        QAttrTransactionTax = 'transaction_tax'; // ! The transaction tax supplied to the receipt. May be 0 if no transaction tax exists.
        QAttrTerminalID = 'terminal';     // ID терминала
        QAttrClerkID    = 'clerk';        // ID работника
        QAttrLane       = 'lane';         // ! Номер дорожки - Last lane bowled on (e.g. after a transfer). Внимание, стол ищется по дорожке только в рамках тарификационного устройства. Если устройство у стола задано, надо задать соответствующий DeviceCode, если не задано, DeviceCode должен быть не задан или 0
        QAttrDeviceCode = 'DeviceCode';   // Код тарификационного устройства, 0 или нет - устройство у стола не задано 
        QAttrGameSDate= 'GameStartDate';  // Дата начала игры YYYYMMDD или dd.mm.yyyy
        QAttrGameSTime= 'GameStartTime';  // Время началы игры hh:mm:ss
        QAttrGameEDate= 'GameEndDate';
        QAttrGameETime= 'GameEndTime';
      { <-- Команды для Brunswick }
      { --> Команды для Бронирования }
      QCmdAddReserv = 'AddReservation'; // Добавить бронь
        QAttrSource = 'Source';      // Источник брони (от кого пришла, integer)
        QReservations  = 'Reservations';//Внутри список детей (tag='Reserv') с атрибутами:
          QTagReserv = 'Reserv';
            QAttrReservID  = 'ID';          // ID брони
//          QAttrTableID   = 'TableID';     // ID стола (если не задан, используется HallID + TableName)
            QAttrStatus    = 'Status';      // Статус брони (для результатов бронирования)
                                            // 0 - Бронь ждет своей очереди
                                            // 1 - Бронь обслуживается
                                            // 2 - Бронь удалена по времени устаревания
                                            // 3 - Бронь отменена официантом
                                            // 4 - По заказу брони сделан пречек
                                            // 5 - Заказ брони оплачен и закрыт

            QAttrHallID    = 'HallID';      // ID плана зала
            QAttrTableName = 'TableName';   // Имя стола
            QAttrGuestsCount= 'GuestsCount'; // Кол-во гостей
            QAttrReservDate= 'ReservDate';  // Дата брони (YYYYMMDD или dd.mm.yyyy)
            QAttrReservTime= 'ReservTime';  // Время брони (hh:mm)
            QAttrReservDur = 'Duration';    // Длительность брони (в мин)
            QAttrClientName= 'ClientName';  // Имя клиента
            QAttrCardCode  = 'CardCode';    // Код ПДС карты клиента
            QAttrIntfCode  = 'IntfCode';    // Код интерфейса карты клиента (по умолчанию 1)
            QAttrIntfID    = 'IntfID';      // ID интерфейса карты клиента
            QAttrComment   = 'Comment';     // Комментарий
      ROrder = 'Order';
//      RAttrVisit = 'visit';
        RAttrOrderIdent = 'orderIdent';
      QCmdDelReserv = 'DelReservation'; // Удалить бронь (параметры как в AddReservation)
      QCmdGetReservRes = 'GetReservationResults';// Результаты бронирования
        RResResults = 'ResResults';
          RTagReserv = 'Reserv';
            RAttrReservID = QAttrReservID;     // ID брони
            RAttrStartTime = 'StartTime';
            RAttrOrderSum  = 'OrderSum';    // Сумма заказа брони}
            RAttrHallID    = QAttrHallID;
            RAttrTableName = QAttrTableName;
            RAttrReservDur = QAttrReservDur;
      { <-- Команды для Бронирования }

      QCmdCreateVisit  = 'CreateVisit'; // Создать визит
//      QGuestType    = 'GuestType';        // Тип гостей, refitem
//      QAttrPersistentComment='persistentComment';// Сохраняемый комментарий
//      QAttrNonpersistentComment='nonPersistentComment';// Несохраняемый комментарий
        QTagGuests       = 'Guests';        // Список гостей
//        QAttrGuestLabel= 'guestLabel';    // Метка гостя
//        QAttrCardCode  = 'cardCode';      // Код карты гостя
//        QAttrClientID  = 'clientID';      // id клиента, bigint
//        QAttrAddressID = 'addressID';     // id адреса доставки, bigint
//        QInterface  = 'Interface';        // Интерфейс к карте гостя, refitem
        // Ответный xml
        RAttrVisitID      = 'VisitID';      // ID добавленного визита
//      RAttrGuid         = 'guid';         // GUID добавленного визита

      QCmdCloseVisit      = 'CloseVisit'; // Закрыть визит
        QAttrVisitID = RAttrVisitID;    // ID закрываемого визита

      QCmdCreateOrder = 'CreateOrder'; // Создать заказ. Внутри список детей (tag='Order') с атрибутами:
//      QTable        = 'Table';      // Стол, refitem
//      QWaiter       = 'Waiter';     // Главный официант, refitem
//      QOrderType    = 'OrderType';  // Тип заказа, refitem
//      QOrderCategory= 'OrderCategory';// Категория заказа, refitem
//      QDefaulter    = 'Defaulter';  // Неплательщик, refitem
        QStation      = 'Station';    // !Станция, на которой создается заказ, refItem
//      QGuestType    = 'GuestType';  // Тип гостей, refitem
//      QAttrPromoCode= 'promoCode';  // Промокод, normilizedstring
//      QAttrPersistentComment='persistentComment';// Сохраняемый комментарий
//      QAttrNonpersistentComment='nonPersistentComment';// Несохраняемый комментарий
//      QTagGuests       = 'Guests';        // Список гостей
//        QAttrCardCode  = 'cardCode';      // Код карты гостя
//        QAttrClientID  = 'clientID';      // id клиента, bigint
//        QAttrAddressID = 'addressID';     // id адреса доставки, bigint
//        QInterface  = 'Interface';        // Интерфейс к карте гостя, refitem
        // Ответный xml
        RTagOrder = 'Order'; // Заказ
  //      RAttrVisitID      = 'VisitID';      // ID добавленного визита
          RAttrOrderID      = 'OrderID';      // ID добавленного заказа

    QCmdUpdateOrder = 'UpdateOrder'; // Обновить свойства заказа (визита)
//      QAttrVisit    = 'Visit';
//      QAttrOrderIdent='OrderIdent';
        QAttrExtSource= 'ExtSource';  // id-программы, создавшей заказ, int
        QAttrExtID    = 'ExtID';      // Внешний id заказа, для связки со сторонними системами, int
//      QTable        = 'Table';      // Стол, refitem
//      QWaiter       = 'Waiter';     // Главный официант, refitem
//      QOrderType    = 'OrderType';  // Тип заказа, refitem
//      QDefaulter    = 'Defaulter';  // Неплательщик, refitem
//      QGuestType    = 'GuestType';  // Тип гостей, refitem
//      QTagGuests       = 'Guests';  // Список гостей, итератор anyname
//        QAttrGuestLabel= 'guestLabel'; // Метка гостя
//        QAttrCardCode  = 'cardCode';// Код карты гостя
//        QAttrClientID  = 'clientID';      // id клиента, bigint
//        QAttrAddressID = 'addressID';     // id адреса доставки, bigint
//        QInterface  = 'Interface';  // Интерфейс к карте гостя, refitem
        QTagExtraTables = 'ExtraTables'; // Список дополнительных столов, итератор table
//      QAttrPersistentComment='persistentComment';// Сохраняемый комментарий, string
//      QAttrNonpersistentComment='nonPersistentComment';// Несохраняемый комментарий, string
                      
    {--> Запись содержимого заказа (устаревшая, использовать вместо нее SaveOrder) }
    QCmdWriteOrderData = 'WriteOrderData';
     QTagSession = 'Session';      // Пакет. Внутри список Dishes, таких тэгов может быть много
//     QAttrVisitID = 'VisitID';     // ! ID визита, возвращается после выполнения QCmdCreateOrder
//     QAttrOrderID = 'OrderID';     // ! ID заказа, возвращается после выполнения QCmdCreateOrder
       QAttrSessionID = 'SessionID'; // Если SessionID <> 0, то перезаписываем пакет, иначе добавляем новый
       QAttrIsDraft  = 'isDraft';    // Признак, что пакет является черновиком, boolean
       QAttrCourseCode = 'CourseCode';// Код порядка подачи, с которым будет добавлен пакет
       QAttrCourseID   = 'CourseID';  // ID порядка подачи. Если не задан, то используется CourseCode
                                        // ! обязательно либо QAttrStationCode либо QAttrStationID
//     QAttrStationCode = 'StationCode';// Код станции, от имени которой будет добавлен пакет
     //QAttrStationID   = 'StationID'; // ID станции, если не задан то используется StationCode
      QTagDishes = 'Dishes';          // Список блюд. Внутри список детей (tag = 'Dish')
                                        // ! обязательно либо QAttrItemID либо QAttrCode
       QAttrItemID      = 'ID';       // ID блюда
       QAttrCode        = 'Code';     // Код блюда (используется если не задан ID)
//      QAttrQuantity  = 'Quantity'; // ! Количество блюда (целое количество в тысячных долях)
       QAttrWeight      = 'Weight';   // Вес блюда (в тысячных долях), если задан, перекрывает количество
      QTagModifiers      = 'Modifiers';// Модификаторы блюда. Внутри список детей (tag = 'Modifier')
    // Ответный xml
//   RAttrOrderSum    = 'OrderSum'; // Сумма заказа
     RattrToPaySum    = 'ToPaySum'; // Сумма заказа к оплате
     RAttrPriceListSum= 'PriceListSum'; // Сумма по прейскуранту
     RCookMin         = 'CookMin';  // Время приготовления блюд заказа (максимальное из времён приготовления всех блюд)
     RTagSession      = 'Session'; // пакет
       //RAttrVisitID
       //RAttrOrderID
       RAttrSessionID = QAttrSessionID;
       //RAttrOpened
       RAttrStationID = QAttrStationID;
       RAttrStationCode = QAttrStationCode;
       RAttrStationName = 'StationName';
       RAttrCourseID = QAttrCourseID;
       RAttrCourseCode = QAttrCourseCode;
       RAttrCourseName = 'CourseName';
    {<-- Запись содержимого заказа }
    QCmdCloseCommonShift = 'CloseCommonShift';
      //QAttrManagerCode = 'ManagerCode';// Код менеджера
      //QAttrManagerID='ManagerID';// Код менеджера
      QRManager = 'Manager';
      QAttrCloseAnyCase='CloseAnyCase';//1-закрывать в любом случае, иначе, только если открыта
      //Возврат - информация о закрытой смене, текст - ошибки(предупреждения) во время закрытия
      RAttrCommonShiftNum = 'CommonShiftNum';
      RAttrCommonShiftDate = 'CommonShiftDate';
    QCmdCloseCashShift = 'CloseCashShift';
//      QRManager = 'Manager';
//      QRStation = 'Station';
//      QRMaket   = 'Maket';
      //Возврат - информация о закрытой смене, текст - ошибки(предупреждения) во время закрытия
      RAttrCashShiftNum = 'ShiftNum';
    {--> Чтение содержимого заказа (устаревшая, использовать вместо нее GetOrder) }
    QCmdReadOrderData = 'ReadOrderData';
//     QAttrVisitID = 'VisitID';     // ID визита
//     QAttrOrderID = 'OrderID';     // ID заказа
       QAttrNeedIdents = 'NeedIdents';// Если 1, то в результирующем xml возращаются идентификаторы всех элементов
       QAttrNeedCodes  = 'NeedCodes'; // Если 1, то в результирующем xml возращаются коды всех элементов
       QAttrNeedNames  = 'NeedNames'; // Если 1, то в результирующем xml возращаются имена всех элементов
    //Возврат
      //RTagSession = 'Session';      // Список пакетов. Внутри список Dishes
        RTagDishes       = 'Dishes';  // Список блюд. Внутри список детей (tag = RTagItem)
          RTagDish       = 'Dish';    // Блюдо
            RAttrRefItemID='ID';
            RAttrQuantity=QAttrQuantity;
            RAttrPrice   = 'Price';     // Цена блюда/модификатора (в копейках, нужно делить на 100)
            RTagModifers = 'Modifiers'; // Список модификаторов, внутри список детей (Tag=Modifier)

    // Ответный xml: Набор тегов и атрибутов эквивалентен команде QCmdWriteOrderData
      // Дополнительно у пакета добавлен атрибут Opened:
      RAttrOpened = 'Opened'; // Можно ли редактировать содержимое пакета
    {<-- Чтение содержимого заказа }

    {--> Чтение содержимого заказа, описание см. qryGetOrder.xsd и resGetOrder.xsd }
    QCmdGetOrder = 'GetOrder';
      QOrder     = 'Order';      // !Заказ, orderElement
      // Ответный xml
//      ROrder = 'Order';
//        RAttrVisit = 'visit';
//        RAttrOrderIdent = 'orderIdent';
//      RAttrOrderSum   = 'orderSum'; // Сумма заказа
        RAttrUnpaidSum  = 'unpaidSum'; // Сумма заказа к оплате
        RAttrDiscountSum= 'discountSum'; // Сумма скидок
//      RAttrTotalPieces  = 'totalPieces';// Сумма порций всех блюд заказа
//      RAttrPersistentComment='persistentComment';// Сохраняемый комментарий
//      RAttrNonpersistentComment='nonPersistentComment';// Несохраняемый комментарий
      ROrderType = 'OrderType';  // Тип заказа, refItem
      ROrderCategory='OrderCategory'; // Категория заказа, refItem
      RTable = 'Table';               // Стол, refItem
      RGuestType = 'GuestType';       // Тип гостей, refItem
      RSessionItem  = 'Session'; // Список пакетов заказа, см. rkXmlUtl.SessionItem + unbounded
      RDeliveryBlock  = 'DeliveryBlock';  // Блок с полями доставки
        RAttrTravelTime= 'travelTime';    // Время в пути
        RAttrDeliveryTime='deliveryTime'; // Время доставк
        RAttrZoneID   = 'zoneID';         // ID зоны доставки
        RAttrZoneName = 'zoneName';       // Имя зоны доставки
        RAttrOrderPrefix = 'orderPrefix'; // Префиск для номера заказа
    {<-- Чтение содержимого заказа }

    {--> Команды для получения списка блюд по заказу }
    QCmdGetOrderMenu = 'GetOrderMenu'; // Получить список блюд и модификаторов, доступных в определенном заказе
//      QAttrVisitID = 'VisitID';    // ID визита, по которому нужно получить список блюд
      QAttrOrderID = 'OrderID';    // ID заказа, по которому нужно получить список блюд
//    QAttrStationID   = 'StationID'; // ID станции, если не задан то используется StationCode
//    QAttrStationCode = 'StationCode';// Код станции (от станции зависят цены и ТГ)
//    QAttrTableID   = 'TableID';  // ID стола, если не задан, то используется TableCode
//    QAttrTableCode = 'TableCode';// Код стола
//    QAttrWaiterCode='WaiterCode';//Код официанта
//    QAttrWaiterID  = 'WaiterID'; // ID официанта, если не задан, то используется WaiterCode
      QAttrDateTime    = 'DateTime';  // Время, на которое нужно получить список блюд (dd.mm.yyyy hh:mm или YYYYMMDD hh:mm)
      QAttrCheckRests  = 'checkrests'; // Нужно ли проверять остатки блюд
      // Ответный xml
      //RTagDishes       = 'Dishes';    // Список блюд. Внутри список детей (tag = RTagItem)
        //RAttrPrice       = 'Price';   // Цена блюда (в копейках)
        //QRAttrQuantity   = 'quantity';// Остаток блюда (в тысячных долях)

      RTagModifiers    = QTagModifiers; // Список модификаторовд. Внутри список детей (tag = RTagItem)
        //RTagItem='Item'
          RAttrItemID      = 'Ident';        // ID блюда/модификатора
          //RAttrPrice       = 'Price';     // Цена блюда/модификатора (в копейках, нужно делить на 100)
      RTagOrderTypes = 'OrderTypes';    // Список типов заказа. Внутри список детей (tag = RCOTItem)
//        RAttrItemID      = 'Ident';
    {<-- Команды для получения списка блюд по заказу }
      {--> Получить список заказов, аналогично QCmdGetOrders }
      QCmdGetOrderList = 'GetOrderList';
//      QAttrNeedIdents = 'NeedIdents';// Если 1, то в результирующем xml возращаются идентификаторы всех элементов
//      QAttrNeedCodes  = 'NeedCodes'; // Если 1, то в результирующем xml возращаются коды всех элементов
//      QAttrNeedNames  = 'NeedNames'; // Если 1, то в результирующем xml возращаются имена всех элементов
        QAttrOnlyOpened = 'OnlyOpened';// Если 1, то в результирующем xml возращаются только активные заказы
        QRAttrLastVersion = 'lastversion'; // Кэшировать результат запроса. Если версия таблицы заказов совпадает с lastversion, то возвращается "No changes", иначе обычный ответ 
//      QWaiter         = 'Waiter';    // Официант, refItem. Если задан, то в результирующем xml возращаются заказы только этого официанта
//      QTable          = 'Table';     // Стол, refItem. Если задан, то возвращаются заказы только этого стола
      // Ответный xml
        //QRAttrLastVersion = 'lastversion';    // Версия таблицы заказов 
        RTagVisit='Visit';             // Идентификатор визита
          //RAttrVisitID='VisitID';             // Идентификатор визита
          RAttrFinished     = 'Finished';       // Завершен визит или нет
          RAttrGuestTypeCode= QAttrGuestTypeCode;  // Код типа гостей
          RAttrGuestTypeID  = QAttrGuestTypeID;    // ID типа гостей
          RAttrGuestTypeName= 'GuestTypeName';     // Имя типа гостей
          RAttrGuestsCount = QAttrGuestsCount;       // Кол-во гостей
          RAttrPersistentComment='PersistentComment';// Сохраняемый комментарий
          RAttrNonpersistentComment='NonPersistentComment';// Несохраняемый комментарий
          RExternalID = 'ExternalID';
            RAttrExtSource= QAttrExtSource;     // id-программы, создавшей заказ, int
            RAttrExtID = QAttrExtID;            // Внешний id заказа, для связки со сторонними системами
          RTagGuests  = QTagGuests;        // Список гостей
          RAttrCardCode  = QAttrCardCode;      // Код карты гостя
          RAttrIntfID    = QAttrIntfID;        // ID интерфейса карты гостя
          RAttrIntfCode  = QAttrIntfCode;      // Код интерфейса карты гостя
          RAttrIntfName  = 'IntfName';         // Имя интерфейса
          RAttrGuestLabel = 'GuestLabel';
          RAttrSeatClosed = 'closed';          // Признак того, что место закрыто
          RTagOrders = 'Orders'; // Список заказов в визите. Внутри список детей (tag = 'Order')
            //ROrderTag = 'Order'; // Заказ
              RAttrVersion      = 'Version';         // Версия заказа, с 7.4.8.0
              RAttrCRC32        = 'crc32';           // Контрольная сумма, с 7.5.2.257
              RAttrGuid         = 'guid';            // GUID, с 7.5.2.267
              RAttrLocked       = 'locked';          // Флаг "Заказ заблокирован", с 7.5.2.366
              
              RAttrOrderName    = 'OrderName';       // Имя заказа (пока открытый - имя стола, потом внутреннее), с 7.4.8.1
              RAttrOrderURL     = 'url';             // URL заказа для сайта code.ucs.ru    
              RAttrTableCode    = QAttrTableCode;    // Код стола
              RAttrWaiterCode   = QAttrWaiterCode;   // Код главного официанта
              RAttrLockedByCode = 'LockedByCode';    // Код работника, открывшего заказ
              RAttrOrdCategCode = 'OrderCategCode';  // Код категории заказа
              RAttrOrdTypeCode  = 'OrderTypeCode';   // Код типа заказа
              RAttrDefaulterCode= 'DefaulterCode';   // Код типа неплательщика
              RAttrTableID      = QAttrTableID;      // ID стола
              RAttrWaiterID     = QAttrWaiterID;     // ID главного официанта
              RAttrLockedByID   = 'LockedByID';      // ID работника, открывшего заказ
              RAttrOrdCategID   = 'OrderCategID';      // ID категории заказа
              RAttrOrdTypeID    = 'OrderTypeID';       // ID типа заказа
              RAttrDefaulterID  = 'DefaulterID';     // ID типа неплательщика заказа
//              RAttrTableName   = QAttrTableName    // Имя стола
              RAttrWaiterName   = 'WaiterName';      // Имя главного официанта
              RAttrLockedByName = 'LockedByName';    // Имя рaботника, открывшего заказ
              RAttrOrdCategName = 'OrdCategName';    // Имя категории заказа
              RAttrOrdTypeName  = 'OrdTypeName';     // Имя типа заказа
              RAttrDefaulterName= 'DefaulterName';   // Код типа неплательщика
              RAttrCreateTime2  = 'CreateTime';      // Дата и время создания заказа
              RAttrFinishTime   = 'FinishTime';      // Дата и время завершения заказа
              RAttrBillTime     = 'BillTime';        // Дата и время печати пречека
              RAttrDessertTime  = 'DessertTime';     // Дата и время добавления десерта
              //RAttrOrderSum     = 'OrderSum';      // Сумма заказа
              RAttrTotalPieces  = 'TotalPieces';     // Сумма порций всех блюд заказа
              RAttrPrepaySum    = 'PrepaySum';       // Сумма незакрытых предоплат
              RAttrPromisedSum  = 'PromisedSum';     // Сумма незакрытых предоплат
              RAttrPromoCode    = 'promoCode';       // Промо-код
              RAttrPaid         = 'paid';            // Флаг - заказ оплачен
              RAttrBill         = 'Bill';            // Есть ли в заказе пречек
              RAttrBySeats      = 'bySeats';         // Флаг - заказ рассчитан по местам
              RAttrReadyExists  = 'ReadyExists';     // Флаг - в заказе есть приготовленные, но незабранные блюда
              RAttrWeightNeeded = 'WeightNeeded';    // Флаг - в заказе есть блюда с флагом "Требуется указание веса"
              RAttrReceiptError = 'ReceiptError';    // Есть ли в заказе ошибочный чек    
              RAttrDessert      = 'Dessert';         // Есть в заказе десерт или нет
              RTagExternalID    = 'ExternalID';      // Список внешних id заказа, unbounded
//              RAttrExtSource  = AttrExtSource;     // id-программы, создавшей заказ, int
//              RAttrExtID      = QAttrExtID;        // Внешний id заказа, для связки со сторонними системами
              RTagExtraTables = 'ExtraTables'; // Список дополнительных столов, итератор item
                RExtraTableItem = 'item';            // Запись о столе, refitem + unbounded
//                RAttrID       = 'id';              // id стола
//                RAttrCode     = 'code';            // код стола

      {<-- Получить список заказов }

      {-->  Терминал авторизации: начало авторизации }
      QCmdTerminalAuthStart = 'TerminalAuthStart';
//      QOrder          = 'Order';         // ! Заказ, orderElement
        QCurrency       = 'Currency';      // ! Валюта
//      QWaiter         = 'Waiter';        // ! Кассир
        QAttrAmount     = 'amount';        // ! Сумма к оплате
        QAttrAsPrepay   = 'asPrepayment';  // Провести платеж как предоплату. Иначе как оплату чека
      {<--  Терминал авторизации: начало авторизации }

      {-->  Терминал авторизации: оплата }
      QCmdTerminalAuthPay = 'TerminalAuthPay';
//      QOrder          = 'Order';         // ! Заказ, orderElement
        QAttrTransactionID = 'transactionID';// ID транзакции, int
        QAttrExtTransactionInfo='extTransactionInfo'; // Внеший код авторизации, String
        QAttrAuthCode = 'authCode';        // Код авторизации
        QAttrOwner    = 'owner';           // Владелец карты
//      QAttrCardCode   = 'cardCode';      // Номер карты (для отображения)
      {<-- Терминал авторизации: оплата }

      {-->  Терминал авторизации: ошибка }
      QCmdTerminalAuthError = 'TerminalAuthError';
//      QOrder          = 'Order';         // ! Заказ, orderElement
        QAttrErrorText='errorText';        // Текст ошибки
      {<-- Терминал авторизации: ошибка }

      {-->  Логин сотрудника на станцию (не регистрация, а именно логин) }
      QCmdLoginOnStation = 'LoginOnStation';
//      QStation      = 'Station';  // ! Станция
//      QWaiter       = 'Waiter'    // Работник
        QAttrPassword = 'password'; // ! Пароль работника
//      QAttrCardCode = 'cardCode'; // Код карточки работника (если задан, то Code и Password не используется)
      // Ответный xml
      RAttrEmployeeID = 'EmployeeID';// ID работника
      RTagOpRights    = 'OpRights'; // Список прав на операции. Внутри список детей (tag = 'oper')
        RTagOper      = 'oper';     // id операции, на которую у работника есть право
      RTagObjRights   = 'ObjRights';// Список прав на объекты. Внутри список детей (tag = 'right')
        RTagRight     = 'right';    // id права на объект
      RTagTables      = 'Tables';   // Список доступных столов
        RTagTable     = 'table';    // id стола
//    RTagOrders      = 'Orders';   // Список доступных заказов
//      RTagOrder     = 'Order';    // Заказ, orderElement
          RAttrOwnOrder = 'own_order'; // Флаг "Свой заказ"
          //
      {<--  Логин сотрудника на станцию }

      {-->  Зарегистрировать сотрудника }
      QCmdRegisterEmployee = 'RegisterEmployee';
//      QStation      = 'Station';  // ! Станция, refItem
//      QWaiter       = 'Waiter'    // ! Работник, refItem
//      QManager      = 'Manager'   // ! Менеджер, от имени которого выполняется регистрация, refItem
        QPosition     = 'Position'; // Позиция обслуживания, refItem + unbounded
        QAttrIsCashStation = 'iscashstation'; // Флаг "Использовать станцию как кассовую станцию", boolean
      // Ответный xml
//    QRWaiter = 'Waiter'; // Работник, refItem
//    QRDrawer = 'Drawer'; // Ящик, refItem
      {<--  Зарегистрировать сотрудника }

      {-->  Отменить регистрацию сотрудника }
      QCmdUnregisterEmployee = 'UnregisterEmployee';
//      QStation      = 'Station';  // ! Станция, refItem
//      QWaiter       = 'Waiter'    // ! Работник, refItem
      {<--  Отменить регистрацию сотрудника }

      {-->  Найти работника по коду карточки }
      QCmdFindEmployee = 'FindEmployee';
//      QAttrCardCode = 'CardCode';    // Код карточки работника
      // Ответный xml
//      QRWaiter = 'Waiter';// Работник, refItem
      {<--  Найти работника по коду карточки }

      {-->  Получить по работнику список его кассовых прав }
      QCmdGetEmployeeInfo = 'GetEmployeeInfo';
//      QWaiter           = 'Waiter';   // !Работник, которому отсылается сообщение, refItem
      // Ответный xml
      QRDrawer       = 'Drawer';    // Ящик, refItem
//    RTagOpRights    = 'OpRights'; // Список прав на операции. Внутри список детей (tag = 'oper')
//      RTagOper      = 'oper';     // id операции, на которую у работника есть право
//    RTagObjRights   = 'ObjRights';// Список прав на объекты. Внутри список детей (tag = 'right')
//      RTagRight     = 'right';    // id права на объект
//    RTagTables      = 'Tables';   // Список доступных столов
//      RTagTable     = 'table';    // id стола
      {<--  Получить по работнику список его кассовых прав }

      {-->  Получить список официантов }
      QCmdGetWaiterList = 'GetWaiterList';
//      QTable         = 'Table';    // Стол
        QAttrRegisteredOnly = 'registeredOnly'; // Если 1, то возвращаются только зарегистрированные в смене официанты
      // Ответный xml
      RTagWaiters     = 'Waiters';   // Список официантов
        RTagWaiter      = 'waiter';    // id официанта
//        QRDrawer      = 'Drawer';    // Ящик, refItem
//        QRStation     = 'Station';   // Текущая станция, на которой залогинен работник, refItem    
      {<--  Получить список официантов }
      {-->  Примемение карты ПДС }
      QCmdApplyPersonalCard = 'ApplyPersonalCard';
//      QAttrVisit    = 'Visit';          // !Визит
//      QAttrOrderIdent='OrderIdent';     // !Заказ
//      QAttrCardCode  = 'CardCode';      // !Код карты гостя, string
//      QInterface  = 'Interface';        // !Интерфейс, refitem
        QCashier    = 'Cashier';          // Кассир, refitem
//      QStation    = 'Station';          // !Станция, refitem
      {<--  Примемение карты ПДС }
      {-->  Отмена применения карты ПДС }
      QCmdUndoPersonalCard = 'UndoPersonalCard';
//      QOrder        = 'Order';          // !Заказ, orderElement
//      QAttrCardCode  = 'cardCode';      // !Код карты гостя, string
//      QInterface  = 'Interface';        // !Интерфейс, refitem
//      QCashier    = 'Cashier';          // Кассир, refitem
      {<--  Отмена применения карты ПДС }

      {-->  Запись содержимого заказа }
      QCmdSaveOrder = 'SaveOrder';
//      QOrder     = 'Order';           // !Заказ, orderElement
        QLockStation = 'LockStation';   // Станация, от имени которой блокируется заказ
//        QAttrVisitID = 'visit';       // ! ID визита
//        QAttrOrderID = 'orderIdent';  // ! ID заказа
        QAttrDeferred = 'deferred';     // Неподтвержденный заказ (блоб). Для превращения в обычный заказ потребуется пересохранить заказ с кассы.
        QAttrDontCheckXMLLicense = 'dontcheckLicense'; // Отложить проверку лицензии на сохранение заказа. Не показывать такой заказ
        QSessionItem = 'Session';       // Список пакетов заказа, см. rkXmlUtl.SessionItem + unbounded
//        QAttrSessionID = 'sessionID'; // Если SessionID <> 0, то перезаписываем пакет, иначе добавляем новый
          QAttrRemindTime= 'remindTime';// ! Время, к которому блюда должны быть готовы, datetime
//        QAttrIsDraft  = 'isDraft';    // Признак, что пакет является черновиком, boolean
//        QStation      = 'Station';    // Станция, refitem
//        QAuthor       = 'Author';     // Работник, от имени которого создается пакет, refitem
          QCourse       = 'Course';     // Порядок подачи, refitem
          QDishItem     = 'Dish';       // Блюдо, refitem + unbounded
//          QAttrQuantity='quantity';//!Целое количество в тысячных долях
            QAttrPrice  = 'price';      // Цена блюда в копейках, integer
            QAttrSeat   = 'seat';       // Номер посадочного места, integer
            QModiItem   = 'Modi';       // Модификатор, refitem + unbounded
              QAttrCount  = 'count';    // ! Количество модификаторов, integer
          QComboItem    = 'Combo';      // Комбо блюдо, Dish + unbounded
//          QAttrQuantity='quantity';   // ! Целое количество в тысячных долях
//          QAttrSeat   = 'seat';       // Номер посадочного места, integer
            QComboCompItem= 'Component';// Компонент комбо блюда
//            QAttrCount  = 'count';    // ! Количество компонентов, integer
//            QAttrPrice  = 'price';    // Цена компонента в копейках, integer
//            QModiItem   = 'Modi';     // Модификатор, refitem + unbounded
          QPrepayItem   = 'Prepay';     // Предоплата, refitem + unbounded
//          QAttrAmount = 'amount';     // ! Сумма предоплаты (в копейках), integer
//          QAttrCardCode='cardCode';   // Код карточки, string
//          QAttrSeat   = 'seat';       // Номер посадочного места, integer
            QReason     = 'Reason';     // Причина, на которую сделана предоплата, refitem
      // Ответный xml
//    ROrder = 'Order';
        RSAttrVisit     = 'visit';
        RsAttrOrderIdent= 'orderIdent';
        RAttrBasicSum   = 'basicSum';   // Сумма к оплате в базовой валюте
        RAttrNationalSum= 'nationalSum';// Сумма к оплате в национальной валюте

      RErrorItem = 'Error';             // Запись об ошибке, unbounded
//      RAttrErrorText  ='ErrorText';   // Текст ошибки
//      RAttrRK7ErrorN  ='RK7ErrorN';   // Код ошибки
        RFaultyTag      = 'FaultyTag';
          RAny          = 'any';        // Тэг исходного xml-запроса, на обработке которого случилась ошибка
//      RSessionItem    = QSessionItem; // Пакет + unbounded
          RsAttrSessionID= 'sessionID';
      QCmdLoadOrderFromXML  = 'LoadOrderFromXML'; // Устаревшее название
      {<--  Запись содержимого заказа }

      {-->  Проверка корректности заказа }
      QCmdValidateOrder = 'ValidateOrder';
//      QTable          = 'Table';          // Стол, refitem
///     QOrderCategory  = 'OrderCategory';  // Категория заказа, refitem
//      QGuestType      = 'GuestType';      // Тип гостей, refitem
//      QSessionItem = 'Session';           // Пакет + unbounded, см. SaveOrder.QSessionItem
      // Ответный xml
//    RErrorItem = 'Error';        // Запись об ошибке, unbounded, см. SaveOrder.RErrorItem
//        RAttrSessionID = 'sessionID';
      {<--  Проверка корректности заказа }

      {-->  Рассчитать сумму заказа }
      QCmdCalcOrder = 'CalcOrder';
//      QSessionItem = 'Session';           // Пакет + unbounded, см. SaveOrder.QSessionItem
      // Ответный xml
      // ROrder = 'Order';
//        QSessionItem = 'Session';         // Пакет + unbounded, см. SaveOrder.QSessionItem
      {<--  Рассчитать сумму заказа }
      {-->  Рассчитать сумму заказа [2] }
      QCmdCalcOrder2 = 'CalcOrder2';
//      QROrder = 'Order';                  // !Заказ
        QRPaymentsTag = 'Payments';         // Список валют, которыми оплачивают
//        RPayItem    = 'Pay';              // Валюта, refItem
            QRAttrAmount = 'amount';        // Сумма оплаты (в копейках), integer

      // Ответный xml
//    QRPaymentsTag = 'Payments';           // Список всех валют, которыми можно оплатить
//      RPayItem      = 'Pay';              // Оплата, см. rkXmlUtl.RPayItem

      {<--  Рассчитать сумму заказа [2]}

      {-->  Оплатить заказ }
      QCmdPayOrder = 'PayOrder';
        QAttrCalcBySeats  = 'calcBySeats';// Рассчитать заказ по местам (иначе общий чек)
//      QOrder            = 'Order';      // !Заказ
//        QAttrVisit      = 'visit';
//        QAttrOrderIdent = 'orderIdent';
//      QCashier          = 'Cashier';    // !Кассир, refitem
//      QStation          = 'Station';    // !Станция, refitem
        QPaymentItem      = 'Payment';    // Оплата, refItem + unbounded
//        QRAttrExtTransactionInfo='extTransactionInfo'; // Внешний код авторизации, string
//        QAttrCardCode   = 'cardCode';   // Код ПДС карты клиента
//        QAttrAmount     = 'amount';     // !Сумма к оплате (в копейках)
          QTipCharge      = 'TipCharge';  // Наценка для чаевых, refItem
          QAttrTipAmount  = 'tipAmount';  // Сумма чаевых (в копейках)
          QAttrTerminalDetail = 'TerminalMaket'; //Представление документа для авторизации
        QReceiptMaket   = 'ReceiptMaket'; // !Представление документа для чека, refItem
        QInvoiceMaket   = 'InvoiceMaket'; // Представление документа для Счет фактуры, refItem
      // Ответный xml
//    RPrintCheckItem     = 'PrintCheck';   // Список чеков, см. rkXmlUtl.RPrintCheckItem + unbounded
      {<--  Оплатить заказ }

      {-->  Изменить у пакета порядок подачи }
      QCmdChangeSessionCourse = 'ChangeSessionCourse';
//      QOrder            = 'Order';      // !Заказ
//      QCourse           = 'Course';     // Порядок подачи, refitem
//      QAttrIsDraft      = 'isDraft';    // Признак "черновик", boolean
        QEmployee         = 'Employee';   // !Работник, выполняющий операцию
        QCourseFrom       = 'CourseFrom'; // Если задан, то обработке подлежат все пакеты с таким порядком подачи
//      QSessionItem      = 'Session';    // Если задан, то обработке подлежит только один пакет с таким UNI
          QAttrUNI        = 'uni';
      {<--  Изменить у пакета порядок подачи }

      {-->  Напечатать пречек }
      QCmdPrintBill = 'PrintBill';
        QAttrBySeats      = 'bySeats';    // Пречеки по местам (иначе общий пречек)
//      QOrder            = 'Order';      // !Заказ
//      QCashier          = 'Cashier';    // !Кассир, refItem
//      QStation          = 'Station';    // !Станция, refItem
//      QMaket            = 'Maket';      // !Представление документа для пречека, refItem
      {<--  Напечатать пречек }

      {-->  Напечатать пользовательский документ }
      QCmdPrintMaket = 'PrintMaket';
//      QOrder            = 'Order';      // Заказ
//      QStation          = 'Station';    // !Станция, refItem
//      QMaket            = 'Maket';      // Представление документа, refItem. Должно быть задано одно из 2-х: или Maket или Document
//      QDocument         = 'Document';   // Тип документа для печати, refItem. Должно быть задано одно из 2-х: или Maket или Document
//      QAttrLayoutFilters='LayoutFilters'; // Фильтр макета вида <поле>=значение[{;<поле=значение>}]
//      QAttrDataSourceParams='DataSourceParams'; // Параметры кубов вида <поле>=значение[{;<поле=значение>}]
      {<--  Напечатать пользовательский документ }

      {-->  Напечатать "сырые" данные с Esc последовательнотями в формате RK7 (см. escape.dat) или online или асинхронно как сервис печать }
      QCmdPrintRawData = 'PrintRawData';
        QPrinter       = 'Printer';       // Принтер, refItem
//      QOrder         = 'Order';         // Заказ, orderElement
        QRawData       = 'RawData';       //Данные в тексте, закодированные base64
        QAttrTimeout   = 'Timeout';       //Таймаут ожидания готовности устройства, при 0 или меньше асинхронная отправка в очередь без ошибок

      QCmdPrintDataXML = 'PrintDataXML';
        QPurpose       = 'Purpose';       // Назначение печати, refItem, должно быть с галочкой "на ресторан"
        //QAttrTimeout   = 'Timeout';       //Таймаут ожидания готовности устройства, при 0 или меньше асинхронная отправка в очередь без ошибок
        QUnfiscal      = 'Unfiscal';      // см. протокол универсального драйвера
      {<--  Напечатать "сырые" данные }

      {-->  Отменить пречек }
      QCmdUndoBill = 'UndoBill';
//      QOrder            = 'Order';      // !Заказ
//      QCashier          = 'Cashier';    // !Кассир, refItem
//      QStation          = 'Station';    // !Станция, refItem
//      QAttrSeat         = 'seat';       // Место, для которого пречек будет отменен, integer
      {<--  Отменить пречек }

      {-->  Закрыть посадочное место }
      QCmdCloseSeat = 'CloseSeat';
//      QOrder            = 'Order';      // Заказ, orderElement
//      QAttrSeat         = 'seat';       // Номер посадочного места, integer
      {<--  Закрыть посадочное место }

      {-->  Открыть закрытое посадочное место}
      QCmdOpenSeat = 'OpenSeat';
//      QOrder            = 'Order';      // Заказ, orderElement
//      QAttrSeat         = 'seat';       // Номер посадочного места, integer
      {<--  Открыть закрытое посадочное место}

      {-->  Перенос блюд между заказами }
      QCmdTransferDishes = 'TransferDishes';
        QOrderSource      = 'OrderSource';// !Заказ источник, orderElement
        QOrderDest        = 'OrderDest';  // !Заказ источник, orderElement
        QDishes           = 'Dishes';     //
//        QDishItem       = 'Dish';       // Блюдо, undounded
//          QAttrUNI        = 'uni';      // !uni блюда
//          QAttrQuantity='quantity';     // Количество в тысячных долях, если не задано то переносится все блюдо
      {<--  Перенос блюд между заказами }

      {-->  Временная блокировка заказа (на 10 мин) }
      QCmdLockOrder = 'LockOrder';
    //  QOrder          = 'Order';      // !Заказ, orderItem
        QAttrLockTime   = 'lockTime';   // На какое время заблокировать заказ
      {<--  Доставка: временная блокировка заказа }

      {-->  Запрос информации о карте ПДС }
      QCmdGetCardInfo = 'GetCardInfo';
//      QAttrCardCode = 'cardCode';  // ! Код карты
//      QInterface  = 'Interface';   // ! Интерфейс к карте, refitem
      // Ответный xml
      RCardInfo = 'CardInfo';
//      RAttrCardCode = 'cardCode';// Код карты, string
        RAttrHolder = 'holder';   // Владелец, string
        RAttrMaxAmount = 'maxAmount'; // Макс. сумма (в копейках), integer
        RAttrAmount = 'amount';   // Остаток (в копейках), integer
        RAttrMaxDisc= 'maxDisc';  // Макс.сумма скидки (в копейках), integer
        RDopInfo='DopInfo';       // Доп.инфо, string
//      RMessage = 'Message';     // Сообщение для экрана, string
        RPrintMessage='PrintMessage'; // Сообщение для печати, string
        ROutBuf = 'OutBuf';       // Ответный буфер, base64
          RAttrOutKind = 'kind';  // тип данных в буфере, integer
        RDiscount  = 'Discount';  // Скидка, refItem
        RBonusType = 'BonusType'; // Тип бонуса, refItem
        RDefaulter = 'Defaulter'; // Неплательшик, refItem
        RCurrency  = 'Currency';  // Валюта, refItem
          RAttrSubAcc = 'subacc'; // Номер субсчета, integer
//        RAttrMaxAmount = 'maxAmount'; // Макс. сумма (в копейках), integer
//        RAttrAmount = 'amount';   // Остаток (в копейках), integer
      {<--  Запрос информации о карте ПДС }

      {-->  Запрос AnyInfo к FarCards }
      QCmdFarCardsAnyInfoRaw = 'FarCardsAnyInfoRaw';
//      QInterface  = 'Interface';   // ! Интерфейс к карте, refitem
//      QRawData       = 'RawData';  //! Данные в тексте, закодированные base64
      // Ответный xml
      RRawData       = QRawData;  //! Данные в тексте, закодированные base64
      QCmdFarCardsAnyInfoXML = 'FarCardsAnyInfoXML';
//      QInterface  = 'Interface';   // ! Интерфейс к карте, refitem
      QXMLData       = 'XMLData';  //! Данные в XML формате для передачи в Farcards
      // Ответный xml
      RXMLData       = QXMLData;

      {-->  Пополнить баланс карты }
      QCmdMakeCardDeposit = 'MakeCardDeposit';
//      QStation      = 'Station';   // ! Станция, refItem
//      QInterface    = 'Interface'; // ! Интерфейс к карте, refItem
//      QCashier    = 'Cashier';     // ! Кассир, от имени которого делается внесение, refItem
//      QCurrency     = 'Currency';  // ! Валюта, refItem
        QDepositReason='Reason';     // Причина внесения/изъятия, refItem
//      QInterface  = 'Interface';   //   Интерфейс к карте гостя, refitem
//        QAttrAmount = 'amount';    // ! Сумма (в копейках), integer
//        QAttrCardCode = 'cardCode';// ! Код карты, string
      {<-- Пополнить баланс карты }

      {-->  Пополнение/изъятие денег }
      QCmdChangeDrawerBalance = 'ChangeDrawerBalance';
//      QStation      = 'Station';   // ! Станция, refItem
//      QCashier      = 'Cashier';   // ! Кассир, от имени которого делается внесение, refItem
        QRCurrency    = 'Currency';  // ! Валюта, refItem
//      QRDrawer      = 'Drawer';    //   Ящик, refItem
//      QMaket        = 'Maket';     //   Представление документа для печати внесения/инкассации, refItem
//      QDepositReason= 'Reason';    //   Причина внесения/изъятия, refItem
//        QAttrAmount = 'amount';    // ! Сумма +/- (в копейках), integer
      {<--  Пополнение/изъятие денег }

      {-->  Получить остатки денег в ящике }
      QCmdGetDrawerBalance = 'GetDrawerBalance';
//      QStation      = 'Station';   // ! Станция, refItem
//      QRDrawer      = 'Drawer';    //   Ящик, refItem
      // Ответный xml
      RItemTag = 'Item';
//      QRCurrency = 'Currency';     //   Валюта, refItem
//      QRDrawer      = 'Drawer';    //   Ящик, refItem
        QRPrinter     = 'Printer';   //   Принтер, refItem
//      QRAttrAmount  = 'amount';    //   Сумма (в копейках), integer
      {<--  Получить остатки денег в ящике }

      {-->  Запрос на проверку лицензии }
      QCmdCheckLicense = 'CheckLicense';
        QAttrLicense = 'license'; // Тип лицензии, enum('WebMon', 'WebRep', 'XMLSaveOrder')             
//      QRestaurant     = 'Restaurant'; // !Ресторан. Если не указан, то берется текущий
      {<--  Запрос на проверку лицензии }
      {-->  Создать счет-фактуру }
      QCmdCreateInvoice = 'CreateInvoice';
    //  QOrder          = 'Order';      // !Заказ, orderItem
//    QRInvoice                = 'Invoice';
//      QRAttrInvoiceRegNo     = 'regno';    // ИНН
//      QRAttrInvoiceName      = 'name';     // Наименование организации
//      QRAttrInvoiceAddress   = 'address';  // Адрес
//      QRAttrInvoiceExtraInfo = 'extrainfo';// Доп.инфо
//      QRAttrInvoiceComment   = 'comment';  // Комментарий
      // Ответный xml
//    QRInvoice                = 'Invoice'; // Созданная накладная
      {<--  Создать счет-фактуру }
      {-->  Получить информацию о счет-фактуре }
      QCmdGetInvoice = 'GetInvoice';
    //  QOrder          = 'Order';      // Заказ, orderItem
//    QRInvoice                = 'Invoice';
//      QRAttrGuid             = 'guid';
      // Ответный xml
//    QRInvoice                = 'Invoice'; // см. QCmdCreateInvoice.QRInvoice
      {<--  Получить информацию о счет-фактуре }

      QCmdXmlTransport = 'XmlTransport';
      QCmdLogicalDevices='LogicalDevices';
//      QStation      = 'Station';   // ! Станция, refItem
        RLogicalDevices = 'LogicalDevices';
          RLogicalDevice = 'LogicalDevice';
  //          RAttrID='id';
  //          RAttrName = 'name';
  //          RAttrGuid = 'guid';
  //          RAttrCode = 'code';
            RAttrDriver = 'driver';
            RAttrNumber = 'number';
            RAttrModClass   = 'modClass';
      QCmdListDeviceMenu='ListDeviceMenu';
//      QStation      = 'Station';   // ! Станция, refItem
        QDevice     = 'Device'; // ! refItem
        RDeviceMenu = 'DeviceMenu';
          RAttrCaption = 'caption';
          RAttrOperationId = 'operationId';
            RDialogInfo = 'DIALOGINFO';
              //RAttrCaption = 'caption';
      QCmdCallDeviceMenu='CallDeviceMenu';
//      QStation      = 'Station';   // ! Станция, refItem
//      QDevice     = 'Device'; // ! refItem
        QMenuOperation = 'MENUOPERATION';
          QAttrOperationId = RAttrOperationId;
            QDialogInfo = RDialogInfo;


implementation

end.

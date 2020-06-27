program XMLTEST;
{$APPTYPE CONSOLE}
uses
  windows, ActiveX,
  sysutils, MSXML2_TLB,
{$ifdef DIRECT}
  callxmltcp in 'callxmltcp.pas',
  WinSock2 in '..\..\netkern\Protocol\winsock2.pas'
{$else}
  rk7xmli in 'rk7xmli.pas'
{$endif}
  ;

const
  CMD_PARAMS_PREF   = ['-', '/'];
  
function  getCmdLineParamValue(const CmdLineParamName: string): string;
var found: boolean;
    pcnt : integer;
    pcmd : string;
begin
  found  := false;
  Result := '';
  //
  for pcnt := 1 to paramcount do begin
    Result := paramstr(pcnt);
    //
    if (Result = '') or not (Result[1] in CMD_PARAMS_PREF) then
      continue;
    //
    delete(Result, 1, 1);
    pcmd  := CmdLineParamName + ':';
    found := SameText( copy(Result, 1, length(pcmd)), pcmd);
    if not found then
      continue;
    //
    delete(Result, 1, length(pcmd));
    break;
  end;
  //
  if not found then
    Result := '';
end;

procedure WritelnAnsiString(s:string);
begin
  AnsiToOemBuff(PChar(s),PChar(s),Length(s));
  Writeln(s);
end;

procedure SchemeValidate(SchemeFileName: string;srcfile:string);
var
    xml, xsd: IXMLDOMDocument2;
    cache: IXMLDOMSchemaCollection;
    err: IXMLDOMParseError;
begin
  CoInitialize(Nil);

  try
    xsd := CoDOMDocument40.Create;
  except
    raise Exception.Create('Install MSXML 4.0 http://www.microsoft.com/en-us/download/details.aspx?id=19662');
  end;
  xsd.Async := False;
  if FileExists(SchemeFileName) then
    SchemeFileName:=ExpandFileName(SchemeFileName)
  else
    raise Exception.Create('File not found: '+SchemeFileName);
  xsd.load(SchemeFileName);

  cache := CoXMLSchemaCache40.Create;
  cache.add(SchemeFileName, xsd);

  xml := CoDOMDocument40.Create;
  xml.async := False;
  xml.schemas := cache;

  if not xml.load(srcfile) then begin
    err := xml.parseError;
    WritelnAnsiString(err.srcText);
    WritelnAnsiString(err.reason);
    halt(1);
  end else
    Writeln('Schema check OK!');
end;

var srcfile,resfile,r,ConnectID:string;
   h:integer;
   buf:array[0..1024] of char;
   ExecTime: cardinal;
   RequestNum:DWord;
begin
  if Paramcount<2 then begin
    writeln('USAGE:');
    writeln('  XMLTest <addr>[:<port>] <XMLRequest> [<XMLResult>] [/PASS:XXXXXX] [/CONN:YYYYYY] [/SCHEME:SchemeFileName]');
    writeln('  XMLTest <addr>[:<port>] .LastResult [<XMLResult>] [/PASS:XXXXXX] [/CONN:YYYYYY]');
    exit;
  end;
  srcfile:=ParamStr(2);
  ConnectID:='';
  if ParamCount<3 then
    resfile:='Res'+srcfile
  else
    resfile:=ParamStr(3);
  if resfile[1] in ['/','-'] then begin
    if ParamCount<4 then
      resfile:='Res'+srcfile
    else
      resfile:=ParamStr(4);
  end;

  if getCmdLineParamValue('SCHEME')<>'' then
    SchemeValidate(getCmdLineParamValue('SCHEME'),srcfile);

  if getCmdLineParamValue('PASS')<>'' then
    SetCryptKey(pChar(getCmdLineParamValue('PASS')));
  ConnectID:=getCmdLineParamValue('CONN');
  if uppercase(Paramstr(2))='.LASTRESULT' then begin
    ExecTime := GetTickCount;
    if GetLastXMLResult(PChar(Paramstr(1)),PChar(ConnectID),RequestNum,pChar(resfile),buf,sizeof(buf)) then
      writeln('Successfully executed, result in '+resfile);
  end else begin
    h:=FileOpen(srcfile,0);
    setlength(r,FileSeek(h,0,2));
    if r<>'' then begin
      FileSeek(h,0,0);
      FileRead(h,r[1],length(r));
    end;
    FileClose(h);

    ExecTime := GetTickCount;
    if CallRK7XMLRPC2(PChar(Paramstr(1)),PChar(ConnectID),PChar(r),length(r),RequestNum,pChar(resfile),buf,sizeof(buf)) then
      writeln('Successfully executed, result in '+resfile);
  end;
  writeln(buf);
  ExecTime := GetTickCount - ExecTime;
  writeln( 'RequestNum=',RequestNum,format(' Query time: %.3f secs', [ExecTime / 1000]) );
  // Insert user code here
end.
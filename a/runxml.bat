@if /%1 == / Goto Simplest
XMLTest 127.0.0.1:2234 %1
@goto end
:Simplest
XMLTest 127.0.0.1:2234 test.xml
XMLTest 127.0.0.1:2234 .LastResult
:end
@pause
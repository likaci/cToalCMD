Loop, %0%  ;对每个参数执行一次：
{
    param := %A_Index%
    If param not contains ::{,.tib
     Run totalcmd.exe  /O /T /L="%param%"
    Else
     Run Explorer.exe %param%
;    MsgBox, 4,, 第 %A_Index% 个参数是 %param%。继续？
;    IfMsgBox, No
;        break
	p=1
}
	if !p
    	Run totalcmd.exe  /O /T 

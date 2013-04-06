;Author Likaci www.xiazhiri.com
;感谢Sunwind的思路 http://blog.csdn.net/liuyukuan/article/details/8615735
SetWorkingDir %A_ScriptDir%

Loop, %0% ;主函数开始
{
    param := %A_Index%
	if param contains LikaciiniPath  ;如果命令行参数传入likaciiniPath,则不自动寻找wincmd.ini
	{
		StringReplace,inipath,param,LikaciiniPath,,All
		Continue
	}

	;排除特殊路径
    If param not contains ::{,.tib
	{
		if !inipath
			inipath := Getini() ;获取ini路径
		if !CheckEnv(inipath) ;检查运行环境
			Return
		if !Saveini(inipath) ;命令Tc保存配置文件
			Return
		Sleep 200
		if ShiftKey := GetKeyState("Shift","P") ;按下shift 右边
			LorR = right
		else
			LorR = Left
		if !Tabs := GetTabs(inipath,LorR) ;读取配置文件，获取tabs
			Return
		CheckandActiveTabs(Tabs,LorR,param,ShiftKey) ;激活目标
	}
    else
		Run Explorer.exe %param%

	HasParam=1
}

if !HasParam
	IfNotExist totalcmd.exe
	{
		MsgBox, 请确保ctotalcmd.exe与totalcmd.exe在同目录下
		Return
	}
	else
		Run totalcmd.exe  /O /T 
Return
;主函数结束

Getini(){
	RegRead,inipath,HKCU,Software\Ghisler\Total Commander,IniFileName
	if ErrorLevel
		inipath := A_WorkingDir "\wincmd.ini"
	Return inipath
}

CheckEnv(inipath){
		IfNotExist, %inipath%
		{
			MsgBox,使用绿色版TC？`n那么请确保以下文件在同目录下:`ntotoalcmd.exe`nctotalcmd.exe`nwincmd.ini
			Return
		}
		IfNotExist, totalcmd.exe
		{
			msgbox,没有发现totalcmd.exe`n请确保以下文件在同目录下:`ntotoalcmd.exe`nctotalcmd.exe
			Return
		}
Return true
}

Saveini(inipath){
	loop, %inipath%
		time := A_LoopFileTimeModified
	if ErrorLevel
	{
		msgbox 读取wincmd.ini失败
		Return	
	}
	IfWinExist, ahk_class TTOTAL_CMD
		isTCExist := 1
	else
	{
		Run,totalcmd.exe
		WinWait, AHK_CLASS TTOTAL_CMD
	}
	PostMessage 1075, 580, 0, , AHK_CLASS TTOTAL_CMD	
	loop{
		loop,%inipath%
			time2 := A_LoopFileTimeModified
		if ErrorLevel
			Continue
		if strlen(time2)!=14
			Continue
		if time2!=%time%
			break
	}
	Return true
}

GetTabs(inipath,LorR){
	Tabs := object()
	IniRead, ActiveTab, %inipath%, %LorR%,path ;获取激活的标签
	IniRead, ActiveTabNum, %inipath%, %LorR%tabs,activetab ;获取激活标签的序号
	loop
	{
		Index := A_Index - 1
		IniRead, UnActiveTab, %inipath%, %LorR%tabs,%Index%_path ;获取右侧未激活的标签
		if UnActiveTab = ERROR
			break	
		Tabs.Insert(UnActiveTab)
	}
	ActiveTabNum+=1
	Tabs.Insert(ActiveTabNum,ActiveTab)
	Return %Tabs%
}

CheckAndActiveTabs(Tabs,LorR,param,ShiftKey){
	loop % Tabs.MaxIndex()
	{
		path :=  Tabs[A_Index]
		IfInString,path,%param%
		{
			if LorR = Left
				TargetNum := 5200 + A_Index
			else
				TargetNum := 5300 + A_Index
			WinActivate, ahk_class TTOTAL_CMD
			PostMessage 1075, %TargetNum%, 0, , AHK_CLASS TTOTAL_CMD	
			Return
		}
	}
	if ShiftKey
		 Run totalcmd.exe  /O /T /R="%param%"
	else
		 Run totalcmd.exe  /O /T /L="%param%"
Return 
}



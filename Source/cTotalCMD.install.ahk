;安装ctotalcmd
RegRead, IsExp, HKEY_LOCAL_MACHINE, SOFTWARE\Classes\Folder\shell\open\command, DelegateExecute
If(IsExp="{11dbb47c-a525-400b-9e80-a54615a090c0}"){
	RegDelete HKEY_LOCAL_MACHINE, SOFTWARE\Classes\Folder\shell\open\command, DelegateExecute
	RegWrite, REG_EXPAND_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\Classes\Folder\shell\open\command, , `"%A_WorkingDir%\cTOTALCMD.EXE`" `"`%1`"
	TrayTip,,cTotalCommader为默认文件管理器,2000
	Sleep ,1500
	}
Else{
	RegWrite, REG_EXPAND_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\Classes\Folder\shell\open\command, DelegateExecute, {11dbb47c-a525-400b-9e80-a54615a090c0}
	RegWrite, REG_EXPAND_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\Classes\Folder\shell\open\command, , `%SystemRoot`%\Explorer.exe
	TrayTip,,Explorer为默认文件管理器,2000
	Sleep ,1500
}

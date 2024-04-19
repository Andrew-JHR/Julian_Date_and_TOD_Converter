# Julian Date and IBM z TOD (Time-Of-Day) Converter

This repository contains several programs to convert a date value in Julian date format (YYDDD) to the most commonly used Gregorian date format (YYYYMMDD) and vice versa.

1. The executable: ***JulianDateConv.exe*** and the folder for the Visual Studio **MFC** project: ***JulianDateConv*** can be used on Windows

2. The jar: ***JulianDateConv.jar*** and the folder for an Eclipse project:*** JulianDateConverter*** can be used on Windows, MAC or Linux where **JAVA** is installed.

3. The executable: *** JulianConv.exe*** is a **Python** program using tkinter GUI and packed by **pyinstaller** (thru `pip install pyinstaller` and `pyinstaller --onefile JulianConv.py`. JulainConv.exe can only be run on Windows. To run on MAC and Linux, use the Python source code in **JulianConv.zip**.

4. The source code: **DATE.rexx** and **TOD.asm** are to be used on z/OS TSO. Putting DATE.rexx into any PDS data sets of the SYSEXEC DD concatenation and compiling **TOD.asm** (JCL included) into any PDS data sets of the ISPLLIB DD concatenation will enable the command: *TSO DATE YYYYMMDD* e.g. "TSO DATE 20240419" or *TSO DATE YYDDD* e.g. "TSO DATE 24134" to be executed. Issue *TSO ISRDDN* to list the SYSEXEC and ISPLLIB concatenations in your TSO/ISPF environment.

As well as the Julian date format, a TOD (Time-OF-Day) value is also used on z/OS. Under TSO, the same programs: **DATE.rexx** and **TOD.asm** together can be used to convert a TOD back and forth to a normal Gregorian date. Once successfully installed as what has been described above, you may issue *TSO DATE T* to display current date/time in Gregorian format and the TOD; or issue *TSO DATE ?* to see all acceptable input formats.  

Lastly, **TODCONV.cob** and **STCKCONV.asm** demonstrate how to let a COBOL program be able to get the correspondent Gregorian date of a TOD back by supplying a 16-byte TOD value to the subroutine written in Assembler. Note that the subroutine can be linked together with the COBOL program as a single LMD, which is named as Static linking; or the LMD of the subroutine -- being compiled into an LMD beforehand -- is called and loaded at runtime, which is called Dynamic linking like a DLL on Windows.    

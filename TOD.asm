//ALCSSPA  JOB  IBM,SP,CLASS=A,MSGCLASS=X,NOTIFY=ALCSSP,REGION=0M
//STEP1    EXEC ASMACL,PARM.C='FLAG(NOCONT)'
//C.SYSLIB DD   DSN=SYS1.MACLIB,DISP=SHR
//SYSIN    DD   *
*-----------------------------------------------------------------*
* Program function :
*   This program provides a REXX function 'tod' that can be called
*   by an exec to pass back a 'TOD to Date' or 'Date to TOD' conversion
*   result
*   If there is no argument : tod() then the program will pass back
*      the GMT date/time along with the 8-byte TOD value.
*
*   If there the argument is tod(1,Bxxx...) , where 'xxx...' can be
*      any valid hexdecimal TOD values with a lengh from 1 to 15, then
*      the program will pass back the GMT date/time for that TOD value.
*
*   If there the argument is tod(2,yyyy...) , where 'yyyy...' can be
*      any valid date/time values in the format :
*         YYYYMMDDhhmmssth
*      with a length from 4 to 16 bytes, then
*      the program will pass back the TOD value for that date/time.
*
*
* Assember : High Level Assembler 1.2 or above
* Author :   Andrew Jan
* Completion Date : 23/May/2002
* Update     Date :
*
*-----------------------------------------------------------------*
         PRINT NOGEN
*------------------------------------------------*

         PRINT OFF
         LCLA  &REG
.LOOP    ANOP                     generate reg equates
R&REG    EQU   &REG
&REG     SETA  &REG+1
         AIF   (&REG LE 15).LOOP
         PRINT ON


*------------------------------------------------*
RESULT   DSECT
DAYGMT   DC    C'GMT '        gmt ind.
DAYYYYY  DS    CL4            year
         DC    C'/'           delimitor
DAYMH    DS    CL2            month
         DC    C'/'           delimitor
DAYDD    DS    CL2            date
         DC    C' '           delimiter
DAYHH    DS    CL2            hour
         DC    C':'           delimiter
DAYMM    DS    CL2            minute
         DC    C':'           delimiter
DAYSS    DS    CL2            second
         DC    C':'           delimiter
DAYTH    DS    CL6            1 tenth
         DC    C' '           delimiter
DAYTOD   DS    CL16           delimiter
RESULT_LEN   EQU  *-RESULT

*------------------------------------------------*
WORKDATA DSECT ,
REGSAVE  DS    18F
TOD_WK   DS    D              work of a double-word field
WK_16    DS    0CL16          fullword boundary
P_TIME   DS    0CL6           packed hhmm
P_HH     DS    CL1            packed hh
P_MM     DS    CL1            packed mm
P_SS     DS    CL1            packed ss
P_TH     DS    CL3            packed thijuu0000
         DS    CL2            reserved
P_DATE   DS    0CL4           packed yyyymmdd
P_YYYY   DS    CL2            packed yyyy
P_MH     DS    CL1            packed month
P_DD     DS    CL1            packed dd
         DS    CL4            reserved

         ORG   WK_16
P_HMST   DC    X'1140596497820000'       HHMMSSTHMIJU0000
P_Y4MD   DC    X'20020523'               MMDDYYYY
         ORG

WKDATE   DS    0CL8           unpacked yyyymmdd
WKYYYY   DS    CL4            unpacked yyyy
WKMH     DS    CL2            unpacked month
WKDD     DS    CL2            unpacked dd

         ORG   WKDATE
WK_12    DS    0CL12
WKHH     DS    CL2            unpacked hh
WKMM     DS    CL2            unpacked mm
WKSS     DS    CL2            unpacked ss
WKTH     DS    CL6            unpacked tenth
         DS    CL12           reserved
WORKLEN  EQU   *-WORKDATA

         IRXEFPL ,                efpl, external function parm list
         IRXARGTB ,               argument list map
         IRXEVALB ,               evaluation block map

TOD      CSECT
*OD      AMODE 31
*OD      RMODE ANY

         STM   R14,R12,12(R13)    save caller's reg values
         LR    R12,R15            set base reg
         USING TOD,R12            setup addressibility
         LR    R8,R1              save parmlist addr
         B     CMNTTAIL           skip over the remarks

CMNTHEAD EQU   *
         PRINT GEN                print out remarks
         DC    CL8'&SYSDATE'      compiling date
         DC    C' '
         DC    CL5'&SYSTIME'      compiling time
         DC    C'ANDREW JAN'      author
         CNOP  2,4                ensure half word boundary
         PRINT NOGEN              disable macro expansion
CMNTTAIL EQU   *

*-start code ----------------------------*

         GETMAIN RU,LV=WORKLEN,LOC=BELOW  blk addr returned in r1
         ST    R13,4(,R1)         chain save areas
         ST    R1,8(,R13)         save ours to caller's area
         LR    R13,R1             set our save addr
         USING WORKDATA,R13       addressibility for data

         USING EFPL,R8            addressibility

         L     R9,EFPLARG         argument list  addr

*####### OPEN  (PRINT,OUTPUT)     ###############

         USING ARGTABLE_ENTRY,R9  addressibility

*ARGTABLE_ARGSTRING_PTR    DS  A        Address of the argument string
*ARGTABLE_ARGSTRING_LENGTH DS  F        Length of the argument string
*ARGTABLE_NEXT             DS  0D       Next ARGTABLE entry
*ARGTABLE_END DC  XL8'FFFFFFFFFFFFFFFF' End of ARGTABLE marker

* check if any arg provided ?
         CLC   ARGTABLE_ARGSTRING_PTR(8),=XL8'FFFFFFFFFFFFFFFF'
         BZ    NO_ARG             yes, get current tod


* there should have 2 parms if there is any parm provided.
         L     R10,ARGTABLE_ARGSTRING_PTR addr of arg 1
         LA    R9,ARGTABLE_NEXT           next arg
         L     R11,ARGTABLE_ARGSTRING_PTR addr of arg 2
         L     R9,ARGTABLE_ARGSTRING_LENGTH  len of arg 2

         C     R9,=F'16'          control the len of arg2 < 16
         BNH   ARG_0              within 16, branch
         L     R9,=F'16'          the maximum allowed

ARG_0    EQU   *

         CLI   0(R10),C'1'        tod to date time ?
         BNE   ARG_2

ARG_1    EQU   *
         MVC   WK_16,LOWVALUE     init the field
         BCTR  R9,0               minus 1 for ex
EXMVC1   MVC   WK_16(0),0(R11)    mask for ex
         EX    R9,EXMVC1          do the mvc according the length

         TR    WK_16,C2X-C'A'     xlat into hexa

         PACK  TOD_WK(5),WK_16(9)     pack the value
         PACK  TOD_WK+4(5),WK_16+8(9) pack the value
         B     ARG_COMM           branch

ARG_2    EQU   *
         CLI   0(R10),C'2'        date,time to tod ?
         BNE   NO_ARG             no

         MVC   WK_16,LOWVALUEX    init the field
         BCTR  R9,0               minus 1 for ex

         MVC   WK_12(16),=C'2002010100000000' in case no enough val.

EXMVC2   MVC   WK_12(0),0(R11)    mask for ex
         EX    R9,EXMVC2          do the mvc according the length

         PACK  P_HMST(5),WK_12+8(9)   pack the hhmmssth
         PACK  P_Y4MD(5),WK_12(9)     pack the yyyymmdd

         CONVTOD CONVVAL=WK_16,TODVAL=TOD_WK,TIMETYPE=DEC,             X
               DATETYPE=YYYYMMDD,OFFSET=LOCALDIF

         B     ARG_COMM           branch

NO_ARG   EQU   *
         STCK  TOD_WK             current time

ARG_COMM EQU   *
         L     R8,EFPLEVAL        addr of evaluation block addr
         L     R8,0(,R8)          evaluation blk for result to return
         DROP  R8
         USING EVALBLOCK,R8       addressibility

*EVALBLOCK_EVSIZE DS  F           Size of EVALBLK in double word
*EVALBLOCK_EVLEN  DS  F           Length of data
*EVALBLOCK_EVDATA DS  C           Result

R        USING RESULT,EVALBLOCK_EVDATA   addressibility

         STCKCONV STCKVAL=TOD_WK,CONVVAL=WK_16,DATETYPE=YYYYMMDD

         MVC   R.DAYGMT,=C'GMT '    indicator

         UNPK  WKDATE(9),P_DATE(5)
         MVC   R.DAYYYYY,WKYYYY
         MVI   R.DAYMH-1,C'/'       delimitor
         MVC   R.DAYMH,WKMH
         MVI   R.DAYDD-1,C'/'       delimitor
         MVC   R.DAYDD,WKDD
         MVI   R.DAYHH-1,C' '       delimitor

         UNPK  WK_12(13),P_TIME(7)
         MVC   R.DAYHH,WKHH
         MVI   R.DAYMM-1,C':'       delimitor
         MVC   R.DAYMM,WKMM
         MVI   R.DAYSS-1,C':'       delimitor
         MVC   R.DAYSS,WKSS
         MVI   R.DAYTH-1,C':'       delimitor
         MVC   R.DAYTH,WKTH

         MVI   R.DAYTOD-1,C' '      delimitor

         UNPK  WK_16(9),TOD_WK(5)   unpack to chars for reading
         UNPK  WK_16+8(9),TOD_WK+4(5) unpack to chars for reading
         TR    WK_16,X2C-C'0'       xlat x'fa'-x'ff' to x'c1'-x'c6'
         MVC   R.DAYTOD,WK_16       move for output

         L     R1,=A(RESULT_LEN)    length of data
         ST    R1,EVALBLOCK_EVLEN   save back

*####### CLOSE  PRINT               #############

*--go back-------------------------------*
         L     R13,4(,R13)        restore caller's save area
         L     R1,8(,R13)         our work area's addr in r1

         FREEMAIN RU,LV=WORKLEN,A=(1)   free out work area

         LM    R14,R12,12(R13)     restore caller's reg values
         SR    R15,R15             rc = 0
         BR    R14                 go back

         LTORG

LOWVALUE DS    0CL16
         DC    16C'0'

LOWVALUEX DS   0CL16
         DC    16X'00'

LOCALDIF DC  X'0000800D'               000HH/MM

C2X      DC    X'FAFBFCFDFEFF'
         DS    CL(C'0'-C'F'-1)
         DC    C'0123456789'

X2C      DC    C'0123456789'
         DC    C'ABCDEF'

*----------------------------------------*
**#####  ICM   R14,B'1111',TOD_WK load input rec's tod into r14,r15
**#####  ICM   R15,B'1111',TOD_WK+4 load input rec's tod into r14,r15
**#####  LA    R1,TOD_GMT        8 hours for local time from gmt
**#####  BAL   R7,DOUBLE_ADD     go do the double-word adding
**#####  STM   R14,R15,TOD_WK    save back the tod
***---subroutine--------------------------*                             03961090
**DOUBLE_ADD     EQU   *
**         AL    R15,4(,R1)          add low order words                03963070
**         BC    8+4,DBLADD1         branch if no carry                 03964060
**         AL    R14,=A(1)           add carry into high order word     03966040
**DBLADD1  EQU   *                                                      03968020
**         AL    R14,0(,R1)          add high order words               03969010
**         BR    R7                                                     03969010
***---------------------------------------*                             03961090
**                                                                      03970990
***---subroutine--------------------------*                             03961090
**DOUBLE_SUBTRACT EQU   *
**         SL    R15,4(,R1)          subtract low order words           03984850
**         BC    2+1,DBLSUB1         branch if carry                    03985840
**         SL    R14,=A(1)           subtract carry fm high order word  03987820
**DBLSUB1  EQU   *                                                      03989800
**         SL    R14,0(,R1)          subtract high order words          03990790
**         BR    R7                                                     03991780
***---------------------------------------*                             03961090
**
**
**TOD_GMT  DS    0D             8 hours
**         DC    X'00006B49D2000000'     TOD value for 8 hours
**  4096 = 10e-6 second
**  1 sec = X'F4240000' = 4096000000
**  1/1000 sec = X'3E8000'  = 4096000
**  31st bit increase 1 = 1.048576 sec
**  1 hour = X'00000D693A400000'
**  8 hours= X'00006B49D2000000'
*----------------------------------------*
*##PRINT DCB   DSORG=PS,DDNAME=SYSTSPRT,MACRF=PM,RECFM=F,LRECL=80
         END
/*
//L.SYSLMOD  DD  DSN=SYS1.TOOL.ISPLLIB(TOD),DISP=SHR
//

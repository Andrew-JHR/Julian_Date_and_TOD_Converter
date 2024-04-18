//ANDREWJA  JOB  CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID
//STEP1    EXEC ASMACLG
//SYSIN    DD   *
         PRINT NOGEN
*------------------------------------------------*
         LCLA  &REG
.LOOP    ANOP                              GENERATE REGS.
R&REG    EQU   &REG
&REG     SETA  &REG+1
         AIF   (&REG LE 15).LOOP
*------------------------------------------------*
STCKCONV CSECT
STCKCONV AMODE 31
STCKCONV RMODE 24
         L     R3,0(,R1)           save the parm addr
         STM   R14,R12,12(R13)
         LR    R2,R13
         BALR  R12,0
         BAL   R13,76(R12)
SAVREG   DS    18F
         USING SAVREG,R13
         ST    R2,4(R13)
         ST    R13,8(R2)
*
         B     PROCESS
         DC    CL8'&SYSDATE'      compiling date
         DC    C' '
         DC    CL5'&SYSTIME'      compiling time
         DC    C'ANDREW JAN'      author
         CNOP  2,4                ensure half word boundary
*
*---start here-----------------------------------*
*
PROCESS  DS    0H

        USING  PARM,R3
        MVC    WK16,TOD
        TR     WK16,C2X-C'A'
        PACK   TOD_B(5),WK16(9)
        PACK   TOD_B+4(5),WK16+8(9)

*----------------------------------------------
*if the local time (rather than GMT) is needed-
        L     R14,TOD_B          tod
        L     R15,TOD_B+4        tod
        LA    R1,TOD_8H          local time difference
        BAL   R6,DBLADD          go do the double-word adding
        ST    R14,TOD_B          save to work
        ST    R15,TOD_B+4        save to work
*----------------------------------------------

        STCKCONV STCKVAL=TOD_B,CONVVAL=OUTAREA,TIMETYPE=DEC,           *
               DATETYPE=YYYYMMDD
        UNPK   WK9,Y4MMDD(5)
        MVC    YYYYMMDD,WK9
        UNPK   WK9(7),HHMMSS(4)
        MVC    HH,WK9
        MVC    MM,WK9+2
        MVC    SS,WK9+4

*
*---RETURN---------------------------------------*
*
RETURN   DS    0H
         L     R13,4(R13)
         RETURN (14,12),RC=0
*
*
*----------------------------------------------------*
DBLADD   EQU   *
         AL    R15,4(,R1)          add low order words
         BC    8+4,DBLADD1         branch if no carry

         AL    R14,=A(1)           add carry into high order word

DBLADD1  EQU   *
         AL    R14,0(,R1)          add high order words
         BR    R6                  go back
*----------------------------------------------------*
*
*
         LTORG
*
TOD_8H   DS    0F                      8 HOURS
         DC    X'00006B49D2000000'     TOD VALUE FOR 8 HOURS
*
TOD_B    DS   CL8
OUTAREA  DS  0CL16
HHMMSS   DS   CL3               hhmmss
         DS   CL5               THMIJU0000
Y4MMDD   DS   CL4               4-byte yyyymmdd
         DS   CL4               reserved
WK16     DS   CL16              work field
WK9      DS   CL9               work field
*
*
C2X      DC   X'FAFBFCFDFEFF'
         DS   CL(C'0'-C'F'-1)
         DC   C'0123456789'
*
*
PARM     DSECT   passed by the cobol program
TOD      DS CL16
YYYYMMDD DS CL8
         DS CL1
HH       DS CL2
         DS CL1
MM       DS CL2
         DS CL1
SS       DS CL2
*
         END
/*
//L.SYSLMOD  DD DSN=ANDREWJ.SOURCE.LMD(STCKCONV),DISP=SHR
//

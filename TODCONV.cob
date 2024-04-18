//ANDREWJA JOB  CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID
//*
//COB    EXEC PGM=IGYCRCTL,REGION=1024K,
//       PARM='OBJECT,LIB,APOST,RES' ,LIST,DYNAM,MAP,XREF(FULL)'
//STEPLIB  DD DSN=IGY.SIGYCOMP,DISP=SHR
//SYSUT1   DD UNIT=SYSDA,SPACE=(CYL,(1,1))
//SYSUT2   DD UNIT=SYSDA,SPACE=(CYL,(1,1))
//SYSUT3   DD UNIT=SYSDA,SPACE=(CYL,(1,1))
//SYSUT4   DD UNIT=SYSDA,SPACE=(CYL,(1,1))
//SYSUT5   DD UNIT=SYSDA,SPACE=(CYL,(1,1))
//SYSUT6   DD UNIT=SYSDA,SPACE=(CYL,(1,1))
//SYSUT7   DD UNIT=SYSDA,SPACE=(CYL,(1,1))
//SYSLIN   DD DSN=&OBJ,DISP=(,PASS),
//            UNIT=SYSDA,SPACE=(CYL,(1,1)),
//            DCB=(BLKSIZE=3120,LRECL=80,RECFM=FBS,BUFNO=1)
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSIN    DD    *
       IDENTIFICATION                  DIVISION.
       PROGRAM-ID.                     TEST1G.
      *----------------------------------------------------------------*
      *                                                                *
      *    E N V I R O N M E N T    D I V I S I O N                    *
      *                                                                *
      *----------------------------------------------------------------*
       ENVIRONMENT                     DIVISION.
       CONFIGURATION                   SECTION.
       SOURCE-COMPUTER.                IBM-4381.
       OBJECT-COMPUTER.                IBM-4381.
       INPUT-OUTPUT                    SECTION.
       FILE-CONTROL.
           SELECT LPFILE   ASSIGN  TO                  LP2.
      *----------------------------------------------------------------*
      *                                                                *
      *    D A T A   D I V I S I O N                                   *
      *                                                                *
      *----------------------------------------------------------------*
       DATA                            DIVISION.
       FILE                            SECTION.
       FD  LPFILE
           LABEL     RECORD  IS OMITTED.
       01  LP2                         PIC X(132).
      *
      *----------------------------------------------------------------*
      *                                                                *
      *    W O R K I N G - S T O R A G E   S E C T I O N               *
      *                                                                *
      *----------------------------------------------------------------*
       WORKING-STORAGE                SECTION.
       01  PARM.
           05  TOD                  PIC X(16) VALUE 'BE9CF52A1D978900'.
           05  DATETIME.
               10  YYYYMMDD         PIC X(08).
               10  SP               PIC X(01) VALUE SPACES.
               10  HH               PIC X(02).
               10  COL1             PIC X(01) VALUE ':'.
               10  MM               PIC X(02).
               10  COL2             PIC X(01) VALUE ':'.
               10  SS               PIC X(02).
       01  CONVRTN                  PIC X(08) VALUE 'STCKCONV'.
      *----------------------------------------------------------------*
      *                                                                *
      *    P R O C E D U R E   D I V I S I O N                         *
      *                                                                *
      *----------------------------------------------------------------*
       PROCEDURE                       DIVISION.
       1000-INIT-S.
      *    FOR DYNAMIC LINK
           CALL    CONVRTN    USING PARM.
      *    FOR STATIC CALL
      *    CALL    'STCKCONV' USING PARM.
      *
           OPEN    OUTPUT                   LPFILE.
           MOVE    TOD            TO        LP2   .
           WRITE   LP2            AFTER 1.
           MOVE    DATETIME       TO        LP2   .
           WRITE   LP2            AFTER 1.
           CLOSE   LPFILE.
           STOP    RUN.
/*
//LKED   EXEC PGM=IEWL,REGION=768K,COND=(5,LT),
// PARM='XREF,LET,LIST,MAP,'
//SYSLIB   DD DSN=CEE.SCEELKED,DISP=SHR
//SYSLIN   DD DSN=&OBJ,DISP=(OLD,DELETE)
//* UNCOMMENT THE FOLLOWING FOR STATIC CALL
//*        DD *
//*INCLUDE LIB1(STCKCONV)
//*
//*LIB1     DD DSN=ANDREWJ.SOURCE.LMD,DISP=SHR
//SYSUT1   DD UNIT=SYSDA,SPACE=(1024,(120,120),,,ROUND)
//SYSLMOD  DD  DSNAME=&&GOSET(GO),DISP=(,PASS),UNIT=SYSDA,
//         SPACE=(CYL,(1,1,1))
//SYSPRINT DD SYSOUT=*
//GO       EXEC  PGM=*.LKED.SYSLMOD,COND=((5,LT,LKED),(5,LT,COB))       00390007
//STEPLIB  DD DSN=ANDREWJ.SOURCE.LMD,DISP=SHR FOR DYNAMIC LINK          00390007
//LP2      DD SYSOUT=*

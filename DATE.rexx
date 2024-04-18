 /* rexx */                                                             00010000
 /*----------------------------------------------------------*/         00020000
 /* Author : Andrew Jan                                      */         00030000
 /* Complete Date :  23/May/2002                             */         00040000
 /* Updated  Date :  22/Oct/2008 to allow 'DATE ?'           */         00041000
 /* Function :                                               */         00050000
 /*  Entering one of the followings :                        */         00060000
 /*                                                          */         00070000
 /*  'TSO DATE T'                   to                       */         00080000
 /*            display  the current system date/time & TOD.  */         00090000
 /*                                                          */         00100000
 /*  'TSO DATE 20020523'            to                       */         00110000
 /*            display  the Julian day of the date provided. */         00120000
 /*                                                          */         00130000
 /*  'TSO DATE 02143'               to                       */         00140000
 /*            display  the date of the Julian day provided. */         00150000
 /*                                                          */         00160000
 /*  'TSO DATE B7D543C8AB0E99AF'    or                       */         00170000
 /*  'TSO DATE B7D543C8AB0E9   '    or                       */         00180000
 /*  'TSO DATE B7D543C8AB      '    or                       */         00190000
 /*  'TSO DATE B7D543C8        '    to                       */         00200000
 /*            display  the GMT date/time of the TOD provided*/         00210000
 /*                                                          */         00220000
 /*  'TSO DATE 2002            '    or                       */         00230000
 /*  'TSO DATE 200205          '    or                       */         00240000
 /*  'TSO DATE 2002052301      '    or                       */         00250000
 /*  'TSO DATE 200205230159    '    or                       */         00260000
 /*  'TSO DATE 20020523015903  '    or                       */         00270000
 /*  'TSO DATE 2002052301590300'    to                       */         00280000
 /*            display  the TOD for the date provided.       */         00290000
 /*----------------------------------------------------------*/         00300000
 parse upper arg  inparm                                                00310000
 select                                                                 00320000
   when arg() = 0          then say date('j')  date('w') date('n')      00330000
   when inparm = 'T'       then say tod()                               00340000
   when inparm = '?'       then                                         00341000
     do                                                                 00342000
       say 'DATE T to display the current system date/time & TOD.'      00342100
       say '---- yyyymmdd -------------'                                00342200
       say 'DATE 20081022 to display the equivalent Julian day.  '      00342400
       say '---- yyddd ----------------'                                00342500
       say 'DATE 08296    to display the equivalent Date.        '      00342700
       say 'DATE B7D543C8AB0E99AF   or '                                00343000
       say 'DATE B7D543C8AB0E9      or '                                00343100
       say 'DATE B7D543C8AB         or '                                00343200
       say 'DATE B7D543C8 to display the equivalent GMT date/time.'     00343300
       say '---- yyyymmddhhmmsstt -----'                                00343400
       say 'DATE 2008102201590300   or '                                00343500
       say 'DATE 20081022015903     or '                                00343600
       say 'DATE 200810220159       or '                                00343700
       say 'DATE 2008102201         or '                                00343800
       say 'DATE 200810             or '                                00343900
       say 'DATE 2008 to display the equivalent TOD.'                   00344000
     end                                                                00345000
   when length(inparm) = 5  &  datatype(inparm) ='NUM' then             00350000
        say date(,inparm,'j')                                           00360000
   when length(inparm) = 8  &  datatype(inparm) = 'NUM' then            00370000
     do                                                                 00380000
      day = date('b',inparm,'s') - date('b',left(inparm,4)||'0101','s') 00390000
      say right(left(inparm,4),2) || right((day+1),3,0)                 00400000
     end                                                                00410000
   otherwise                                                            00420000
     if datatype(inparm) = 'NUM' then                                   00430000
        say tod(2,inparm)                                               00440000
     else  say tod(1,inparm)                                            00450000
 end                                                                    00460000
 exit                                                                   00470000

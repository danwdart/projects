    DEF SEG = 0
    Status% = PEEK(&H417)
    PRINT Status%, HEX$(Status%)

FOR X = 0 TO 255
POKE &H417, X
PRINT X
FOR i = 1 TO 40000
NEXT i
NEXT X
POKE &H417, 160



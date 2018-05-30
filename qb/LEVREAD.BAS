CLS
PRINT "Welcome to Castle Of Doom: Visions"
PRINT "A Silent Echoes Media Game"
PRINT "Now loading file . . . ";

OPEN "dethride.lev" FOR INPUT AS #1
INPUT #1, NameOfLevel$
INPUT #1, X, Y
DIM Level(X, Y)
FOR I = 1 TO Y
FOR J = 1 TO X
INPUT #1, Level$(I, J)
NEXT J
NEXT I
CLOSE #1


PRINT "Loaded."
PRINT "Level name: "; NameOfLevel$
PRINT
YourX = 0
YourY = 0


PRINT "This is a text only game"
PRINT "Type commands after the >"
PRINT
PRINT "Commands:"
PRINT "n,e,s,w: Move"
PRINT "d: Use Pocket Dictionary (if you have one)"
PRINT "q: quit"
PRINT
PLAY Tune$
PRINT "Press any key to start."
DO
LOOP WHILE INKEY$ = ""
CLS
DO
cc
PRINT "You are at: "; YourX;YourY
see YourX, YourY
LINE INPUT "> ", In$
Go (In$)
LOOP

SUB cc
IF YourX < 0 THEN PRINT "You can't go that way!": x = 0
IF y < 0 THEN PRINT "You can't go that way!": y = 0
IF x > X THEN PRINT "You can't go that way!": x = 10
IF y > Y THEN PRINT "You can't go that way!": y = 10
IF x = 10 AND y = 10 THEN Quit
END SUB

SUB dic
PRINT "Chuddish pocket dictionary"
LINE INPUT "Dictionary lookup: ", lookup$

IF lookup$ = "Kegh magh gogh Edun" THEN
PLAY "O2L16E-F"
PRINT "EXACT MATCH: Type Edun when told to."

ELSEIF lookup$ = "Ekhun makhha kekhun" THEN
PLAY "O2L16E-F"
PRINT "EXACT MATCH: What do you have to type?"

ELSEIF lookup$ = "meke grando" THEN
PLAY "O2L16E-F"
PRINT "EXACT MATCH: Your pocket dictionary is working."

ELSE
PLAY "O1L16FEE-"
PRINT "NOTHING FOUND. TRY REPHRASING."

END IF

END SUB

SUB EndingScreen
CLS
PRINT "Now you've reached the end. Great adventure, wasn't it?"
PRINT "But that's not all. Remember to get the next level when it comes out!"
PRINT "Bye for now. Your level password is:"
PRINT
PRINT "ROBERT"
PRINT
PLAY "O3L16AGFEDC<BA>A"
PRINT "Press any key to quit."
DO
LOOP WHILE INKEY$ = ""
END
END SUB

SUB Go (In$)
IF LCASE$(LEFT$(In$, 1)) = "q" THEN Quit
IF LCASE$(LEFT$(In$, 1)) = "n" THEN y = y + 1: cc
IF LCASE$(LEFT$(In$, 1)) = "e" THEN x = x + 1: cc
IF LCASE$(LEFT$(In$, 1)) = "s" THEN y = y - 1: cc
IF LCASE$(LEFT$(In$, 1)) = "w" THEN x = x - 1: cc
IF In$ = "gimmegk" THEN PRINT "Green Key Cheat": gk = 1
IF In$ = "gimmepd" THEN PRINT "Pocket Dictionary Cheat": pd = 1
IF LCASE$(LEFT$(In$, 2)) = "tm" THEN x = VAL(MID$(In$, 3, 1)): y = VAL(MID$(In$, 4, 1)): PRINT "Teleporter Cheat: "; x; y
IF LCASE$(LEFT$(In$, 2)) = "d" THEN
        IF pd = 1 THEN
                dic
        ELSE
                PRINT "You don't have a dictionary!!"
        END IF
END IF
END SUB

SUB Quit
'PRINT "Quitting, sucker? (Y/N)"
'DO
'B$ = INKEY$
'LOOP WHILE B$ = ""
'IF UCASE$(B$) = "Y" THEN
'PRINT "Quitter!"
'END
'ELSEIF UCASE$(B$) = "N" THEN
'EXIT SUB
'ELSE
'Quit
'END IF



END SUB

SUB see (x, y)


'Y
'0OOOOOOOXXXF
'9OOOOOOOXOOO
'8OGXOOOOXOOO
'7OOXOOOOXOOO
'6OXXXXXXXOOO
'5OXOOOOOOOOO
'4OXOXXXXXOOO
'3OXXXOOOXXOO
'2OOOOOOOOXOO
'1DXXXXXXXXOO
'0SWWWWWWWWWW
' 01234567890 X
IF x = 0 AND y = 0 THEN
PRINT "There is a door to the north and water to the east."

ELSEIF x >= 1 AND x <= 10 AND y = 0 THEN
PRINT "You're swimming!! Oh, and you've drowned. Start from the beginning."
PRINT "You are at 0 0."
PRINT
x = 0
y = 0
see x, y

ELSEIF x = 0 AND y = 1 THEN
PRINT "Here lies a door. It opens with a creak showing you a corridor to the east."

ELSEIF x >= 1 AND x <= 7 AND y = 1 THEN
PRINT "There is a door to your west and a long corridor to your east."

ELSEIF x = 8 AND y = 1 THEN
PRINT "There is a door to your west and a corridor to your north."

ELSEIF x = 8 AND y = 2 THEN
PRINT "There are corridors to your north and south."

ELSEIF x = 8 AND y = 3 THEN
PRINT "Corridors to your west and south."







ELSE
PRINT "You shouldn't be here!"

END IF




END SUB







FOR I = 1 TO Y
FOR J = 1 TO X
PRINT Level$(I, J);
NEXT J
PRINT
NEXT I


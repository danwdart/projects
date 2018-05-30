DECLARE SUB Check (C$)
DECLARE SUB ShowLevel ()
DECLARE SUB WhereYouAre ()
COMMON SHARED X, Y, YourX, YourY, NameOfLevel$, gk, pd, In$
CLS
PRINT "Welcome to Castle Of Doom: Visions"
PRINT "A Silent Echoes Media Game"
PRINT "Now loading file . . . ";

OPEN "dethride.lev" FOR INPUT AS #1
INPUT #1, NameOfLevel$
INPUT #1, Tune$
INPUT #1, X, Y
DIM SHARED Level$(X, Y)
FOR I = Y TO 1 STEP -1
FOR J = 1 TO X
INPUT #1, Level$(J, I)
NEXT J
NEXT I
INPUT #1, StartX
INPUT #1, StartY
CLOSE #1


PRINT "Loaded."
PRINT "Level name: "; NameOfLevel$
PRINT
YourX = StartX
YourY = StartY


PRINT "This is a text only game"
PRINT "Type commands after the >"
PRINT
PRINT "Commands:"
PRINT "n,e,s,w: Move"
PRINT "d: Use Pocket Dictionary (if you have one)"
PRINT "q: quit"
PRINT
'PLAY Tune$
PRINT "Press any key to start."
DO
LOOP WHILE INKEY$ = ""
CLS
DO
PRINT "You are at: "; YourX; YourY
WhereYouAre
PRINT Level$(YourX, YourY)
LINE INPUT "> ", In$
Check (In$)
LOOP




SUB Check (C$)
IF C$ = "map" THEN ShowLevel
IF LEFT$(C$, 2) = "tm" THEN YourX = VAL(MID$(C$, 3, 2)): YourY = VAL(MID$(C$, 5, 2))

IF LCASE$(LEFT$(C$, 1)) = "n" THEN YourY = YourY + 1
IF LCASE$(LEFT$(C$, 1)) = "e" THEN YourX = YourX + 1
IF LCASE$(LEFT$(C$, 1)) = "w" THEN YourX = YourX - 1
IF LCASE$(LEFT$(C$, 1)) = "s" THEN YourY = YourY - 1
IF YourX < 1 THEN YourX = 1
IF YourY < 1 THEN YourY = 1
IF YourX > X THEN YourX = X
IF YourX > Y THEN YourY = Y



IF LCASE$(LEFT$(C$, 1)) = "n" AND Level$(YourX, YourY) = "X" THEN YourY = YourY - 1: PRINT "You've bumped into a wall!"
IF LCASE$(LEFT$(C$, 1)) = "s" AND Level$(YourX, YourY) = "X" THEN YourY = YourY + 1: PRINT "You've bumped into a wall!"
IF LCASE$(LEFT$(C$, 1)) = "e" AND Level$(YourX, YourY) = "X" THEN YourX = YourX - 1: PRINT "You've bumped into a wall!"
IF LCASE$(LEFT$(C$, 1)) = "w" AND Level$(YourX, YourY) = "X" THEN YourX = YourX + 1: PRINT "You've bumped into a wall!"


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

SUB ShowLevel


FOR I = Y TO 1 STEP -1


FOR J = 1 TO X

IF J = YourX AND I = YourY THEN PRINT "Y"; : GOTO B
PRINT Level$(J, I);
B:
NEXT J
PRINT
NEXT I


END SUB

SUB WhereYouAre
IF YourX < X THEN
IF Level$(YourX + 1, YourY) <> "X" THEN PRINT "There's a corridor to your east."
END IF

IF YourX > 1 THEN
IF Level$(YourX - 1, YourY) <> "X" THEN PRINT "There's a corridor to your west."
END IF

IF YourY < Y THEN
IF Level$(YourX, YourY + 1) <> "X" THEN PRINT "There's a corridor to your north."
END IF

IF YourY > 1 THEN
IF Level$(YourX, YourY - 1) <> "X" THEN PRINT "There's a corridor to your south."
END IF

END SUB


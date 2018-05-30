COMMON SHARED X, Y, YourX, YourY, Level$(), NameOfLevel$, gk, pd, In$
CLS
PRINT "Welcome to Castle Of Doom: Visions"
PRINT "A Silent Echoes Media Game"
PRINT "Now loading file . . . ";

OPEN "dethride.lev" FOR INPUT AS #1
INPUT #1, NameOfLevel$
INPUT #1, Tune$
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
PRINT "You are at: "; YourX; YourY
LINE INPUT "> ", In$
LOOP







FOR I = 1 TO Y
FOR J = 1 TO X
PRINT Level$(I, J);
NEXT J
PRINT
NEXT I

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


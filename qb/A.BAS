RANDOMIZE TIMER
Full$ = ""
G$ = ""
FOR I = 1 TO 8
G$ = CHR$(RND * 26 + 65)
Full$ = Full$ + G$
NEXT
PRINT "Random Search:"
PRINT Full$
X = TIMER
Ted:
Go$ = ""
Fullo$ = ""
FOR I = 1 TO 8
Go$ = CHR$(RND * 26 + 65)
Fullo$ = Fullo$ + Go$
NEXT I
IF Fullo$ = Full$ THEN Y = TIMER: GOTO Jim
GOTO Ted
Jim:
PRINT "Search took "; Y - X; " seconds."



DECLARE SUB see (x!, y!)
DECLARE SUB cc ()
COMMON SHARED x, y, gk
DECLARE SUB Go (In$)
x = 0
y = 0
COLOR 7, 1
CLS
PRINT "Welcome to Castle of Doom: Visions"
PRINT "A JolHarg Game"
PRINT
PRINT "This is a text only game"
PRINT "Type commands after the >"
PRINT
PRINT "Commands:"
PRINT "n,e,s,w: Move"
PRINT "examine (direction): Look in more detail"
PRINT "q: quit"
PRINT
PLAY "O1L16AAAABBBBAB>C<B>C<BAA>CCEEFEFGFGG+GFGFEFEC<B>C<BAAAAAAAA>CCCCCCCCEEEEFEFGFG+BAA"
PRINT "Press any key to start."

DO
LOOP WHILE INKEY$ = ""
CLS
DO
cc
PRINT "You are at: "; x; y
see x, y
LINE INPUT "> ", In$
Go (In$)
LOOP

SUB cc
IF x < 0 THEN PRINT "You can't go that way!": x = 0
IF y < 0 THEN PRINT "You can't go that way!": y = 0
IF x > 10 THEN PRINT "You can't go that way!": x = 10
IF y > 10 THEN PRINT "You can't go that way!": y = 10
IF x = 10 AND y = 10 THEN PRINT "Well done! You've won the level! Now buy Castle of Doom: Death!"
END SUB

SUB Go (In$)
IF LCASE$(LEFT$(In$, 1)) = "q" THEN END
IF LCASE$(LEFT$(In$, 1)) = "n" THEN y = y + 1: cc
IF LCASE$(LEFT$(In$, 1)) = "e" THEN x = x + 1: cc
IF LCASE$(LEFT$(In$, 1)) = "s" THEN y = y - 1: cc
IF LCASE$(LEFT$(In$, 1)) = "w" THEN x = x - 1: cc
IF In$ = "gimmegk" THEN PRINT "Green Key Cheat": gk = 1
IF LCASE$(LEFT$(In$, 2)) = "tm" THEN x = VAL(MID$(In$, 3, 1)): y = VAL(MID$(In$, 4, 1)): PRINT "Teleporter Cheat: "; x; y

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


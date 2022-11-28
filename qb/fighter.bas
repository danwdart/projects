COLOR 10, 0
p1health = 500
p2health = 500
CLS
PRINT "Fighter"
PRINT
PRINT "Player 1 choose your player:"
PRINT "1: Swordsman (melee and defence)"
PRINT "2: Bowman (melee and ranged)"
INPUT "1/2"; p1p
IF p1p = 1 THEN
PRINT "Swordsman"
PRINT "Weapons combination?"
PRINT "1: Short sword (1 attack, melee), tower shield (3 defence)"
PRINT "2: Broad sword (2 attack, melee), shield (2 defence)"
PRINT "3: Long sword (3 attack, melee), light shield (1 defence)"
INPUT "1/2/3"; p1w
ELSEIF p1p = 2 THEN
PRINT "Bowman"
PRINT "Weapons combination?"
PRINT "1: Shortbow (1 attack, ranged), long sword(3 attack, melee)"
PRINT "2: Bow (2 attack, ranged), broad sword(2 attack, melee)"
PRINT "3: Longbow (3 attack, ranged), short sword(1 attack, melee)"
INPUT "1/2/3"; p1w
END IF

IF p1p = 1 AND p1w = 1 THEN p1m = 1: p1d = 3: p1r = 0
IF p1p = 1 AND p1w = 2 THEN p1m = 2: p1d = 2: p1r = 0
IF p1p = 1 AND p1w = 3 THEN p1m = 3: p1d = 1: p1r = 0
IF p1p = 2 AND p1w = 1 THEN p1m = 3: p1d = 0: p1r = 1
IF p1p = 2 AND p1w = 2 THEN p1m = 2: p1d = 0: p1r = 2
IF p1p = 2 AND p1w = 3 THEN p1m = 1: p1d = 0: p1r = 3


PRINT
p1att:
PRINT "Select attributes:"
PRINT "You have 20 points to assign"
INPUT "Strength(1-19, determines attack)=", p1s
INPUT "Accuracy(1-19, determines chance of hitting, reduced by enemy defence)=", p1a
IF p1s + p1a <> 20 THEN
PRINT "You have made the attributes add up to something other than 20"
PRINT
GOTO p1att
END IF

PRINT
PRINT "Player 2 choose your player:"
PRINT "1: Swordsman (melee and defence)"
PRINT "2: Bowman (melee and ranged)"
INPUT "1/2"; p2p
IF p2p = 1 THEN
PRINT "Swordsman"
PRINT "Weapons combination?"
PRINT "1: Short sword (1 attack, melee), tower shield (3 defence)"
PRINT "2: Broad sword (2 attack, melee), shield (2 defence)"
PRINT "3: Long sword (3 attack, melee), light shield (1 defence)"
INPUT "1/2/3"; p2w
ELSEIF p2p = 2 THEN
PRINT "Bowman"
PRINT "Weapons combination?"
PRINT "1: Shortbow (1 attack, ranged), long sword(3 attack, melee)"
PRINT "2: Bow (2 attack, ranged), broad sword(2 attack, melee)"
PRINT "3: Longbow (3 attack, ranged), short sword(1 attack, melee)"
INPUT "1/2/3"; p2w
END IF

IF p2p = 1 AND p2w = 1 THEN p2m = 1: p2d = 3: p2r = 0
IF p2p = 1 AND p2w = 2 THEN p2m = 2: p2d = 2: p2r = 0
IF p2p = 1 AND p2w = 3 THEN p2m = 3: p2d = 1: p2r = 0
IF p2p = 2 AND p2w = 1 THEN p2m = 3: p2d = 0: p2r = 1
IF p2p = 2 AND p2w = 2 THEN p2m = 2: p2d = 0: p2r = 2
IF p2p = 2 AND p2w = 3 THEN p2m = 1: p2d = 0: p2r = 3


PRINT
p2att:
PRINT "Select attributes:"
PRINT "You have 20 points to assign"
INPUT "Strength(1-19, determines attack)=", p2s
INPUT "Accuracy(1-19, determines chance of hitting, reduced by enemy defence)=", p2a
IF p2s + p2a <> 20 THEN
PRINT "You have made the attributes add up to something other than 20"
PRINT
GOTO p2att
END IF

p1m = p1s * p1m
p1r = p1s * p1r
p2m = p2s * p2m
p2r = p2s * p2r

p1aa = p1a
p2aa = p2a

Distance = 3

CLS
PRINT "THE GAME BEGINS"


GameStart:

p1turn:

PRINT "Player 1's turn"
IF Distance = 3 THEN PRINT "Long range"
IF Distance = 2 THEN PRINT "Medium range"
IF Distance = 1 THEN PRINT "Short range"
IF Distance = 0 THEN PRINT "Point Blanc Range"
p1ar = p1aa - Distance - p2d
p2ar = p2aa - Distance - p1d
IF p1ar < 1 THEN p1a = 1 ELSE p1a = p1ar
IF p2ar < 1 THEN p2a = 1 ELSE p2a = p2ar

PRINT "Health="; p1health
PRINT "Ranged attack="; p1r
PRINT "Melee attack="; p1m
PRINT "Defence="; p1d
PRINT "Accuracy="; p1a
p1movechoice:

PRINT "What is your move?"
PRINT "1: Move towards target"
PRINT "2: Move away from target"
PRINT "3: Melee attack target"
IF p1p = 2 THEN PRINT "4: Range attack target"
INPUT "Enter choice:"; p1move
IF p1move = 1 THEN Distance = Distance - 1
IF p1move = 2 THEN Distance = Distance + 1
IF p1move = 3 THEN
IF Distance = 0 THEN
IF RND * 10 < p1a THEN p2health = p2health - p1m: PRINT "HIT!" ELSE PRINT "MISS!"
ELSE
PRINT "You swipe foolishly at the air!"
END IF
IF p1move = 4 THEN
IF Distance > 0 THEN
IF RND * 10 < p1a - Distance THEN p2health = p2health - p1r: PRINT "HIT!" ELSE PRINT "MISS!"
ELSE
PRINT "You can't range attack at point blanc range!"
END IF
END IF
END IF

IF p2health < 1 THEN winner = 1: GOTO endgame

p2turn:

PRINT "Player 2's turn"
IF Distance = 3 THEN PRINT "Long range"
IF Distance = 2 THEN PRINT "Medium range"
IF Distance = 1 THEN PRINT "Short range"
IF Distance = 0 THEN PRINT "Point Blanc Range"
p2ar = p2aa - Distance - p1d
p1ar = p1aa - Distance - p2d
IF p2ar < 1 THEN p2a = 1 ELSE p2a = p2ar
IF p1ar < 1 THEN p1a = 1 ELSE p1a = p1ar

PRINT "Health="; p2health
PRINT "Ranged attack="; p2r
PRINT "Melee attack="; p2m
PRINT "Defence="; p2d
PRINT "Accuracy="; p2a
p2movechoice:
PRINT "What is your move?"
PRINT "1: Move towards target"
PRINT "2: Move away from target"
PRINT "3: Melee attack target"
IF p2p = 2 THEN PRINT "4: Range attack target"
INPUT "Enter choice:"; p2move
IF p2move = 1 THEN Distance = Distance - 1
IF p2move = 2 THEN Distance = Distance + 1
IF p2move = 3 THEN
IF Distance = 0 THEN
IF RND * 10 < p2a THEN p1health = p1health - p2m: PRINT "HIT!" ELSE PRINT "MISS!"
ELSE
PRINT "You swipe foolishly at the air!"
END IF
IF p2move = 4 THEN
IF Distance > 0 THEN
IF RND * 10 < p2a - Distance THEN p1health = p1health - p2r: PRINT "HIT!" ELSE PRINT "MISS!"
ELSE
PRINT "You can't range attack at point blanc range!"
END IF
END IF
END IF
IF p1health < 1 THEN winner = 2: GOTO endgame
GOTO GameStart

endgame:
PRINT "Player "; winner; " wins!!!"



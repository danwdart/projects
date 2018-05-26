<?php
include 'battle.php';

class Game
{
    public static $allowed_types = array("Ninja", "Samurai", "Brawler");
    public static function gameOn($name1,$name2,$type1,$type2)
    {
        $player1 = new $type1($name1);
        $player2 = new $type2($name2);

        echo $player1;
        echo $player2;

        $battle = new Battle($player1,$player2);
        $battle->fight();
    }
}

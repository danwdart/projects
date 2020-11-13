<?php
require_once 'warrior.php';

class Ninja extends Warrior
{
    public function __construct($name)
    {
        parent::__construct($name);
        $this->setName($name);
        $this->setHealth(rand(40,60));
        $this->setAttack(rand(60,70));
        $this->setDefence(rand(20,30));
        $this->setSpeed(rand(90,100));
        $this->setEvade(rand(30,50) / 100); // For precision. rand() handles only ints.
    }

    public function attackAction(Warrior $warrior)
    {
        if (rand(1,100) <= 5)
        {
            $this->setAttack($this->getAttack() * 2);
            echo $this->getName() . " ate some fish, got a special and got a double attack of " . $this->getAttack() . "!<br />";
            parent::attackAction($warrior);
            $this->setAttack($this->getAttack() / 2);
        }
        else
        {
            parent::attackAction($warrior);
        }
    }

}

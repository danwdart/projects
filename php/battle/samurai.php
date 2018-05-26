<?php
require_once 'warrior.php';

class Samurai extends Warrior
{
    public function __construct($name)
    {
        parent::__construct($name);
        $this->setName($name);
        $this->setHealth(rand(60,100));
        $this->setAttack(rand(75,80));
        $this->setDefence(rand(35,40));
        $this->setSpeed(rand(60,80));
        $this->setEvade(rand(30,40) / 100); // For precision. rand() handles only ints.
    }

    public function doEvade()
    {
        if (rand(1,10) == 1)
        {
            $this->setHealth($this->getHealth() + 10);
            echo $this->getName() . " meditated and got a health boost of 10! Defence is now " . $this->getHealth() . "!<br />";
        }
    }

}

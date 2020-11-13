<?php
require_once 'warrior.php';

class Brawler extends Warrior
{
    public function __construct($name)
    {
        parent::__construct($name);
        $this->setName($name);
        $this->setHealth(rand(90,100));
        $this->setOriginalHealth($this->getHealth());
        $this->setAttack(rand(65,75));
        $this->setDefence(rand(40,50));
        $this->setSpeed(rand(40,65));
        $this->setEvade(rand(30,35) / 100); // For precision. rand() handles only ints.
    }

    public function decreaseHealth($amount)
    {
        if ($this->getHealth() < (0.2 * $this->getOriginalHealth()))
        {
            $this->setDefence($this->getDefence() + 10);
            echo $this->getName() . " got a defence boost! Defence is now " . $this->getDefence() . "!<br />";
        }
        parent::decreaseHealth($amount);
    }
}

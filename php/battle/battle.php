<?php

require_once 'ninja.php';
require_once 'samurai.php';
require_once 'brawler.php';

class Battle
{
    private $_warrior1; // The current warrior
    private $_warrior2; // The opponent

    public function getWarrior1()
    {
        return $this->_warrior1;
    }

    public function getWarrior2()
    {
        return $this->_warrior2;
    }

    public function __construct(Warrior $warrior1, Warrior $warrior2)
    {
        if ($warrior1->getSpeed() > $warrior2->getSpeed())
        {
            $this->_warrior1 = $warrior1;
            $this->_warrior2 = $warrior2;
        }
        else
        {
            $this->_warrior1 = $warrior2;
            $this->_warrior2 = $warrior1;
        }
    }

    public function doTurn()
    {
        $this->getWarrior1()->attack($this->getWarrior2());
    }

    public function fight()
    {
        for ($i=1;$i<=30;$i++)
        {
            if ($this->getWarrior1()->isDead())
            {
                echo $this->getWarrior1()->getName() . " is dead!<br />";
                break;
            }
            if ($this->getWarrior2()->isDead())
            {
                echo $this->Warrior2()->getName() . " is dead!<br />";
                break;
            }
            $this->doTurn();
            $this->swap();
        }
        if (!$this->getWarrior1()->isDead() && !$this->getWarrior2()->isDead())
        {
            echo "What an exceptional circumstance! No warrior is dead after 30 turns! The battle is a draw!";
        }
    }

    public function swap()
    {
        list($this->_warrior1, $this->_warrior2) = array($this->_warrior2, $this->_warrior1);
    }


}


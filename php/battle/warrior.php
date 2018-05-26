<?php

require_once 'warrior_interface.php';
abstract class Warrior implements Warrior_Interface
{
    private $_name;
    private $_health;
    private $_original_health;
    private $_attack;
    private $_defence;
    private $_speed;
    private $_evade;

    protected function __construct($name)
    {
    }

    protected function setOriginalHealth($health)
    {
        $this->_original_health = $health;
    }

    protected function getOriginalHealth()
    {
        return $this->_original_health;
    }

    public function setName($name)
    {
        $this->_name = $name;
    }

    public function getName()
    {
        return $this->_name;
    }

    public function setHealth($health)
    {
        $this->_health = $health;
    }

    public function getHealth()
    {
        return $this->_health;
    }
    
    public function setAttack($attack)
    {
        $this->_attack = $attack;
    }

    public function isDead()
    {
        return $this->getHealth() <= 0;
    }

    public function getAttack()
    {
        return $this->_attack;
    }
    
    public function setDefence($defence)
    {
        $this->_defence = $defence;
    }

    public function getDefence()
    {
        return $this->_defence;
    }

    public function setSpeed($speed)
    {
        $this->_speed = $speed;
    }

    public function getSpeed()
    {
        return $this->_speed;
    }

    public function setEvade($evade)
    {
        $this->_evade = $evade;
    }

    public function getEvade()
    {
        return $this->_evade;
    }

    protected function decreaseHealth($amount)
    {
        $this->setHealth($this->getHealth() - $amount);
    }

    public function beforeAttack(Warrior $warrior)
    {
        echo $this->getName() . " tried to attack " . $warrior->getName() . "!<br />";
    }

    public function attackAction(Warrior $warrior)
    {
        $damage = $this->getAttack() - $warrior->getDefence(); 
        $warrior->decreaseHealth($damage);
        echo $this->getName() . " succeeded! " . $warrior->getName() . " now has " . ($warrior->isDead() ? 0 : $warrior->getHealth()) . " health!<br />";
    }

    public function doEvade()
    {
    }

    public function evadeAction(Warrior $warrior)
    {
        echo $this->getName() . " failed!<br />";
        $warrior->doEvade();
    }

    public function attack(Warrior $warrior)
    {
        $this->beforeAttack($warrior);
        if ((rand(0,100) / 100) > $warrior->getEvade())
        {
            $this->attackAction($warrior);
            return true;
        }
        $this->evadeAction($warrior);
        return false;
    } 

    public function __toString()
    {
        return $this->getName() . " is a " . get_class($this) . " with health " . $this->getHealth() . ", attack " . $this->getAttack() . ", defence " . $this->getDefence() . ", speed " . $this->getSpeed() . " and evade " . $this->getEvade() . "!<br />";
    }

}

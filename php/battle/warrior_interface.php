<?php
interface Warrior_Interface
{
    public function setName($name); 
    public function getName(); 
    public function setHealth($health);
    public function getHealth();
    public function setAttack($attack);
    public function isDead();
    public function getAttack();
    public function setDefence($defence);
    public function getDefence();
    public function setSpeed($speed);
    public function getSpeed();
    public function setEvade($evade);
    public function getEvade();
    public function beforeAttack(Warrior $warrior);
    public function attackAction(Warrior $warrior);
    public function doEvade();
    public function evadeAction(Warrior $warrior);
    public function attack(Warrior $warrior);
    public function __toString();
}

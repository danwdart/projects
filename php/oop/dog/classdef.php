<?php

// classdef.php
// Part of example OOP practice

class Life
{
    protected $_name;

    public function __construct()
    {
        echo "Life Form Created!";
    }

    public function __destruct()
    {
        echo $this->_name . ' is dead! Cleaning up...';
    }

    public function setName($name)
    {
        $this->_name = $name;
    }

    public function getName()
    {
        return $this->_name;
    }
}

class Dog extends Life
{
    public function fetch($what)
    {
        echo $this->_name." found ".$what."!";
    }
}

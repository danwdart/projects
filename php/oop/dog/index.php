<?php

// index.php
// Part of Class Practice

include 'classdef.php';

$bob = new Life();
$bob->setName("Bob");
echo "Name is ".$bob->getName();

echo "<br />";

$ted = new Dog();
$ted->setName("Ted");
$ted->fetch("souls");


?>

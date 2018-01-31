<?php
class C
{
    private function _doSomething()
    {
        echo 'Oh no!'.PHP_EOL;
    }
}

$o = new C();

$cl = (function () {
    return $this->_doSomething();
})->bindTo($o, $o);

$cl();

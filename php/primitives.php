<?php
// THIS ENTIRE FILE IS PURE EVIL
// PURE, PURE EVIL
// WTF?
namespace JolHarg\Primitive;

class Magic
{
    private $_arrGetters;
    private $_arrSetters;

    public function __construct($arrGetters, $arrSetters)
    {
        $this->_arrGetters = $arrGetters;
        $this->_arrSetters = $arrSetters;
    }

    public function defineGetter($strWhat, $callback)
    {
        $this->_arrGetters[$strWhat] = $callback;
    }

    public function defineSetter($strWhat, $callback)
    {
        $this->_arrSetters[$strWhat] = $callback;
    }

    public function __get($what)
    {
        return $this->_arrGetters[$what]() ?? undefined;
    }

    public function __set($what, $towhat)
    {
        return $this->_arrSetters[$what]($towhat);
    }
}

class Object
{
    public $prototype;

    // let's break the damn universe
    public function __call($what, $with)
    {
        return $this->$what($with);
    }
}

class Str
{
    private $_str;

    public function __construct(string $str)
    {
        $this->_str = $str;
    }

    public function length()
    {
        return strlen($this->_str);
    }

    public function append(self $str)
    {
        $this->_str .= $str->_str;
        return $this;
    }

    public function startsWith(self $str)
    {

    }

    public function prepend(self $str)
    {
        $this->_str = $str->_str . $this->_str;
        return $this;
    }

    public function endsWith(self $str)
    {

    }

    public function __toString()
    {
        return $this->_str;
    }
}

class Arr
{

}

class Number
{

}

class Integer extends Number
{

}

class F extends Number
{

}

class BigInt extends Integer
{

}

class Stream
{

}

class File extends Stream
{

}

namespace Demo;

class DemoClass
{
    public function run()
    {

    }
}

$demo = new DemoClass();
$demo->run();

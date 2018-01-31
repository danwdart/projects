<?php
interface Friendable
{
}

class A implements Friendable
{
    const CLASSES = [B::class];

    public function sayHi()
    {
        echo "Hello!".PHP_EOL;
    }
}

class B
{
    public function __construct()
    {
        $this->_a = new Friender(new A(), A::CLASSES);
        $this->_a->sayHi();
    }
}

class C
{
    public function __construct()
    {
        $this->_a = new Friender(new A(), A::CLASSES);
        $this->_a->sayHi();
    }
}

class Friender
{
    private $_object;
    private $_arrAllowedClasses;

    public function __construct(object $object, array $arrAllowedClasses)
    {
        $this->_object = $object;
        $this->_arrAllowedClasses = $arrAllowedClasses;
    }

    public function __call(string $strMethod, $arrArgs)
    {
        $strCallingClass = debug_backtrace()[1]["class"];
        //echo "$strMethod called on instance of ".get_class($this->_object)." by ".$strCallingClass.PHP_EOL;
        if (!in_array($strCallingClass, $this->_arrAllowedClasses)) {
            throw new Exception("Disallowed call to instance of ".get_class($this->_object)." by non-friend ".$strCallingClass);
        }
        return call_user_func_array([$this->_object, $strMethod], $arrArgs);
    }

    public function __get(string $strProperty)
    {
        //echo "$strProperty requested on instance of ".get_class($this->_object).PHP_EOL;
        return $this->_object->$strProperty;
    }

    public function __set(string $strProperty, $mixedValue)
    {
        //echo "$strProperty set on instance of ".get_class($this->_object).PHP_EOL;
        return $this->_object->$strProperty = $mixedValue;
    }
}

new B();
new C();

<?php
class Checkout_Loader_Autoloader_Model implements Zend_Loader_Autoloader_Interface
{
    private $_path;

    public function __construct($path)
    {
        $this->_path = realpath($path);
    }

    public function autoload($class)
    {
        $class = str_replace('_', '/', $class);

        $file = sprintf("%s/%s.php", $this->_path, $class);

        if(file_exists($file))
        {
            require_once($file);
            return true;
        }

        return false;
    }
}

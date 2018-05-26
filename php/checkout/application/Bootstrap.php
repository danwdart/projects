<?php

class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
{
    protected function _initDocType()
    {
        $this->bootstrap('view');
        $view = $this->getResource('view');
        $view->doctype('XHTML1_STRICT');
    }

    protected function _initAutoload()
    {
        $autoloader = Zend_Loader_Autoloader::getInstance();
        $autoloader->registerNamespace('Checkout_');
        $autoloader->pushAutoloader(new Checkout_Loader_Autoloader_Model(APPLICATION_PATH . '/models/'));
    }
}


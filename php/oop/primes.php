<?php
class number
{
    private $factors = array();
    private $primeFactors = array();
    private $value;
    private $prime;
    public function setValue($value)
    {
        $this->value = $value;
    }
    public function getFactors()
    {
        for ($n = 1; $n <= $this->value; $n++)
        {
            if ($this->value % $n = 0)
            {
                $this->factors[] = $n;
            }
        }
    }
    public function isPrime()
    {
        if (count($this->factors()) == 2)
        {
            return true;
        }
        return false;
    }
    public function getNextPrime()
    {
        
    }
    public function getPrimeFactors()
    {




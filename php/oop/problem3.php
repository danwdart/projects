<?php
class Primes
{
    private $_number;
    private $_doomedNumber;
    private $_primefactors = array();
    public static function countFactors($value)
    {
        $numPrimes = 0;
        for ($i = 1; $i <= $value; $i++)
        {
            if (($value % $i) == 0)
            {
                $numPrimes++;
            }
        }
        return $numPrimes;
    }
    public static function isPrime($value)
    {
        return (Primes::countFactors($value) == 2);
    }
    public function setValue($value)
    {
        $this->_number = $value;
    }
    public function getPrimeFactors()
    {
        $try = 2;
        $primeFactors = array();
        $tempno = $this->_number;
        while ($tempno > 1)
        {
            if ($tempno % $try == 0)
            {
                $tempno /= $try;
                $primeFactors[] = $try;
            }
            else 
            {
                while (!Primes::isPrime($try))
                    {
                        $try++;
                    }
            }
        }
        return $primeFactors;
    }
}

$veryBigNumber = new Primes();
$veryBigNumber->setValue(512);
echo var_dump($veryBigNumber->getPrimeFactors());





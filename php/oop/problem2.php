<?php
class number {
    private $evenFibs = array();
    public function __construct()
    {
    }
    public static function isEven($value)
    {
        return ($value % 2 == 0);
    }
    private $arr = array();
    public function generateFibs($limit)
    {
        $this->arr[] = 1;
        $this->arr[] = 1;
        $a = 2;
        for (;; )
        {
            $next  = $this->arr[$a-1] + $this->arr[$a-2];
            if ($next > $limit) { break; }
            $this->arr[] = $next;
            $a++;
        }
        return $this->arr;
    }
    public function getEvenFibs($limit)
    {
        $arr = $this->generateFibs($limit);
        $arr2 = array();
        foreach ($arr as $arrval) {
            if (number::isEven($arrval))
            {
                $arr2[] = $arrval;
            }
        }
        return $arr2;
    }
}
$bob = new number();
echo array_sum($bob->getEvenFibs(4000000));


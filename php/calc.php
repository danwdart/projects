<?php
//$strK = 'v2grrcjmxdd3hh39g9wdbcd8w';
$strK = 'ThisIsSomeSampleDataToProcessHaHaHa123';
$g = gmp_init($strK, 62);
echo 'Factoring '.gmp_strval($g).PHP_EOL;
$ok = false;
$n = 2;
$arrOut = array();
while ($ok == false) {
    $a = gmp_div_qr($g, $n);
    $q = $a[0];
    $r = $a[1];
    if ('0' == gmp_strval($r)) {
        if ('1' == gmp_strval($q)) {
            $ok = true;
            break;
        }
        $arrOut[] = gmp_strval($q);
        echo 'Found: '.gmp_strval($n).PHP_EOL;
        $g = $q;
    } else {
        $n = gmp_nextprime($n);
    }
}

var_dump($arrOut);

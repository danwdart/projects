<?php

function base_convert_g($intNum, $intBaseFrom, $intBaseTo)
{
    return gmp_strval(gmp_init($intNum, $intBaseFrom), $intBaseTo);
}

function primefactors($intNum)
{
    $start = gmp_init($intNum);
    $intDivisor = gmp_init(2);

    $arrPf = array();
    while (1 < gmp_strval($start)) {
        $arrDiv = gmp_div_qr($start, $intDivisor);
        if (0 == gmp_strval($arrDiv[1])) {
            $start = $arrDiv[0];
            $arrPf[] = $intDivisor;
        } else {
            $intDivisor = gmp_nextprime($intDivisor);
        }
    }

    return array_map('gmp_strval', $arrPf);
}

$key = $_GET['key'];
die(var_dump(primefactors($key)));

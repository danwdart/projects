<?php
$dim = $argv[1];
$base = $argv[2];

function dr($n) {
    return $n<10?

for($i = 1; $i < $dim; $i++) {
    for ($j = 1; $j < $dim; $j++) {
        echo dr($i*$j);
    }
    echo PHP_EOL;
}

<?php

function copy($a) {
    return [$a, $a];
}

function consume($a) {
    return null;
}

function fst($a) {
    return $a[0];
}

function snd($a) {
    return $a[1];
}
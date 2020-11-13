<?php
// Find the sum of all the multiples of 3 or 5 below 1000.

for ($n = 1; $n <= 999; $n++)
{
    if ((($n % 3) == 0) || (($n % 5) == 0))  
    {
        $tot += $n;
    }
    
}
echo $tot;

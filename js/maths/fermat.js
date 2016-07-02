for (let i = 1; i <= 100; i++) {
    for (let j = 3; j <= i; j++) {
        for (let k = 1; k <= 100; k++) {
            let offby = Math.abs(i ** 3 + j ** 3 - k ** 3);
            if (offby <= ((k**3)/10000))
                console.log(j+'³ + '+i+'³ = '+k+'³ +- 0.01% (actual value off by '+offby+')');

        }
    }
}

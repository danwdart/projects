for (let i = 1; i <= 100; i++) {
    for (let j = 1; j <= i; j++) {
        for (let k = 1; k <= j; k++) {
            for (let l = 1; l <= 100; l++) {
                if (i ** 3 + j ** 3 + k ** 3 == l ** 3)
                    console.log(k + '³ + '+j+'³ + '+i+'³ = '+l+'³');
            }
        }
    }
}

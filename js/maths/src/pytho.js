for (let i = 1; i <= 100; i++) {
    for (let j = 1; j <= i; j++) {
        for (let k = 1; k <= 100; k++) {
            if (i ** 2 + j ** 2 == k ** 2)
                console.log(j+`² + `+i+`² = `+k+`²`);
        }
    }
}

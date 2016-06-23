let mul = 1,
    i = 1,
    piover4 = 0;
for (let it = 0; it < 1000000; it++) {
    piover4 += mul/i;
    console.log(
        'Iteration', it,
        'Pi = ', 4 * piover4,
        'Average Pi = ',
            2 * (
                piover4 +
                (
                    piover4 + (
                        mul / (
                            i + 1
                        )
                    )
                )
            )
    );
    mul *= -1;
    i += 2;
}

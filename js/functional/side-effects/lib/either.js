export const Left = x => ({
    unwrap: () => x,
    map: () => Left(x),
    fold: f => f(x)
});

export const Right = x => ({
    unwrap: () => x,
    map: f => Right(f(x)),
    fold: (_,f) => f(x),
});
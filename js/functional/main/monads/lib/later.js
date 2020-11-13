export const later = x => () => x
export const laterMapFromLater = l => f => later(f(l()))
export const lazyLaterMapFromLater = l => f => () => f(l())
export const laterMapFromValue = x => f => later(f(x))
export const lazyLaterMapFromValue = x => f => () => f(x)

export const actions: {[name: string]: Function} = {
    log: (attrs: {[name: string]: string}) =>
        (...children: any[]) =>
            () =>
                console.log(attrs, children),
    number: (_attrs: {[name: string]: string}) =>
        (...children: any[]) =>
            Number(children[0]),
    mul: (_attrs: {[name: string]: string}) => 
        (...children: number[]) =>
            children.reduce((a: number, b: number) => a * b, 1),
};

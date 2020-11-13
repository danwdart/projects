import {actions} from "./actions";

export const exec = (fn: string, attrs: string[], ...children: any[]) => {
    if ("undefined" !== typeof actions[fn]) {
        return actions[fn](attrs)(...children);
    }
    throw new Error(`Undefined action: ${fn}`);
}
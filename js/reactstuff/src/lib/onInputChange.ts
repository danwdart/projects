import {ChangeEvent, SetStateAction} from 'react';

type Callback = (value: SetStateAction<string>) => void;
type Changeable = ChangeEvent<HTMLInputElement>;

export default (fn: Callback) => (ev: Changeable) => fn(ev.target.value);
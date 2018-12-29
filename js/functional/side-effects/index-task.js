import fs from 'fs';

import {Taskify, eitherToTask} from './lib/task';

const tWriteFile = Taskify(fs.writeFile);
const tReadFile = Taskify(fs.readFile);
const tUnlink = Taskify(fs.unlink);

const FILE = 'a';
const CONTENTS = '{"I have no idea": "How this is happening"}';

const getDebugExpression = () => 'hi, just some kind of debug in between';
const toString = x => x.toString();

const main = tWriteFile(FILE, CONTENTS)
    .flatMap(eitherToTask)
    .map(getDebugExpression)
    .map(console.debug)
    .flatMap(() => tReadFile(FILE))
    .flatMap(eitherToTask)
    .map(toString)
    .map(console.log)
    .flatMap(() => tUnlink(FILE))
    .flatMap(eitherToTask)
    .map(() => 0);

main.fork(x => console.error(x.unwrap()), console.log);
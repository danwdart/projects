/* eslint-disable */
import {cy, addNode, addEdge, refresh} from './lib.js';

const numNodes = 30;

for (let i = 1; i <= numNodes; i++) {
    addNode(i);
}
for (let i = 1; i <= numNodes; i++) {
    for (let j = 1; j <= numNodes; j++) {
        let sq = Math.sqrt(i + j);
        if (0 === sq - Math.floor(sq)) {
            addEdge(i, j);
        }
    }
}
refresh();

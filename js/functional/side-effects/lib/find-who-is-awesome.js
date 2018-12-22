import {JSDOM} from 'jsdom';
import {ATTR, QS} from './constants';

export const findWhoIsAwesome = responseString => new JSDOM(responseString)
    .window
    .document
    .querySelector(QS)
    .getAttribute(ATTR);
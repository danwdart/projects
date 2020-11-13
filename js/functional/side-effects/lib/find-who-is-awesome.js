import {JSDOM} from 'jsdom';
import {ATTR, QS} from './constants';

//eslint-disable-next-line cleanjs/no-new
export const findWhoIsAwesome = responseString => new JSDOM(responseString)
    .window
    .document
    .querySelector(QS)
    .getAttribute(ATTR);
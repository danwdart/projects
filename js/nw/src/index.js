var fs = require('fs'),
    path = '/etc/passwd',
    de = document.documentElement,
    ta = document.createElement('textarea');

de.appendChild(ta);

ta.value = fs.readFileSync(path).toString();

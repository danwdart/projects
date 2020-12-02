fetch("/cgi-bin/interpreted.hs")
    .then(x => x.text())
    .then(x => document.querySelector("#content1").innerHTML = x);

fetch("/cgi-bin/compiled")
    .then(x => x.text())
    .then(x => document.querySelector("#content2").innerHTML = x);
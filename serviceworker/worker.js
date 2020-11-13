addEventListener('fetch', function(event) {
    console.log("Fetching");
  event.respondWith(new Response("Hello world!"));
});


addEventListener('install', function(event) {
    console.log("installed")
  //event.waitUntil();
});

addEventListener('activate', function(event) {
    console.log("activated");
});

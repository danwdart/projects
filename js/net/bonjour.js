var bonjour = require('bonjour')()
 
// advertise an HTTP server on port 3000
bonjour.publish({ name: 'My Web Server', type: 'http', port: 3000 })
 
// browse for all http services
bonjour.find({ /*type: 'http'*/ }, function (service) {
  console.log('Found a server:', service)
})

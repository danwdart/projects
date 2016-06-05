io = require('socket.io').listen(1337);
io.sockets.on('connection', function (socket) {
    socket.emit('message', { hello: 'from server' });
    socket.broadcast.emit('message', 'user connected');
    socket.on('message', function (data) {
        console.log('message', data);
        socket.broadcast.emit('message', {echo: data});
    });
    socket.on('desc', function(data) {
        console.log('desc', data);
        socket.broadcast.emit('desc', data);
        socket.broadcast.emit('message', {type: 'desc', data: data});
    });
    socket.on('candidate', function(data) {
        console.log('candidate', data);
        socket.broadcast.emit('candidate', data);
        socket.broadcast.emit('message', {type: 'candidate', data: data});
    });
    socket.on('disconnect', function() {
        socket.broadcast.emit('client disconnect', {id: socket.id});
    });
});

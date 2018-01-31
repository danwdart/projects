io = require(`socket.io`).listen(1337);
io.sockets.on(`connection`, function (socket) {
    socket.emit(`message`, { hello: `from server` });
    socket.broadcast.emit(`message`, `user connected`);
    socket.on(`message`, function (data) {
    });
    socket.on(`desc`, function(data) {
        socket.broadcast.emit(`message`, {type: `desc`, data: data});
    });
    socket.on(`candidate`, function(data) {
        socket.broadcast.emit(`message`, {type: `candidate`, data: data});
    });
    socket.on(`disconnect`, function() {
        socket.broadcast.emit(`client disconnect`, {id: socket.id});
    });
});

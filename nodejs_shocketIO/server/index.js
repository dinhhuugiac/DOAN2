var http = require('http');
var express = require('express');
var socketIO = require('socket.io');
var app = express();
var server = http.createServer(app);
var io = socketIO(server);
var db = [];
var lastDataTimestamp = Date.now();
var esp32Connected = true;

io.on('connection', function (socket) {
    console.log('Một người dùng đã kết nối');
    socket.emit('initialData', db);

    socket.on('disconnect', function () {
        console.log('Người dùng đã ngắt kết nối');
    });
});

app.get('/update', function (req, res) {
    lastDataTimestamp = Date.now();
    var lat = req.query.lat;
    var lon = req.query.lon;

    if (lat !== undefined && lon !== undefined) {
        var newData = {
            lat: parseFloat(lat),
            lon: parseFloat(lon)
        };

        db.push(newData);
        console.log(req.url);
        console.log(newData);

        io.emit('update', newData);
        res.end();
    } else {
        res.status(400).send('Bad Request: lat and lon are required parameters.');
    }
});

app.get('/get', function (req, res) {
    res.writeHead(200, {
        'Content-Type': 'application/json'
    });
    res.end(JSON.stringify(db));

    db = [];
});

app.get('/disconnect', function (req, res) {
    esp32Connected = false;
    console.log('ESP32 đã ngắt kết nối.');
    res.writeHead(200, {
        'Content-Type': 'text/plain'
    });
    res.end('Ngắt kết nối thành công');
});

function checkConnection() {
    var currentTime = Date.now();
    var elapsedTime = currentTime - lastDataTimestamp;

    if (elapsedTime > 15000 && esp32Connected) {
        esp32Connected = false;
        console.log('ESP32 đã ngắt kết nối.');
    }
}

setInterval(checkConnection, 1000);

server.listen(8000);
console.log('Máy chủ đang lắng nghe trên cổng 8000');



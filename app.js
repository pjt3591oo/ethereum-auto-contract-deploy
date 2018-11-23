var express = require('express');
var fs = require('fs')
var app = express();

app.use(express.static('dist'));

app.get('/', (req, res, next) => {
    fs.readFile('./dist/index.html', (err, data) => {
        res.end(data)
    })
})

var server = app.listen(3000, function(){
    console.log("Express server has started on port 3000")
})
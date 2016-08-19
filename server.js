var express = require("express");
var app = express();
var server = require("http").createServer(app);
var io = require("socket.io").listen(server);
var fs     = require("fs");
var async = require('async');
var db = require('./db');


var mysql = require("mysql");
var TABLE_USER = 'user';
var TABLE_ROOM = 'roomchat';


var ip = process.env.OPENSHIFT_NODEJS_IP || '127.0.0.1';
var port = process.env.OPENSHIFT_NODEJS_PORT || 3000;

//server.listen(port, ip);
server.listen(port, ip);


var usersOnline = [];

io.sockets.on('connection',function (socket)
              {
              
              console.log("Co nguoi connect ne");
              
              socket.on('client-send-information', function(userName, passWord, Email, Phone, Image) {
                        
                        var ketqua = true;
                        var check = 2;
                        var data = {
                        username: userName,
                        password: passWord,
                        email: Email,
                        phone: Phone,
                        image: Image
                        };
                        
                        // console.log('data',data);
                        
                        async.waterfall([
                                         function(callback) {
                                         db.query('select * from `user` where `username`="'+data.username+'"', function(err, done) {
                                                  // console.log('result:',done);
                                                  callback(null, done);
                                                  })
                                         },
                                         function(rows, callback) {
                                         if (rows == 0) {
                                         db.query('INSERT INTO user SET ?', data,
                                                  function(err, res) {
                                                  if (res) {
                                                  check = 0;
                                                  callback(null, true);
                                                  }
                                                  //console.log("ERROR : " + err);
                                                  //console.log("Result : " + res);
                                                  });
                                         } else {
                                         check = 1;
                                         callback(null, false);
                                         }
                                         }
                                         ], function(err, result) {
                                        // 0 là thành công , 1 là tên user đã tồn tại , 2 là lỗi gì đó
                                        socket.emit('result-register', {
                                                    noidung: check
                                                    });
                                        
                                        });
                        });
              
              
              socket.on('client-send-message',function (roomTitle,name,message,image)
                        {
                        var ndc = {name : name, message:message, image:image};
                        io.to(roomTitle).emit("server-send-message",{noidung:ndc});
                        });
              
              
              
              socket.on('client-send-login',function (userName,passWord)
                        {
                        var kt = 1;
                        var user = null;
                        // console.log("user " + username + "pass")
                        db.query('select * from `user`', function(err, rows) {
                                 // console.log('result:'+rows);
                                 
                                 for (var i=0;i<rows.length;i++)
                                 {
                                 if (rows[i].username == userName){
                                 // ketqua = 1;
                                 if (rows[i].password == passWord)
                                 {
                                 kt = 0;
                                 user = rows[i];
                                 }
                                 else
                                 {
                                 kt = 2;
                                 }
                                 
                                 break;
                                 }
                                 
                                 }
                                 // socket.emit('server-send-avatar-profile', {hinhanh:image});
                                 var data={
                                 kt:kt,
                                 information:user
                                 };
                                 socket.emit('result-login',
                                             {
                                             noidung : data
                                             
                                             // hinhanh : image
                                             }
                                             // },{hinhanh:image}
                                             );
                                 
                                 
                                 
                                 });
                        });
              
              socket.on('client-join-room',function (roomTitle)
                        {
                        // console.log(usersOnline[roomTitle] + "---" + usersOnline.roomTitle);
                        if(usersOnline[roomTitle] > 0)
                        {
                        usersOnline[roomTitle]++; 
                        console.log("true");
                        }
                        else {
                        usersOnline[roomTitle] = 1;
                        console.log("false");
                        }
                        
                        console.log(usersOnline[roomTitle]);
                        socket.join(roomTitle);
                        return usersOnline;
                        });
              
              socket.on('client-out-room',function (roomTitle)
                        {
                        if (usersOnline[roomTitle] > 0)
                        usersOnline[roomTitle]--;
                        console.log("out" + usersOnline[roomTitle]);
                        socket.leave(roomTitle);
                        return usersOnline;
                        });
              
              socket.on('client-login-successful', function() {
                        db.query('SELECT * FROM `roomchat`',function(err,rows){
                                 socket.emit('server-send-list-room',{
                                             noidung:rows
                                             });
                                 // socket.emit('server-send-image',{
                                 // 	noidung:rows
                                 // });
                                 console.log(rows);
                                 });
                        });
              
              socket.on('client-create-room', function(userName, roomTitle,description, roomPassword, roomImage) {
                        db.query('SELECT * FROM `roomchat` WHERE owner = ?', userName, function(err, rows) {
                                 if (rows.length > 0) {
                                 socket.emit('result-create-room', {
                                             // noidung: rows
                                             noidung: {}
                                             });
                                 // console.log(rows + "1aa");
                                 } else {
                                 var data = {
                                 owner: userName,
                                 name: roomTitle,
                                 password: roomPassword,
                                 description : description,
                                 image : roomImage
                                 };
                                 db.query('insert into `roomchat` SET ?', data, function(err, roomchat) {
                                          // db.query("select * from `roomchat`",function(rows){
                                          io.sockets.emit('result-create-room',{
                                                          noidung:data
                                                          });
                                          // });
                                          // console.log("0");
                                          });
                                 
                                 }
                                 });
                        });
              
              
              });




app.get("/", function(req, res){
        
        
        var con = require('./db');
        
        con.query('select * from user',
                  function(err,rows,fields)
                  {
                  if (!err)
                  {
                  var s = "";
                  for (var i = 0; i < rows.length; i++) {
                  s+=rows[i].id;
                  s+=rows[i].username;
                  s+=rows[i].password;
                  s+=rows[i].phone;
                  
                  };
                  res.send(s);
                  }
                  
                  }
                  )
        
        
        con.end();
        
        
        });
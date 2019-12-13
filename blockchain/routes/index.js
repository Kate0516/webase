var express = require('express');
var router = express.Router();
var caddr;//contract address
var account;
/* GET home page. */

router.get('/', function (req, res) {
    res.render('index', { title: '主页' });
  });

router.post('/', function (req, res) {
    caddr = req.body.caddr;
    console.log(caddr);
    //res.writeHead(200, {'Content-Type': 'text/plain'});
    res.redirect('/');
    //res.end();
  });

router.get('/account', function (req, res) {
    res.render('account', { title: '切换公司' });
  });
  
router.post('/account', function (req, res) {
  account = req.body.account;
  console.log(account);
        res.redirect('/account');
  });
  
router.get('/sign', function (req, res) {
    res.render('sign', { title: '签发' });
  });
  
router.post('/sign', function (req, res) {
  var amount = req.body.amount,
    receiver = req.body.receiver,
    time = req.body.time;

  var http=require('http');
  var arr = [];
  arr.push(receiver);
  arr.push(amount);
  arr.push(time);
 var post_data = {
    "useAes":false,
    "user":account,
    "contractName":"DebtTrans1",
    "contractAddress":caddr,
    "funcName":"SignReceipt",
    "funcParam":arr,
    "groupId" :"1"
};   
 
var content=JSON.stringify(post_data);

 var options = {
    hostname: '127.0.0.1',
    port: 5002,
    path: '/WeBASE-Front/trans/handle',
    method: 'POST',
    headers:{"Content-type":"application/json"}
  };
console.log("post options:\n",options);
console.log("content:",content);
console.log("\n");

var req = http.request(options, function(res) {
 
  console.log("statusCode: ", res.statusCode);
  console.log("headers: ", res.headers);
 
  var _data='';
 
  res.on('data', function(chunk){
     _data += chunk;
  });
 
  res.on('end', function(){
     console.log("\n--->>\nresult:",_data) 
   }); 
});

req.write(content);
req.end();
res.redirect('/sign');
  });
  
router.get('/transfer', function (req, res) {
    res.render('transfer', { title: '转让' });
  });
  
router.post('/transfer', function (req, res) {
  var amount = req.body.amount,
    receiver = req.body.receiver;

  var http=require('http');
  var arr = [];
  arr.push(receiver);
  arr.push(amount);

 var post_data = {
    "useAes":false,
    "user":account,
    "contractName":"DebtTrans1",
    "contractAddress":caddr,
    "funcName":"TransferDebtReceipt",
    "funcParam":arr,
    "groupId" :"1"
};   
 
var content=JSON.stringify(post_data);

 var options = {
    hostname: '127.0.0.1',
    port: 5002,
    path: '/WeBASE-Front/trans/handle',
    method: 'POST',
    headers:{"Content-type":"application/json"}
  };
console.log("post options:\n",options);
console.log("content:",content);
console.log("\n");

var req = http.request(options, function(res) {
 
  console.log("statusCode: ", res.statusCode);
  console.log("headers: ", res.headers);
 
  var _data='';
 
  res.on('data', function(chunk){
     _data += chunk;
  });
 
  res.on('end', function(){
     console.log("\n--->>\nresult:",_data) 
   }); 
});

req.write(content);
req.end();
res.redirect('/transfer');
  });
  
router.get('/finance', function (req, res) {
    res.render('finance', { title: '融资' });
  });
  
router.post('/finance', function (req, res) {
  var borrower = req.body.borrower,
    receiver = req.body.receiver;

 var http=require('http');
  var arr = [];
  arr.push(borrower);
  arr.push(receiver);
  
 var post_data = {
    "useAes":false,
    "user":account,
    "contractName":"DebtTrans1",
    "contractAddress":caddr,
    "funcName":"Loan",
    "funcParam":arr,
    "groupId" :"1"
};   
 
var content=JSON.stringify(post_data);

 var options = {
    hostname: '127.0.0.1',
    port: 5002,
    path: '/WeBASE-Front/trans/handle',
    method: 'POST',
    headers:{"Content-type":"application/json"}
  };
console.log("post options:\n",options);
console.log("content:",content);
console.log("\n");

var req = http.request(options, function(res) {
 
  console.log("statusCode: ", res.statusCode);
  console.log("headers: ", res.headers);
 
  var _data='';
 
  res.on('data', function(chunk){
     _data += chunk;
  });
 
  res.on('end', function(){
     console.log("\n--->>\nresult:",_data) 
   }); 
});

req.write(content);
req.end();
res.redirect('/finance');
  });
  
router.get('/pay', function (req, res) {
    res.render('pay', { title: '结算' });
  });

router.post('/pay', function (req, res) {
   var http=require('http');
  //var arr = [];
  //arr.push(borrower);
  //arr.push(receiver);
  
 var post_data = {
    "useAes":false,
    "user":account,
    "contractName":"DebtTrans1",
    "contractAddress":caddr,
    "funcName":"PayDebt",
    //"funcParam":arr,
    "groupId" :"1"
};   
 
var content=JSON.stringify(post_data);

 var options = {
    hostname: '127.0.0.1',
    port: 5002,
    path: '/WeBASE-Front/trans/handle',
    method: 'POST',
    headers:{"Content-type":"application/json"}
  };
console.log("post options:\n",options);
console.log("content:",content);
console.log("\n");

var req = http.request(options, function(res) {
 
  console.log("statusCode: ", res.statusCode);
  console.log("headers: ", res.headers);
 
  var _data='';
 
  res.on('data', function(chunk){
     _data += chunk;
  });
 
  res.on('end', function(){
     console.log("\n--->>\nresult:",_data) 
   }); 
});

req.write(content);
req.end();
res.redirect('/pay');
  });

router.get('/check', function (req, res) {
    res.render('check', { title: '查询' });
  });

router.post('/check', function (req, res) {
   var http=require('http');
  var arr = [];
  arr.push(account);
  //arr.push(receiver);
  
 var post_data = {
    "useAes":false,
    "user":account,
    "contractName":"DebtTrans1",
    "contractAddress":caddr,
    "funcName":"getBalance",
    "funcParam":arr,
    "groupId" :"1"
};   
 
var content=JSON.stringify(post_data);
console.log(post_data);
 var options = {
    hostname: '127.0.0.1',
    port: 5002,
    path: '/WeBASE-Front/trans/handle',
    method: 'POST',
    headers:{"Content-type":"application/json"}
  };
console.log("post options:\n",options);
console.log("content:",content);
console.log("\n");

var req = http.request(options, function(res1) {
 
  console.log("statusCode: ", res1.statusCode);
  console.log("headers: ", res1.headers);
 
  var _data='';
 
  res1.on('data', function(chunk){
     _data += chunk;
  });
 
  res1.on('end', function(){
     console.log("\n--->>\nresult:",_data) 
   }); 
  var str1 = "a";
  str1 += _data;
  res.render('check', { title: str1});
});

req.write(content);
req.end();
//res.redirect('/check');
  });


module.exports = router;

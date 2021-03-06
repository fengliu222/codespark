fs = require 'fs';
encryption = require '../lib/encryption.js'
db = require '../db/db.js';

#页面相关
exports.index = (req,res) ->
	res.render 'index';

#文件上传相关
exports.upload = (req,res) ->
	if req.session.username
		res.render 'upload'
	else
		res.redirect '/login'

exports.file_upload = (req,res)->
	files = req.files;
	fs.mkdir "uploads\\"+req.session.user_id, ->
		fs.rename files.file.path,'uploads\\'+req.session.user_id+'\\'+files.file.name,->
			res.redirect('/upload');
			;
		return;
	return;

#读代码相关
exports.code = (req,res) ->
	db.getUserId req.params.username,(cb)->
		uuid = cb;
		fs.readFile 'uploads\\'+uuid+"\\"+req.params.code,"utf8",(err, data)->
			throw err if err;
			res.render "code",
			content : data
			return;
		return;

#注册相关
exports.register = (req,res) ->
		res.render "register" ;
		return;

exports.doregister = (req,res) ->
	db.insert 
		email : req.param('email'), 
		username : req.param('username'),
		password : encryption.md5(req.param('password'))
	res.redirect('/upload')
	return;

#登录相关
exports.login = (req,res) ->
	res.render "login";
	return;
exports.dologin = (req,res) ->
	db.verifyLogin req.param('email'),encryption.md5(req.param('password')),(cb,user_id,username)->
		status = cb;
		if status
			req.session.user_id = user_id;
			req.session.username = username;
			res.redirect('/upload')
	return;
exports.logout = (req,res) ->
		req.session = null;
		res.redirect("/");

#个人页面相关
exports.i = (req,res) ->
	res.render("i");
exports.write = (req,res) ->
	res.render("write");

#代码市场,活跃度
exports.place = (req,res) ->
	res.render("place");

#评论
exports.review = (req,res) ->
	;

# #讨论
# exports.discuss = (req,res) ->
# 	;

# #积分规则
# exports.rule = (req,res) ->
# 	;
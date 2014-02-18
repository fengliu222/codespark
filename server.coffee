express = require "express";
path = require "path";
routes = require "./routes";
app = express();

#configure

app.configure -> 
	app.locals.pretty = true;
	app.set "port",process.env.PORT || 18080;
	app.set 'views',__dirname+'/views'
	app.use express.static(path.join __dirname,'/public');
	app.set 'view engine','jade';
	app.use express.favicon();
	app.use express.logger('dev');
	app.use express.bodyParser({uploadDir:'./uploads'});
	app.use express.methodOverride();
	app.use express.cookieParser('secret');
	app.use express.session();
	app.use (req,res,next) ->
		res.locals.session = req.session;
		next();
		return;
	return;

app.configure 'development',-> 
	app.use express.errorHandler();
	return;

app.get '/',routes.index;
app.get '/upload',routes.upload;
app.post '/file_upload',routes.file_upload;
app.get '/code',routes.code;
app.get '/login',routes.login;
app.get '/logout',routes.logout;
app.listen 18080;
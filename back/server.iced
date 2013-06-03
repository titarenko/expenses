express = require "express"
log = require "./log"
lessCompiler = require "./lessCompiler"
icedCompiler = require "./icedCompiler"
resources = require "./resources"
mongoose = require "mongoose"
require "express-resource"
auth = require './auth'

##########
# Config #
##########

connectionString = process.env.MONGO_CS or "mongodb://localhost/expenses"
port = process.env.PORT or 3000

#################
# DB connection #
#################

mongoose.connect connectionString, (error) ->
	log.error error if error
	log.info "Connected to #{connectionString}." unless error

#######################
# Web server start up #
#######################

app = express()

frontDir = __dirname + "/../front"

app.use express.bodyParser()
app.use express.cookieParser()
app.use express.session
  secret: "zsldhI&*Y*&Hlkasjd"

app.use lessCompiler frontDir
app.use icedCompiler frontDir
  
app.use express.static frontDir + "/lib"	

app.set "view engine", "jade"
app.set "views", __dirname + "/views"

auth app

app.get "/", (req, res) ->
	if req.isAuthenticated()
		res.redirect "/app"
	else
		res.render "landing"

app.get "/app", (req, res) ->
	res.render "app"

for resource, impl of resources
	auth.protect "/#{resource}"
	app.resource resource, impl

app.listen port, -> 
	log.info "Listening on #{port}..."

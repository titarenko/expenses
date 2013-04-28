express = require "express"
log = require "./log"
lessCompiler = require "./lessCompiler"
icedCompiler = require "./icedCompiler"
require "express-resource"
resources = require "./resources"
mongoose = require "mongoose"
models = require "./models/models"
auth = require "./auth"
http = require 'http'
socket = require 'socket.io'
bus = require './bus'
passport = require 'passport'

connectionString = process.env.CONNECTION_STRING or "mongodb://localhost/expenses"
port = process.env.PORT or 3000

mongoose.connect connectionString, (error) ->
	log.error error if error
	log.info "Connected to #{connectionString}." unless error

app = express()
server = http.createServer app
io = socket.listen server

frontDir = __dirname + "/../front"

app.use express.bodyParser()
app.use express.cookieParser()
app.use express.session
  secret: "expenses-app"

app.use lessCompiler frontDir
app.use icedCompiler frontDir

app.use passport.initialize()
app.use passport.session()
  
app.use auth

app.use express.static frontDir + "/lib"

app.set "view engine", "jade"
app.set "views", __dirname + "/views"

app.get "/", (req, res) ->
	res.render "landing"

guard = (req, res, next) ->
	if req.isAuthenticated()
		next()
	else
		res.statusCode = 403
		res.end()

# app.all "/expenses", guard
#app.use "/expenses", guard

# app.resource "expenses", resources.expenses
# app.resource "items", resources.items
# app.resource "places", resources.places
# app.resource "prices", resources.prices

server.listen port, -> 
	log.info "Listening on #{port}..."

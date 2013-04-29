express = require "express"
log = require "./log"
lessCompiler = require "./lessCompiler"
icedCompiler = require "./icedCompiler"
resources = require "./resources"
mongoose = require "mongoose"
require "express-resource"
auth = require './auth'

connectionString = process.env.CONNECTION_STRING or "mongodb://localhost/expenses"
port = process.env.PORT or 3000

mongoose.connect connectionString, (error) ->
	log.error error if error
	log.info "Connected to #{connectionString}." unless error

app = express()

frontDir = __dirname + "/../front"

app.use express.bodyParser()
app.use express.cookieParser()
app.use express.session
  secret: "expenses-app"

app.use lessCompiler frontDir
app.use icedCompiler frontDir
  
app.use express.static frontDir + "/lib"	

app.set "view engine", "jade"
app.set "views", __dirname + "/views"

auth app

app.get "/", (req, res) ->
	res.render "landing"

app.get "/app", (req, res) ->
	res.render "app"

guard = (req, res, next) ->
	if req.isAuthenticated()
		next()
	else
		res.statusCode = 403
		res.end()

# app.all "/expenses", guard
# app.use "/expenses", guard

app.resource "expenses", resources.expenses
app.resource "items", resources.items
app.resource "places", resources.places
app.resource "prices", resources.prices

app.listen port, -> 
	log.info "Listening on #{port}..."

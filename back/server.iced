express = require "express"
log = require "./log"
lessCompiler = require "./lessCompiler"
icedCompiler = require "./icedCompiler"
require "express-resource"
resources = require "./resources"
mongoose = require "mongoose"
passport = require 'passport'
models = require "./models/models"
auth = require "./auth"

passport.use auth.GoogleAuthStrategy

passport.serializeUser (user, done) ->
  done null, user._id

passport.deserializeUser (obj, done) ->
  models.User.getById obj, (err, user) ->
    done null, user

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

app.use passport.initialize()
app.use passport.session()

app.use lessCompiler frontDir
app.use icedCompiler frontDir

app.set "view engine", "jade"
app.set "views", frontDir

app.resource "expenses", resources.expenses
app.resource "items", resources.items
app.resource "places", resources.places
app.resource "prices", resources.prices

app.get "/", (req, res) ->
	res.render "app"

app.get "/auth/google", passport.authenticate('google', 
  { successRedirect: '/', 
  failureRedirect: '/login' , 
  scope: ['https://www.googleapis.com/auth/userinfo.profile','https://www.googleapis.com/auth/userinfo.email'] })

app.get '/oauth2callback', 
  passport.authenticate('google', { successRedirect: '/login', failureRedirect: '/#login' }),
  (req, res) ->
    #res.cookie('auth', 'cookievalue', { maxAge: 900000, httpOnly: true });
    res.redirect '/login'

app.get '/logout',
  (req, res) ->
    req.logout()
    res.redirect('/')

app.get '/login', (req, res) ->
  res.json user: req.user

app.listen port, -> 
	log.info "Listening on #{port}..."
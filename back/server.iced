express = require "express"
log = require "./log"
lessCompiler = require "./lessCompiler"
icedCompiler = require "./icedCompiler"
require "express-resource"
resources = require "./resources"
mongoose = require "mongoose"
passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
models = require "./models/models"
GoogleStrategy = require("passport-google-oauth").OAuth2Strategy

strategy = new GoogleStrategy
  clientID: "836427388747.apps.googleusercontent.com",
  clientSecret: "lMF07R7txxWa_scy0S1D_y6Y",
  callbackURL: "http://localhost:3000/oauth2callback",
  (accessToken, refreshToken, profile, done) ->
    models.User.getOrCreateByGoogleId
      googleId : profile._json.id, 
      email: profile._json.email
      , (err, user) ->
        done err, user

passport.use strategy
passport.serializeUser (user, done) ->
  done null, user

passport.deserializeUser (obj, done) ->
  done null, obj

connectionString = process.env.CONNECTION_STRING or "mongodb://localhost/expenses"
port = process.env.PORT or 3000

mongoose.connect connectionString, (error) ->
	log.error error if error
	log.info "Connected to #{connectionString}." unless error

app = express()

frontDir = __dirname + "/../front"

app.use express.bodyParser()
app.use express.cookieParser()

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
    res.redirect '/login'

app.get '/logout',
  (req, res) ->
    req.logout()
    res.redirect('/')

app.get '/login', (req, res) ->
  res.json user: req.user

app.listen port, -> 
	log.info "Listening on #{port}..."
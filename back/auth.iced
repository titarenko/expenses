passport = require 'passport'
models = require "./models/models"
GoogleStrategy = require("passport-google-oauth").OAuth2Strategy
LocalStrategy = require('passport-local').Strategy

GoogleAuthStrategy = new GoogleStrategy
  clientID: "836427388747.apps.googleusercontent.com",
  clientSecret: "lMF07R7txxWa_scy0S1D_y6Y",
  callbackURL: "http://localhost:3000/oauth2callback",
  (accessToken, refreshToken, profile, done) ->
    models.User.getOrCreateByGoogleId
      googleId : profile._json.id, 
      email: profile._json.email
      , (err, user) ->
        done err, user

passport.use GoogleAuthStrategy

passport.serializeUser (user, done) ->
  done null, user._id

passport.deserializeUser (obj, done) ->
  models.User.getById obj, (err, user) ->
    done null, user

authGoogle =(req, res) ->
  passport.authenticate('google', 
    { successRedirect: '/', 
    failureRedirect: '/login' , 
    scope: ['https://www.googleapis.com/auth/userinfo.profile',
            'https://www.googleapis.com/auth/userinfo.email'] })

oauth2callback = (req, res) ->
  passport.authenticate('google', { successRedirect: '/login', failureRedirect: '/#login' })
  (req, res) ->
    res.redirect '/login'

logout = (req, res) ->
    req.logout()
    res.redirect('/')

login = (req, res) ->
  res.json user: req.user

module.exports = (req, res, next) ->
  switch req.url
    when "/logout"
      logout req, res
    when "/login"
      login req, res
    when "/oauth2callback"
      oauth2callback req, res
    when "/auth/google"
      authGoogle req, res

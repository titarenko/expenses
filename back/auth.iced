passport = require 'passport'
User = require './models/user'
GoogleStrategy = require("passport-google-oauth").OAuth2Strategy
util = require 'util'

module.exports = (app) ->
    app.use passport.initialize()
    app.use passport.session()

    GoogleAuthStrategy = new GoogleStrategy
      clientID: "836427388747.apps.googleusercontent.com",
      clientSecret: "lMF07R7txxWa_scy0S1D_y6Y",
      callbackURL: "http://localhost:3000/accept/google/",
      (accessToken, refreshToken, profile, done) ->
        models.User.getOrCreateByGoogleId
          googleId: profile._json.id, 
          email: profile._json.email
          , (err, user) ->
            done err, user

    passport.use GoogleStrategy

    passport.serializeUser (user, done) ->
        done null, user._id

    passport.deserializeUser (obj, done) ->
        models.User.getById obj, (err, user) ->
            done null, user

    googleAuthentication = passport.authenticate "google",
            successRedirect: '/app',
            failureRedirect: '/' ,
            scope: ['https://www.googleapis.com/auth/userinfo.email']

    app.get "/enter/google/", googleAuthentication

    app.get "/accept/google/", (req, res) ->
        googleAuthentication
        (req, res) ->
            res.redirect "/app"
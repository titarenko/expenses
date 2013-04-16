models = require "./models/models"
GoogleStrategy = require("passport-google-oauth").OAuth2Strategy
LocalStrategy = require('passport-local').Strategy

exports.GoogleAuthStrategy = new GoogleStrategy
  clientID: "836427388747.apps.googleusercontent.com",
  clientSecret: "lMF07R7txxWa_scy0S1D_y6Y",
  callbackURL: "http://localhost:3000/oauth2callback",
  (accessToken, refreshToken, profile, done) ->
    models.User.getOrCreateByGoogleId
      googleId : profile._json.id, 
      email: profile._json.email
      , (err, user) ->
        done err, user
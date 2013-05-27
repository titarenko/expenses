passport = require 'passport'
User = require './models/user'
GoogleStrategy = require("passport-google-oauth").OAuth2Strategy
util = require 'util'

init = (app) ->
	@app = app
	
	app.use passport.initialize()
	app.use passport.session()

	passport.use new GoogleStrategy
		clientID: "836427388747.apps.googleusercontent.com"
		clientSecret: "lMF07R7txxWa_scy0S1D_y6Y"
		callbackURL: "http://localhost:3000/accept/google/",
		(accessToken, refreshToken, profile, done) ->
			User.getOrCreateByGoogleId
				googleId: profile._json.id 
				email: profile._json.email,
				done

	passport.serializeUser (user, done) ->
		done null, user._id.toString()

	passport.deserializeUser (id, done) ->
		done null, new User _id: id

	authenticate = passport.authenticate "google",
		successRedirect: '/app'
		failureRedirect: '/'
		scope: ['https://www.googleapis.com/auth/userinfo.email']

	app.get "/enter/google", authenticate

	app.get "/accept/google", passport.authenticate("google"), (req, res) ->
		res.redirect "/app"

	app.get "/logout", (req, res) ->
		req.logout()
		res.redirect "/"

guard = (req, res, next) ->
	if req.isAuthenticated()
		next()
	else
		res.statusCode = 403
		res.end()

init.protect = (path) -> 
	app.all path, guard

module.exports = init

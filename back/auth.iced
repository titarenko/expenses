passport = require 'passport'
User = require './models/User'
express = require 'express'
LocalStrategy = require('passport-local').Strategy
util = require 'util'

passport.use new LocalStrategy {usernameField: "name"}, (name, password, done) ->
    await User.findByNameOrEmail name, defer error, user
    return done error if error
    return done null, false unless user
    return done null, user if user.isPasswordCorrect password
    done null, false

app = express.application

localAuthentication = passport.authenticate "local",
    successRedirect: "/app"
    failureRedirect: "/"

app.post "/register", (req, res) ->
    User.create
        name: req.params.name
        password: req.params.password
        email: req.params.email
        , (error, user) ->
            if error
                model = util._extend req.params, isRegistration: true
                res.render "landing", model
            else
                localAuthentication req, res

app.post "/login", passport.authenticate "local",
    successRedirect: "/app"
    failureRedirect: "/"

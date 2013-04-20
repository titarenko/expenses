passport = require 'passport'
util = require 'util'

class Backdoor extends passport.Strategy

	constructor: ->
		@name = "backdoor"

	authenticate: (req, options) ->
		@error new Error 'passport.initialize() middleware not in use' unless req._passport
		property = req._passport.instance._userProperty or 'user'
		req[user] = @_getDeveloperAccount() if req.ip == "127.0.0.1"
		@pass()

	_getDeveloperAccount: ->
		name: "Expenses Developer"
		email: "developer@expenses.com" 

module.exports = Backdoor

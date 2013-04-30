mongoose = require 'mongoose'

module.exports = (type, methods) ->
	type.forTenant = (user) ->
		user = user._id if user._id 
		multitenantType = ->
			args = [].slice.call arguments
			args[0]?.user = user
			type.apply @, args
		for name, code of type
			multitenantType[name] = code
		for method in methods
			multitenantType[method] = multitenantType[method].bind multitenantType, user
		multitenantType
	type

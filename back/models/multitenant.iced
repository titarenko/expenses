mongoose = require 'mongoose'

module.exports = (type, methods) ->
	type.forTenant = (user) ->
		user = user._id unless user instanceof mongoose.Types.ObjectId 
		multitenantType = ->
			args = [].slice.call arguments
			type.apply @, args
			@user = user
		for name, code of type
			multitenantType[name] = code
		for method in methods
			multitenantType[method] = multitenantType[method].bind multitenantType, user
		multitenantType
	type

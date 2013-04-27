mongoose = require 'mongoose'

User = mongoose.Schema
	email:
		type: String
		required: true
	passwordHash:
		type: String
	passwordSalt:
		type: String
	googleId:
		type: String

User.statics.getByEmail = (email, done) ->
	@findOne(email: email).exec done

User.statics.getById = (userId, done) ->
	@findOne(_id: userId).exec done

User.statics.getOrCreateByGoogleId = (params, done) ->
	query = googleId: params.googleId
	options = upsert: true
	sort = {}
	update = $set: 
		googleId: params.googleId
		email: params.email
	@collection.findAndModify query, sort, update, options, done

User.statics.removeAll = (done) ->
	@collection.remove {}, {w: 0}, done

module.exports = mongoose.model "users", User

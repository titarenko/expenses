mongoose = require 'mongoose'
bcrypt = require 'bcrypt-nodejs'

User = mongoose.Schema
	name:
		type: String
		required: true
		index: unique: true
	email:
		type: String
	encodedPassword:
		type: String
	googleId:
		type: String
		index: true
	registrationDate:
		type: Date
		default: -> Date.now()
		required: true

User.statics.removeAll = (done) ->
	@collection.remove {}, {w: 0}, done

User.statics.getByNameOrEmail = (email, done) ->
	@findOne($or: [{name: email}, {email: email}]).exec done

User.statics.getById = (userId, done) ->
	@findOne(_id: userId).exec done

User.methods.setPasswordSync = (password, confirmation) ->
	if password == confirmation
		@encodedPassword = bcrypt.hashSync password, bcrypt.genSaltSync()
	else
		throw new Error "Confirmation doesn't match the password."

User.methods.verifyPasswordSync = (password) ->
	bcrypt.compareSync password, @encodedPassword

User.statics.getOrCreateByGoogleId = (params, done) ->
	query = googleId: params.googleId
	options = upsert: true
	sort = {}
	update = $set: 
		name: params.name or params.email
		googleId: params.googleId
		email: params.email
	@collection.findAndModify query, sort, update, options, done

User.pre "validate", (next) ->
	@name = @email unless @name
	next()

User.pre "save", (next) ->
	@name = @email unless @name
	next()

module.exports = mongoose.model "users", User

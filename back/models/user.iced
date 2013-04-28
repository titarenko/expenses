mongoose = require 'mongoose'
bcrypt = require 'bcrypt-nodejs'

User = mongoose.Schema
	name:
		type: String
		required: true
		index: unique: true
	email:
		type: String
	password:
		type: String
		required: true
	googleId:
		type: String
		index: true
	registrationDate:
		type: Date
		default: -> Date.now()
		required: true

User.statics.create = (options, done) ->
	options =
		name: options.name
		email: options.email
		password: bcrypt.hashSync options.password, bcrypt.genSaltSync()
	(new User options).save done

User.statics.removeAll = (done) ->
	@collection.remove {}, {w: 0}, done

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
		name: params.name or params.email
	@collection.findAndModify query, sort, update, options, done

User.pre "validate", (next) ->
	@name = @email unless @name
	next()

module.exports = mongoose.model "users", User

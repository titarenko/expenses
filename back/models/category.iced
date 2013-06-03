mongoose = require "mongoose"
multitenant = require './multitenant'

Category = mongoose.Schema
	name:
		type: String
		index: unique: true
	frequency:
		type: Number
		required: true
		index: true
		min: 0
	user:
		index: true
		type: mongoose.Schema.Types.ObjectId
		required: true

Category.statics.hit = (user, category, done) ->
	query = user: user, name: category
	modification = $inc: frequency: 1
	options = upsert: true
	@update query, modification, options, done

Category.statics.getFrequent = (user, done) ->
	@find(user: user).sort("-frequency").limit(20).exec done

model = mongoose.model "categories", Category
module.exports = multitenant model, [
	"hit"
	"getFrequent"
]

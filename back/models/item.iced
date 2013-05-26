mongoose = require "mongoose"
multitenant = require './multitenant'

Item = mongoose.Schema
	name:
		type: String
		required: true
		index: unique: true
	frequency:
		type: Number
		required: true
		index: true
		min: 0

Item.statics.hit = (user, item, done) ->
	query = user: user, name: item
	modification = $inc: frequency: 1
	options = upsert: true
	@update query, modification, options, done

Item.statics.getFrequent = (user, done) ->
	@find(user: user).sort("-frequency").limit(20).exec done

model = mongoose.model "items", Item
module.exports = multitenant model, [
	"hit"
	"getFrequent"
]

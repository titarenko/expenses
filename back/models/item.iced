mongoose = require "mongoose"
multitenant = require './multitenant'

Item = mongoose.Schema
	category:
		type: String
		required: true
	name:
		type: String
		required: true
		index: unique: true
	frequency:
		type: Number
		required: true
		index: true
		min: 0

Item.statics.hit = (user, category, item, done) ->
	query = user: user, category: category, name: item
	modification = $inc: frequency: 1
	options = upsert: true
	@update query, modification, options, done

Item.statics.getFrequent = (user, category, done) ->
	@find(user: user, category: category).sort("-frequency").limit(20).exec done

model = mongoose.model "items", Item
module.exports = multitenant model, [
	"hit"
	"getFrequent"
]

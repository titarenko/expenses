mongoose = require "mongoose"
multitenant = require './multitenant'

Quantity = mongoose.Schema
	item:
		type: String
		required: true
	value:
		type: Number
		required: true
	user:
		index: true
		type: mongoose.Schema.Types.ObjectId
		required: true

Quantity.statics.hit = (user, item, quantity, done) ->
	query = user: user, item: item.toLowerCase()
	modification = $set: value: quantity
	options = upsert: true
	@update query, modification, options, done

Quantity.statics.getLatest = (user, item, done) ->
	query = user: user, item: item.toLowerCase()
	@findOne(query).exec done

model = mongoose.model "quantities", Quantity
module.exports = multitenant model, [
	"hit"
	"getLatest"
]

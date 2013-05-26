mongoose = require "mongoose"
multitenant = require './multitenant'

Place = mongoose.Schema
	name:
		type: String
		required: true
	item:
		type: String
		required: true
	frequency:
		type: Number
		required: true
		index: true
		min: 0

Place.index {name: 1, item: 1}, {unique: true}

Place.statics.hit = (user, item, place, done) ->
	query = user: user, name: place, item: item
	modification = $inc: frequency: 1
	options = upsert: true
	@update query, modification, options, done

Place.statics.getFrequent = (user, item, done) ->
	@find(user: user, item: item).sort("-frequency").limit(20).exec done

model = mongoose.model "places", Place
module.exports = multitenant model, [
	"hit"
	"getFrequent"
]

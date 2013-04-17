mongoose = require "mongoose"

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

Place.statics.hit = (item, place, done) ->
	query = name: place.toLowerCase(), item: item.toLowerCase()
	modification = $inc: frequency: 1
	options = upsert: true
	@update query, modification, options, done

Place.statics.getFrequent = (item, done) ->
	@find(item: item.toLowerCase()).sort("-frequency").limit(20).exec done

module.exports = mongoose.model "places", Place
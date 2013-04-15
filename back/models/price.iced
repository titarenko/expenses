mongoose = require "mongoose"

Price = mongoose.Schema
	item:
		type: String
		required: true
	place:
		type: String
		required: true
	value:
		type: Number
		required: true
		min: 0.01

Price.index {item: 1, place: 1}, {unique: true}

Price.statics.hit = (item, place, price, done) ->
	query = item: item.toLowerCase(), place: place.toLowerCase()
	modification = $set: value: price
	options = upsert: true
	@update query, modification, options, done

Price.statics.getLatest = (item, place, done) ->
	query = place: place.toLowerCase(), item: item.toLowerCase()
	@findOne(query).exec done

module.exports = mongoose.model "prices", Price

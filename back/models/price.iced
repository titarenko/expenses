mongoose = require "mongoose"
multitenant = require './multitenant'

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

Price.statics.hit = (user, item, place, price, done) ->
	query = user: user, item: item.toLowerCase(), place: place.toLowerCase()
	modification = $set: value: price
	options = upsert: true
	@update query, modification, options, done

Price.statics.getLatest = (user, item, place, done) ->
	query = user: user, place: place.toLowerCase(), item: item.toLowerCase()
	@findOne(query).exec done

model = mongoose.model "prices", Price
module.exports = multitenant model, [
	"hit"
	"getLatest"
]

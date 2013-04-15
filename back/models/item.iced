mongoose = require "mongoose"

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

Item.statics.hit = (item, done) ->
	query = name: item.toLowerCase()
	modification = $inc: frequency: 1
	options = upsert: true
	@update query, modification, options, done

Item.statics.getFrequent = (done) ->
	@find().sort("-frequency").limit(20).exec done

module.exports = mongoose.model "items", Item

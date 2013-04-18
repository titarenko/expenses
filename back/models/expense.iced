mongoose = require "mongoose"

Expense = mongoose.Schema
	item: 
		type: String
		required: true
	place: 
		type: String
		required: true
	date: 
		type: Date
		default: Date.now
		required: true
		index: true
	price: 
		type: Number
		required: true
		min: 0.01

Expense.statics.getAll = (done) ->
	@find().sort("-date").exec done

Expense.statics.getLast =(done) ->
	@find().sort("-date").limit(20).exec done

Expense.pre "save", (next) ->
	@item = @item.toLowerCase()
	@place = @place.toLowerCase()
	next()

module.exports = mongoose.model "expenses", Expense

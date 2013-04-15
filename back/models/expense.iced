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

module.exports = mongoose.model "expenses", Expense

mongoose = require "mongoose"
require 'datejs'

Expense = mongoose.Schema
	item: 
		type: String
		required: true
	place: 
		type: String
	date: 
		type: Date
		default: -> Date.now()
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

Expense.statics.getBetween = (begin, end, done) ->
	@find(date: $gte: begin, $lt: end).sort("-date").exec done

Expense.statics.getThisWeek = (done) ->
	startOfWeek = (new Date).clearTime().previous().monday()
	endOfWeek = startOfWeek.clone().addDays 7
	@getBetween startOfWeek, endOfWeek, done

Expense.statics.getThisMonth = (done) ->
	startOfMonth = (new Date).clearTime().moveToFirstDayOfMonth()
	endOfMonth = startOfMonth.clone().addMonths 1
	@getBetween startOfMonth, endOfMonth, done

Expense.statics.removeAll = (done) ->
	@collection.remove {}, {w: 0}, done

Expense.pre "save", (next) ->
	@item = @item?.toLowerCase()
	@place = @place?.toLowerCase()
	next()

module.exports = mongoose.model "expenses", Expense

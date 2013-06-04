mongoose = require "mongoose"
require 'datejs'
multitenant = require './multitenant'
	
Expense = mongoose.Schema
	category:
		type: String
		required: true
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
	quantity:
		type: Number
	user:
		index: true
		type: mongoose.Schema.Types.ObjectId
		required: true
	comment:
		type: String

Expense.statics.getAll = (user, done) ->
	@find(user: user).sort("-date").exec done

Expense.statics.getLast = (user, done) ->
	@find(user: user).sort("-date").limit(20).exec done

Expense.statics.getBetween = (user, begin, end, done) ->
	console.log begin, end
	@find(user: user, date: $gte: begin, $lt: end).sort("-date").exec done

Expense.statics.getThisWeek = (user, done) ->
	startOfWeek = (new Date).clearTime().addDays(1).previous().monday()
	endOfWeek = startOfWeek.clone().addDays 7
	@getBetween startOfWeek, endOfWeek, done

Expense.statics.getThisMonth = (user, done) ->
	startOfMonth = (new Date).clearTime().moveToFirstDayOfMonth()
	endOfMonth = startOfMonth.clone().addMonths 1
	@getBetween startOfMonth, endOfMonth, done

Expense.statics.removeAll = (user, done) ->
	@collection.remove {user: user}, {w: 0}, done

model = mongoose.model "expenses", Expense
module.exports = multitenant model, [
	"getAll"
	"getLast"
	"getBetween"
	"getThisWeek"
	"getThisMonth"
	"removeAll"
]

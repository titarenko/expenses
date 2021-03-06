async = require "async"
ExpenseBase = require './models/expense'
ItemBase = require './models/item'
PlaceBase = require './models/place'
PriceBase = require "./models/price"
CategoryBase = require "./models/category"
QuantityBase = require "./models/quantity"
log = require "./log"

respond = (params) ->
	req = params[0]
	res = params[1]	
	(error, result) ->
		if error
			log.error JSON.stringify ip: req.connection.remoteAddress, error: error
			res.send 500, error
		else
			res.json result

module.exports = 
	expenses:
		index: (req, res) ->
			method = (week: "getThisWeek", month: "getThisMonth")[req.query.range] or "getAll"
			ExpenseBase.forTenant(req.user)[method] respond arguments
		create: (req, res) ->
			Expense = ExpenseBase.forTenant req.user
			async.series [
				(done) -> (new Expense req.body).save done
				(done) -> async.parallel [
					(done) -> CategoryBase.forTenant(req.user).hit req.body.category, done
					(done) -> ItemBase.forTenant(req.user).hit req.body.category, req.body.item, done
					(done) -> PlaceBase.forTenant(req.user).hit req.body.item, req.body.place, done
					(done) -> PriceBase.forTenant(req.user).hit req.body.item, req.body.place, req.body.price, done
					(done) -> QuantityBase.forTenant(req.user).hit req.body.item, req.body.quantity, done
				], done
			], (error) -> respond([req, res]) error, {}
	items:
		index: (req, res) ->
			ItemBase.forTenant(req.user).getFrequent req.query.category, respond arguments
	places:
		index: (req, res) ->
			PlaceBase.forTenant(req.user).getFrequent req.query.item, respond arguments
	prices:
		index: (req, res) ->
			PriceBase.forTenant(req.user).getLatest req.query.item, req.query.place, (error, price) ->
				respond([req, res]) error, price
	quantities:
		index: (req, res) ->
			QuantityBase.forTenant(req.user).getLatest req.query.item, (error, quantity) ->
				respond([req, res]) error, quantity
	categories:
		index: (req, res) ->
			CategoryBase.forTenant(req.user).getFrequent respond arguments

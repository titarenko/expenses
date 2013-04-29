async = require "async"
Expense = require './models/expense'
Item = require './models/item'
Place = require './models/place'
Price = require "./models/price"
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
			Expense[method] respond arguments
		create: (req, res) ->
			async.series [
				(done) -> (new Expense req.body).save done
				(done) -> async.parallel [
					(done) -> Item.hit req.body.item, done
					(done) -> Place.hit req.body.item, req.body.place, done
					(done) -> Price.hit req.body.item, req.body.place, req.body.price, done
				], done
			], (error) -> respond([req, res]) error, {}
	items:
		index: (req, res) ->
			Item.getFrequent respond arguments
	places:
		index: (req, res) ->
			Place.getFrequent req.query.item, respond arguments
	prices:
		index: (req, res) ->
			Price.getLatest req.query.item, req.query.place, (error, price) ->
				respond([req, res]) error, price

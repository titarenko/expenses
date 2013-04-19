define ["backbone", "superb"], (Backbone, superb) ->

	exports = {}

	exports.Expense = Expense = Backbone.Model.extend
		urlRoot: "expenses"

	exports.FrequentItems = Backbone.Collection.extend
		url: "items"

	exports.FrequentPlaces = Backbone.Collection.extend
		url: "places"

	exports.LatestPrice = Backbone.Model.extend
		url: "prices"

	exports.Login = Backbone.Model.extend()

	exports.LastExpenses = Backbone.Collection.extend
		url: "expenses"

	exports.Expenses = Backbone.Collection.extend
		url: "expenses"
		initialize: ->
			superb.on "add:expense", (data) =>
				model = new Expense data
				@add model, at: 0
		getTotalPrice: ->
			reduction = (memo, item) ->
				memo + item.get "price"
			@reduce reduction, 0 

	exports

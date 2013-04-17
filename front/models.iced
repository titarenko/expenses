define ["backbone"], (Backbone) ->

	exports = {}

	exports.Expense = Backbone.Model.extend
		urlRoot: "expenses"

	exports.FrequentItems = Backbone.Collection.extend
		url: "items"

	exports.FrequentPlaces = Backbone.Collection.extend
		url: "places"

	exports.LatestPrice = Backbone.Model.extend
		url: "prices"

	exports.Login = Backbone.Model.extend()

	exports

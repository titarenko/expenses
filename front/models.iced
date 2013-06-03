define ["backbone"], (Backbone) ->

	Expense: Backbone.Model.extend
		urlRoot: "expenses"

	FrequentCategories: Backbone.Collection.extend
		url: "categories"

	FrequentItems: Backbone.Collection.extend
		url: "items"

	FrequentPlaces: Backbone.Collection.extend
		url: "places"

	LatestPrice: Backbone.Model.extend
		url: "prices"

	Login: Backbone.Model.extend()

	Expenses: Backbone.Collection.extend
		url: "expenses"
		getTotalPrice: ->
			reduction = (memo, item) ->
				memo + item.get "price"
			@reduce reduction, 0 

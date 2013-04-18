define ["bus", "views", "models"], (bus, views, models) ->

	exports = {}

	exports.MainMenuController =
		showMenu: ->
			bus.trigger "show", new views.MainMenu
		showHistory: (range) ->
			expenses = new models.Expenses
			bus.trigger "show", new views.Expenses collection: expenses
			expenses.fetch data: range: range

	exports.ExpenseWizardController =
		showFrequentItems: ->
			items = new models.FrequentItems

			items.on "selected", (model) -> 
				bus.trigger "navigate", "add/#{model.get "name"}"
			items.on "skipped", ->
				bus.trigger "navigate", "add/?/?"

			bus.trigger "show", new views.Options collection: items
			
			items.fetch()

		showFrequentPlaces: (item) ->
			places = new models.FrequentPlaces
			
			places.on "selected", (model) -> 
				bus.trigger "navigate", "add/#{item}/#{model.get "name"}"
			places.on "skipped", ->
				bus.trigger "navigate", "add/#{item}/?"

			bus.trigger "show", new views.Options collection: places

			if item
				places.fetch 
					data: 
						item: item

		showExpenseEditor: (item, place) ->
			item = null if item == "?"
			place = null if place == "?"

			price = new models.LatestPrice
			
			model = new models.Expense
				item: item
				place: place

			view = new views.ExpenseEditor
				model: model

			view.on "done", ->
				model.save()
				bus.trigger "navigate", ""
		
			bus.trigger "show", view

			price.on "change", ->
				model.set "price", price.get "value"

			if item and place
				price.fetch
					data: 
						item: item 
						place: place

	exports.AuthController = 
		showLogin: ->
			view = new views.Login
				model: new models.Login

			bus.trigger "show", view

			view.on "signUp", ->
				@showSignUpPage()

		showSignUp:->
			view = new views.SignUp
				model: new models.Login
			bus.trigger "show", view

	exports
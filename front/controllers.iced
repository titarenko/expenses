define ["bus", "views", "models"], (bus, views, models) ->

	MainMenuController:
		showMenu: ->
			bus.trigger "show", new views.MainMenu
		showHistory: (range) ->
			expenses = new models.Expenses
			bus.trigger "show", new views.Expenses collection: expenses
			expenses.fetch data: range: range

	ExpenseWizardController:
		showFrequentCategories: ->
			categories = new models.FrequentCategories

			categories.on "selected", (model) ->
				bus.trigger "navigate", "add-expense-items", category: model.get "name"
			categories.on "skipped", ->
				bus.trigger "navigate", "add-expense-editor"

			bus.trigger "show", new views.Options collection: categories

			categories.fetch()

		showFrequentItems: (category) ->
			items = new models.FrequentItems

			items.on "selected", (model) -> 
				bus.trigger "navigate", "add-expense-places", category: category, item: model.get "name"
			items.on "skipped", ->
				bus.trigger "navigate", "add-expense-editor", category: category

			bus.trigger "show", new views.Options collection: items
			
			items.fetch
				data:
					category: category

		showFrequentPlaces: (category, item) ->
			places = new models.FrequentPlaces
			
			places.on "selected", (model) -> 
				bus.trigger "navigate", "add-expense-editor", category: category, item: item, place: model.get "name"
			places.on "skipped", ->
				bus.trigger "navigate", "add-expense-editor", category: category, item: item

			bus.trigger "show", new views.Options collection: places

			if item
				places.fetch 
					data: 
						item: item

		showExpenseEditor: (category, item, place) ->
			price = new models.LatestPrice
			
			model = new models.Expense
				category: category
				item: item
				place: place

			view = new views.ExpenseEditor
				model: model

			view.on "done", ->
				model.save()
				bus.trigger "navigate", "main-menu"
		
			bus.trigger "show", view

			price.on "change", ->
				model.set "price", price.get "value"

			if item and place
				price.fetch
					data: 
						item: item 
						place: place

	AuthController: 
		showLogin: ->
			bus.trigger "show", new views.Login

	HistoryController: 
		showHistory:->
			layout = new views.StatisticsLayout
			bus.trigger "show", layout

			lastExpenses = new models.Expenses

			layout.history.show new views.History collection: lastExpenses

			layout.chart.show new views.Chart collection: lastExpenses

			lastExpenses.fetch()

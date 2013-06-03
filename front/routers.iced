define ["routing", "controllers"], (routing, controllers) ->

	RouteCollection = routing.RouteCollection

	new routing.RouteTable [
		new RouteCollection
			appRoutes:
				"main-menu": url: "", action: "showMenu"
				"history": url: "history/:range", action: "showHistory", range: "week"
			controller: controllers.MainMenuController
		new RouteCollection
			appRoutes:
				"add-expense-categories": 
					url: "add"
					action: "showFrequentCategories"
				"add-expense-items": 
					url: "add/:category"
					action: "showFrequentItems"
					category: null
				"add-expense-places": 
					url: "add/:category/:item"
					action: "showFrequentPlaces"
					category: null
					item: null
				"add-expense-editor": 
					url: "add/:category/:item/:place"
					action: "showExpenseEditor"
					category: null
					item: null
					place: null
			controller: controllers.ExpenseWizardController
		new RouteCollection
			appRoutes:
				"analytics": url: "history", action: "showHistory"
			controller:
				controllers.HistoryController
	]

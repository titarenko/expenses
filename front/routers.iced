define ["marionette", "controllers"], (Marionette, controllers) ->

	exports = {}

	exports.MainMenuRouter = Marionette.AppRouter.extend
		appRoutes:
			"": "showMenu"
		controller: 
			controllers.MainMenuController

	exports.ExpenseWizardRouter = Marionette.AppRouter.extend
		appRoutes:
			"add": "showFrequentItems"
			"add/:item": "showFrequentPlaces"
			"add/:item/:place": "showExpenseEditor"
		controller: 
			controllers.ExpenseWizardController

	exports

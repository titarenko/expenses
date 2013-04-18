define ["marionette", "controllers"], (Marionette, controllers) ->

	exports = {}

	exports.MainMenuRouter = Marionette.AppRouter.extend
		appRoutes:
			"": "showMenu"
			"history/:range": "showHistory"
		controller: 
			controllers.MainMenuController

	exports.ExpenseWizardRouter = Marionette.AppRouter.extend
		appRoutes:
			"add": "showFrequentItems"
			"add/:item": "showFrequentPlaces"
			"add/:item/:place": "showExpenseEditor"
		controller: 
			controllers.ExpenseWizardController

	exports.AuthRouter = Marionette.AppRouter.extend
		appRoutes:
			"login": "showLogin"
			"signUp": "showSignUp"
		controller:
			controllers.AuthController

	exports.StatisticsRouter = Marionette.AppRouter.extend
		appRoutes:
			"history": "showHistory"
		controller:
			controllers.HistoryController

	exports

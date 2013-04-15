require.config

	paths:
		jquery: "http://cdnjs.cloudflare.com/ajax/libs/jquery/1.9.0/jquery.min"
		underscore: "http://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.4.3/underscore-min"
		backbone: "http://cdnjs.cloudflare.com/ajax/libs/backbone.js/1.0.0/backbone-min"
		marionette: "http://cdnjs.cloudflare.com/ajax/libs/backbone.marionette/1.0.0-rc6-bundled/backbone.marionette.min"
		moment: "http://cdnjs.cloudflare.com/ajax/libs/moment.js/1.7.2/moment.min"
		dot: "http://olado.github.io/doT/doT.min"
		spinner: "http://fgnass.github.io/spin.js/dist/spin.min.js?v=1.2.8"
		d3: "http://cdnjs.cloudflare.com/ajax/libs/d3/3.0.8/d3.min"
		validate: "http://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.11.0/jquery.validate.min"

	shim:
		jquery: exports: "$"
		underscore: exports: "_"
		backbone:
			deps: ["underscore", "jquery"]
			exports: "Backbone"
		marionette:
			deps: ["backbone", "moment"]
			exports: "Marionette"
		moment: exports: "moment"
		dot: exports: "doT"
		d3: exports: "d3"

require ["marionette", "dot", "routers", "bus"], (Marionette, doT, routers, bus) ->

	Marionette.TemplateCache::compileTemplate = (rawTemplate) ->
		doT.template rawTemplate

	app = new Marionette.Application

	app.addRegions
		viewport: "#viewport"

	app.addInitializer ->
		router = new routers.MainMenuRouter()
		new routers.ExpenseWizardRouter()

		bus.on "show", (view) ->
			app.viewport.show view

		bus.on "navigate", (route) ->
			router.navigate route, trigger: true

		Backbone.history.start()

	app.start()

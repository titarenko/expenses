require.config
	paths:
		jquery: "jquery_v1.9.0.min"
		underscore: "underscore_v1.4.3.min"
		backbone: "backbone_v1.0.0.min"
		marionette: "backbone.marionette_v1.0.0-rc6.min"
		moment: "moment_v1.7.2.min"
		dot: "doT_v1.0.0.min"
		spinner: "spin_v1.2.8.min"
		d3: "d3_v3.0.8.min"
		validate: "jquery.validate_v1.11.0.min"

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
		new routers.AuthRouter()

		bus.on "show", (view) ->
			app.viewport.show view

		bus.on "navigate", (route) ->
			router.navigate route, trigger: true

		Backbone.history.start()

	app.start()

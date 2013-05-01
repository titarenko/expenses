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
		highcharts: "highcharts_v3.0.1.min"
		highcharts_exporting: "highcharts_exporting_v3.0.1.min"
		linqjs: "linq_v3.0.3-Beta4.min"

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
		highcharts_exporting:
			deps:["highcharts"]
		linqjs: exports: "linqjs"

require ["marionette", "dot", "routers", "bus", "jquery"], (Marionette, doT, routers, bus, $) ->

	Marionette.TemplateCache::compileTemplate = (rawTemplate) ->
		doT.template rawTemplate

	$(document).ajaxComplete (e, o) ->
		if o.status == 403
			location.href = "/"

	app = new Marionette.Application

	app.addRegions
		viewport: "#viewport"

	app.addInitializer ->
		bus.on "show", (view) ->
			app.viewport.show view
		bus.on "navigate", (route, parameters) ->
			routers.navigate route, parameters
		routers.start()

	app.start()

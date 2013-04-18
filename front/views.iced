define ["marionette", "highcharts_exporting", "highcharts", "jquery"], (Marionette, HighchartsExporting, highcharts, $) ->

	Empty = Marionette.ItemView.extend
		template: "#empty-template"

	exports = {}

	exports.MainMenu = Marionette.ItemView.extend
		template: "#main-menu-template"

	exports.Option = Option = Marionette.ItemView.extend
		template: "#option-template"
		events:
			"click .option": "selectOption"
		selectOption: ->
			@model.trigger "selected", @model

	exports.Options = Marionette.CompositeView.extend
		template: "#options-template"
		itemView: Option
		className: "button-group"
		events:
			"click #skip": "skipStep"
		skipStep: ->
			@collection.trigger "skipped"

	exports.ExpenseEditor = Marionette.ItemView.extend
		template: "#expense-editor-template"

		ui:
			item: "#what"
			place: "#where"
			price: "#price"

		events:
			"click #submit": "saveExpense"

		initialize: ->
			@listenTo @model, "change:price", @updatePrice

		onRender: ->
			@ui.item.val @model.get "item"
			@ui.place.val @model.get "place"
			@updatePrice()

		updatePrice: ->
			@ui.price.val @model.get "price"

		saveExpense: ->
			@model.set
				item: @ui.item.val()
				place: @ui.place.val()
				price: @ui.price.val()
			@trigger "done"

	exports.Login = Marionette.ItemView.extend
		template: "#login-template"

		ui:
			email: "#email"
			password: "#password"

		events:
			"click #signUp": "signUp"
			"click #submit": "loginAct"

		loginAct: ->
			@model.set
				email: @ui.email.val()
				password : @ui.password.val()

		signUp: ->
			@trigger "signUp"

	exports.SignUp = Marionette.ItemView.extend
		template: "#sign-up-template"

		ui:
			email: "#email"
			password: "#password"

		events: 
			"click #submit" : "register"

		register:->
			model.set
				email: @ui.email.val()
				password: @ui.password.lav()
			@trigger "register"
			#TODO: add logic into controller

	exports.HistoryItem = HistoryItem = Marionette.ItemView.extend
		template: "#history-item-template"

	exports.History = Marionette.CompositeView.extend
		template: "#history-template"
		itemView: HistoryItem
		emptyView: Empty

	exports.StatisticsLayout = Marionette.Layout.extend
		template: "#statistics-template"
		regions:
			history: "#history"
			chart: "#chart"

	exports.Chart = Marionette.View.extend
		
		initialize:  ->
			@listenTo @collection, "sync", @plot

		plot:->

			list = @collection.toJSON()

			
		#	value = Enumerable
		#		.From(list)
		#		.GroupBy("$.item")
		#		.Sum("$.price")
		#		.toArray()
			#console.log value

			options = 
				chart:
					plotBackgroundColor: null
					plotBorderWidth: null
					plotShadow: false
				title:
					text: "Browser market shares at a specific website, 2010"
				tooltip:
					pointFormat: "{series.name}: <b>{point.percentage}%</b>"
					percentageDecimals: 1
				plotOptions:
						pie:
							allowPointSelect: true
							cursor: "pointer"
							dataLabels:
								enabled: true
								color: "#000000"
								connectorColor: "#000000"
								formatter: ->
									"<b>" + @point.name + "</b>: " + @percentage + " %"

				series: [{
					type: 'pie',
					data: [
							['Firefox',45.0],
							['IE',26.8],
							['Chrome', 12.8]
							['Safari',8.5],
							['Opera',6.2],
							['Others',0.7]
						]
					}]

			@$el.highcharts options

	exports

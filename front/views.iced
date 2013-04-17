define ["marionette", "highcharts"], (Marionette, highcharts) ->

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
			options = 
				chart:
					type: "line"
					marginRight: 130
					marginBottom: 25
				title:
					text: "Monthly Average Temperature"
					x: -20 #center
				subtitle:
					text: "Source: WorldClimate.com"
					x: -20
				xAxis:
					categories: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
				yAxis:
					title:
						text: "Temperature (°C)"
				plotLines: [
					value: 0
					width: 1
					color: "#808080"
				]
				tooltip:
					valueSuffix: "°C"
				legend:
					layout: "vertical"
					align: "right"
					verticalAlign: "top"
					x: -10
					y: 100
					borderWidth: 0
				series: [
						name: "Tokyo"
						data: [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]
					,
						name: "New York"
						data: [-0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5]
					,
						name: "Berlin"
						data: [-0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6, 17.9, 14.3, 9.0, 3.9, 1.0]
					,
						name: "London"
						data: [3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8]
				]

			$("#chart").highcharts options

	exports

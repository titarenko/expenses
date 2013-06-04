define ["marionette", "highcharts_exporting", "highcharts", "jquery", "linqjs", "moment"], (Marionette, HighchartsExporting, highcharts, $, Enumerable, moment) ->

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
			"click #new": "skipStep"
		skipStep: ->
			@collection.trigger "skipped"

	exports.ExpenseEditor = Marionette.ItemView.extend
		template: "#expense-editor-template"

		ui:
			category: "#category"
			item: "#what"
			place: "#where"
			price: "#price"
			quantity: "#quantity"
			comment: "#comment"
			date: "#date"
		events:
			"click #save": "saveExpense"

		initialize: ->
			@listenTo @model, "change:price", @updatePrice
			@listenTo @model, "change:quantity", @updateQuantity

		onRender: ->
			@ui.category.val @model.get "category"
			@ui.item.val @model.get "item"
			@ui.place.val @model.get "place"
			@ui.date.val moment().format "YYYY-MM-DD"
			@updatePrice()
			@updateQuantity()

		updatePrice: ->
			@ui.price.val @model.get "price"

		updateQuantity: ->
			@ui.quantity.val @model.get "quantity"

		saveExpense: ->
			@model.set
				category: @ui.category.val()
				item: @ui.item.val()
				place: @ui.place.val()
				price: @ui.price.val()
				quantity: @ui.quantity.val()
				date: moment(@ui.date.val())._d
				comment: @ui.comment.val()
			@trigger "done"

	exports.Login = Marionette.ItemView.extend
		template: "#login-template"

	exports.HistoryItem = HistoryItem = Marionette.ItemView.extend
		template: "#history-item-template"

	exports.History = Marionette.CompositeView.extend
		template: "#history-template"
		itemView: HistoryItem
		emptyView: Empty
		itemViewContainer: ".container"
		appendHtml: (compositeView, itemView) ->
			@container = @container or @getItemViewContainer compositeView 
			@container.prepend itemView.el

	exports.StatisticsLayout = Marionette.Layout.extend
		template: "#statistics-template"
		regions:
			history: "#history"
			chart: "#chart"

	exports.Chart = Marionette.View.extend
		
		initialize:  ->
			@listenTo @collection, "sync add", @plot

		plot:->

			list = Enumerable.from(@collection.toJSON())

			totalSum = list.sum((x) -> x.price)

			dataItems = list
			.groupBy((x) -> x.item)
			.select((x)->
				source = Enumerable.from(x)
				percentage = (source.sum("$.price") * 100/ totalSum).toFixed 2
				new Array(source.first().item, parseFloat(percentage))
				)
			.toArray()

			options = 
				chart:
					plotBackgroundColor: null
					plotBorderWidth: null
					plotShadow: false
				title:
					text: "Your expences persentage"
				tooltip:
					formatter: ->
						name = @point.name.charAt(0).toUpperCase() + @point.name.slice(1)
						"<b>" + name + "</b>: " + @percentage.toFixed(2) + " %"
					percentageDecimals: 2
				plotOptions:
						pie:
							allowPointSelect: true
							cursor: "pointer"
							dataLabels:
								enabled: true
								color: "#000000"
								connectorColor: "#000000"
								formatter: ->
									name = @point.name.charAt(0).toUpperCase() + @point.name.slice(1)
									"<b>" + name + "</b>: " + @percentage.toFixed(2) + " %"
				series: [{
					type: 'pie',
					data: dataItems
					}]

			@$el.highcharts options

	NoExpense = Marionette.ItemView.extend
		tagName: "tr"
		template: "#no-expense-template"

	Expense = Marionette.ItemView.extend
		tagName: "tr"
		template: "#expense-template"

	exports.Expenses = Marionette.CompositeView.extend
		template: "#expenses-template"
		itemView: Expense
		itemViewContainer: "tbody"
		emptyView: NoExpense
		ui:
			total: "#total"
		initialize: ->
			@listenTo @collection, "sync", @updateTotalPrice
		updateTotalPrice: ->
			@ui.total.text @collection.getTotalPrice().toFixed 2

	exports

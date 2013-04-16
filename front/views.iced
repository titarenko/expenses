define ["marionette"], (Marionette) ->

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

	exports

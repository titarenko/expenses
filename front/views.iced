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
			"click #save": "saveExpense"

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
			console.log "catched"
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

	exports

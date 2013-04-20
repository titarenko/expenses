define ["backbone", "marionette"], (Backbone, Marionette) ->

	exports = {}

	exports.RouteCollection = class RouteCollection
		
		constructor: ({@appRoutes, @controller}) ->
			Router = Marionette.AppRouter.extend
				appRoutes: @_getAppRoutes()
				controller: @_getController()
			@router = new Router

		navigate: (url) ->
			@router.navigate url, trigger: true

		_getAppRoutes: ->
			result = {}
			for name, route of @appRoutes when @appRoutes.hasOwnProperty name
				result[route.url] = route.action
			result

		_getController: ->
			result = {}
			for name, method of @controller when @controller.hasOwnProperty name
				decorate = =>
					methodBody = method 
					result[name] = =>
						cleanArguments = Array::map.call arguments, (argument) ->
							if argument == "?" then null else argument
						methodBody.apply @controller, cleanArguments
				decorate()
			result

	exports.RouteTable = class RouteTable

		constructor: (@routes) ->
			
		start: ->
			Backbone.history.start()

		navigate: (name, parameters) ->
			parameters = {} unless parameters
			for router in @routes 
				route = router.appRoutes[name]
				return @_follow route, parameters if route

		_follow: (route, parameters) ->
			url = route.url
			@_extend parameters, route
			for name, value of parameters when parameters.hasOwnProperty name
				url = url.replace ":#{name}", value or "?"
			@routes[0].navigate url

		_extend: (base, source) ->
			for name, value of source when source.hasOwnProperty name
				base[name] = value unless base[name]
			base 

	exports

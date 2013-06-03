define ["spinner", "jquery"], (Spinner, $) ->

	enableGlobalHandlers: ->

		spinner = new Spinner
			color: "#aaa"
			radius: 5
			width: 3
			length: 12

		page = $ document

		page.ajaxStart ->
			spinner.spin $ "#spinner"

		page.ajaxStop ->
			spinner.stop()

		page.ajaxComplete (e, o) ->
			if o.status == 500
				alert o.responseText
			if o.status == 403
				location.href = "/"

fs = require "fs"
compiler = require "iced-coffee-script"

module.exports = (path) -> 
	(req, res, next) ->
		return next() unless req.url.indexOf(".js") != -1
		await fs.readFile path + req.url.replace(".js", ".iced"), "utf-8", defer error, code
		return next() unless !error     
		try
			compiled = compiler.compile code                
		catch error             
			return next()
		res.header "Content-Type", "text/javascript"
		res.send compiled

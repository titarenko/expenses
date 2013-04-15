fs = require "fs"
compiler = require "less"

module.exports = (path) -> 
        (req, res, next) ->
                return next() unless req.url.indexOf(".css") != -1
                await fs.readFile path + req.url.replace(".css", ".less"), "utf-8", defer error, code
                return next() unless !error
                await compiler.render code, compress: true, defer error, rendered
                return next() unless !error
                res.header "Content-Type", "text/css"
                res.send rendered

mongoose = require 'mongoose'

before ->
	connectionString = process.env.CONNECTION_STRING or "mongodb://localhost/expenses-test"
	mongoose.connect connectionString

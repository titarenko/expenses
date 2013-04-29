mongoose = require 'mongoose'
sinon = require 'sinon'

clock = null
now = new Date 2012, 3, 20

before ->
	connectionString = process.env.CONNECTION_STRING or "mongodb://localhost/expenses-test"
	mongoose.connect connectionString
	clock = sinon.useFakeTimers now.getTime()

after ->
	clock.restore()
	mongoose.connection.close()

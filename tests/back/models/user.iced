User = require '../../../back/models/user'
mongoose = require 'mongoose'
async = require "async"
should = require 'should'

describe "User", ->

	before (done) ->
		createUser = (name) ->
			(done) ->
				(new User
					name: name
					email: "#{name}@gmail.com"
					password: "abba").save done
		async.series [
			(done) -> User.removeAll done
			(done) -> 
				async.parallel [
					createUser "bob"
					createUser "peter"
				], done
			], done

	describe "#getByEmail()", ->
		
		it "should return user by their email", (done) ->
			User.getByEmail "bob@gmail.com", (error, user) ->
				user.email.should.eql "bob@gmail.com"
				done()

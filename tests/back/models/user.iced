User = require '../../../back/models/user'
mongoose = require 'mongoose'
async = require "async"
should = require 'should'

describe "User", ->

	before (done) ->
		createUser = (name, password) ->
			password = name unless password
			confirmation = password
			(done) ->
				model = new User
					name: name
					email: "#{name}@gmail.com"
				model.setPasswordSync password, confirmation
				model.save done
		async.series [
			(done) -> User.removeAll done
			(done) -> 
				async.parallel [
					createUser "bob", "123"
					createUser "peter", "abc"
				], done
			], done

	describe "#getByNameOrEmail()", ->

		it "should return user by their email", (done) ->
			User.getByNameOrEmail "bob@gmail.com", (error, user) ->
				user.email.should.eql "bob@gmail.com"
				done()

		it "should return user by their name", (done) ->
			User.getByNameOrEmail "bob", (error, user) ->
				user.name.should.eql "bob"
				done()

	describe "#getOrCreateByGoogleId()", ->

		it "should create user with GoggleId if it's not present", (done) ->
			params = 
				googleId: "3l5jhkg235hjt545",
				email: "greatnewemail@gmail.com"
			User.getOrCreateByGoogleId params, (error, user) ->
				User.getByNameOrEmail "greatnewemail@gmail.com", (error, user) ->
					user.email.should.eql "greatnewemail@gmail.com"
					user.googleId.should.eql "3l5jhkg235hjt545"
					done()

		it "should get user with GoggleId if it's already present", (done) ->
			params = 
				googleId: "3l5jhkg235hjt545dfdkjhf",
				email: "greatnewemail12345@gmail.com"
			(new User params).save (error, user) ->
				User.getOrCreateByGoogleId params, (error, user) ->
					user.email.should.eql "greatnewemail12345@gmail.com"
					user.googleId.should.eql "3l5jhkg235hjt545dfdkjhf"
					done()

	describe "#ctor()", ->

		it "should infer name from email if name is not provided", (done) ->
			model = new User
				email: "joe@gmail.com"
			model.save (error) ->
				model.name.should.eql "joe@gmail.com"
				done()

	describe "#setPasswordSync()", ->

		it "should throw error if password doesn't match confirmation", ->
			model = new User
			(-> model.setPasswordSync "123", "456").should.throw()

		it "should not store password as is", ->
			model = new User
			model.setPasswordSync "123", "123"
			model.encodedPassword.should.not.eql "123"

	describe "#verifyPasswordSync()", ->

		it "should return true if passwords match", ->
			model = new User
			model.setPasswordSync "123", "123"
			model.verifyPasswordSync("123").should.eql true

		it "should return false if passwords don't match", ->
			model = new User
			model.setPasswordSync "123", "123"
			model.verifyPasswordSync("456").should.eql false

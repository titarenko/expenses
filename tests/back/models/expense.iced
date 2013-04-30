mongoose = require 'mongoose'

tenant = new mongoose.Types.ObjectId

Expense = (require '../../../back/models/expense').forTenant tenant

async = require "async"
sinon = require 'sinon'
should = require 'should'

describe "Expense", ->

	before (done) ->
		saveExpense = (month, day, done) ->
			(new Expense
				item: "milk"
				place: "amstor"
				price: 10
				date: new Date 2012, month, day).save done
		
		january = [1..19].map (x) -> saveExpense.bind @, 0, x
		februaryToApril = [1..3].map (x) -> saveExpense.bind @, x, 1
		april = [19..20].map (x) -> saveExpense.bind @, 3, x
		
		async.series [
			(done) -> Expense.removeAll done
			(done) -> async.parallel january.concat(februaryToApril.concat(april)), done
		], done

	describe "#getThisWeek()", ->
		
		it "should return expenses from this week only", (done) ->
			Expense.getThisWeek (error, collection) ->
				collection.length.should.eql 2
				done()

		it "should return expenses sorted by date in descending order", (done) ->
			Expense.getThisMonth (error, collection) ->
				collection[0].date.should.eql new Date 2012, 3, 20
				collection[1].date.should.eql new Date 2012, 3, 19
				done()

	describe "#getThisMonth()", ->

		it "should return expenses from this month only", (done) ->
			Expense.getThisMonth (error, collection) ->
				collection.length.should.eql 3
				done()

		it "should return expenses sorted by date in descending order", (done) ->
			Expense.getThisMonth (error, collection) ->
				collection[0].date.should.eql new Date 2012, 3, 20
				collection[2].date.should.eql new Date 2012, 3, 1
				done()

	describe "#getLast()", ->

		it "should return last 20 expenses", (done) ->
			Expense.getLast (error, collection) ->
				collection.length.should.eql 20
				done()

		it "should return expenses sorted by date in descending order", (done) ->
			Expense.getLast (error, collection) ->
				collection[0].date.should.eql new Date 2012, 3, 20
				collection[19].date.should.eql new Date 2012, 0, 5
				done()

	describe "#getAll()", ->

		it "should return all expenses", (done) ->
			Expense.getAll (error, collection) ->
				collection.length.should.eql 24
				done()

		it "should return expenses sorted by date in descending order", (done) ->
			Expense.getAll (error, collection) ->
				collection[0].date.should.eql new Date 2012, 3, 20
				collection[23].date.should.eql new Date 2012, 0, 1
				done()

	describe "#save()", ->

		it "should not allow to save expense with price less than 0.01", (done) ->
			model = new Expense
				price: 0.001
				item: "meat"
				place: "objora"
			model.save (error) ->
				error.errors.price.type.should.eql "min"
				done()

		it "should not allow to save expense with empty item name", (done) ->
			model = new Expense
				price: 0.10
				place: "amstor"
			model.save (error) ->
				error.errors.item.type.should.eql "required"
				done()

		it "should allow to save expense without place", (done) ->
			model = new Expense
				price: 10.25
				item: "milk"
			model.save (error) ->
				should.not.exist error
				done()

		it "should perform lower case coversion on save", (done) ->
			model = new Expense
				price: 10.90
				item: "Cake"
				place: "ATB"
			model.save (error) ->
				model.item.should.eql "cake"
				model.place.should.eql "atb"
				done()

		it "should set date to current by default", (done) ->
			model = new Expense
				price: 0.10
				item: "meat"
			model.save (error) ->
				model.date.should.eql new Date
				done()

Expense = require '../../../back/models/expense'
mongoose = require 'mongoose'
async = require "async"
sinon = require 'sinon'
should = require 'should'

describe "Expense", ->

	clock = null
	now = new Date 2012, 3, 20

	before ->
		clock = sinon.useFakeTimers now.getTime()

	after ->
		clock.restore()

	before (done) ->
		saveExpense = (date, done) ->
			(new Expense
				item: "milk"
				place: "amstor"
				price: 10
				date: date).save done		
		async.series [
			(done) -> Expense.removeAll done
			(done) -> 
				async.parallel [
					saveExpense.bind @, new Date 2012, 0, 1
					saveExpense.bind @, new Date 2012, 0, 2
					saveExpense.bind @, new Date 2012, 0, 3
					saveExpense.bind @, new Date 2012, 0, 4
					saveExpense.bind @, new Date 2012, 0, 5
					saveExpense.bind @, new Date 2012, 0, 6
					saveExpense.bind @, new Date 2012, 0, 7
					saveExpense.bind @, new Date 2012, 0, 8
					saveExpense.bind @, new Date 2012, 0, 9
					saveExpense.bind @, new Date 2012, 0, 10
					saveExpense.bind @, new Date 2012, 0, 11
					saveExpense.bind @, new Date 2012, 0, 12
					saveExpense.bind @, new Date 2012, 0, 13
					saveExpense.bind @, new Date 2012, 0, 14
					saveExpense.bind @, new Date 2012, 0, 15
					saveExpense.bind @, new Date 2012, 0, 16
					saveExpense.bind @, new Date 2012, 0, 17
					saveExpense.bind @, new Date 2012, 0, 18
					saveExpense.bind @, new Date 2012, 0, 19
					saveExpense.bind @, new Date 2012, 1, 1
					saveExpense.bind @, new Date 2012, 2, 1
					saveExpense.bind @, new Date 2012, 3, 1
					saveExpense.bind @, new Date 2012, 3, 19
					saveExpense.bind @, new Date 2012, 3, 20
				], done
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
				model.date.should.eql now
				done()

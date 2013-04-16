mongoose = require 'mongoose'

User = mongoose.Schema
  email:
    type: String
    required: true
  passwordHash:
    type: String
    required: true
  passwordSalt:
    type: String
    required: true
  googleId:
    type: String

User.statics.getByEmail = (email, done) ->
  @findOne(email: email).exec done

User.statics.getOrCreateByGoogleId = (params, done) ->
  query = googleId: params.googleId
  options = upsert: true
  sort = {}
  update = $set: googleId: params.googleId, email : params.email
  @collection.findAndModify(query, sort, update, options, done)

module.exports = mongoose.model "users", User

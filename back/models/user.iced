mongoose = require 'mongoose'

User = mongoose.Schema
  username:
    type: String
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

User.statics.getByGoogleId = (googleId, done) ->
  options = upsert: true
  await @collection.findAndModify(googleId: googleId, options).exec defer error, user
  return done error if error
  return done null, user unless user

module.exports = mongoose.model "users", User

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
  goodleId:
    type: String

User.statics.getByEmail = (email, done) ->
  @findOne(email: email).exec done

User.statics.getByGoogleId = (goodleId, done) ->
  @findOne(goodleId: goodleId).exec done

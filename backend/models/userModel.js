import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
  },
  username: {
    type: String,
    required: true,
  },
  bio: {
    type: String,
    default: null,
  },
  avatar: {
    type: String,
    default: null,
  },
});

export const User = mongoose.model("users", userSchema);

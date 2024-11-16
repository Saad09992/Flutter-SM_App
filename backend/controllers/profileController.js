import { User } from "../models/userModel.js";

export const getUserData = async (req, res) => {
  try {
    const { uid } = req.body;
    const userData = await User.findOne({ _id: uid }).select("-password");
    const data = {
      username: userData?.username,
      email: userData?.email,
      bio: userData?.bio,
      avatar: userData?.avatar,
    };

    if (!userData) {
      return res.json({
        error: "Error fetching user data",
        success: false,
      });
    }
    return res.json({
      data: data,
      status: "success",
      msg: "User data fetched successfully",
    });
  } catch (error) {
    return res.status(400).json({ msg: error.message, status: "error" });
  }
};

export const updateUserData = async (req, res) => {
  try {
    const { uid, username, bio } = req.body;
    console.log(req.body);

    const getUser = await User.findById(uid);

    if (!getUser) {
      return res.json({
        msg: "User not found",
        status: "error",
      });
    }

    getUser.username = username;
    getUser.bio = bio;

    await getUser.save();

    return res.json({
      msg: "User info updated successfully",
      status: "success",
    });
  } catch (error) {
    return res.json({ msg: error.message, status: "error" });
  }
};

export const updateUserAvatar = async (req, res) => {
  const { uid } = req.body;
  const filename = req.file.filename;
  try {
    const getUser = await User.findById(uid);
    if (getUser) {
      getUser.avatar = filename;
      await getUser.save();
      res.status(201).json({
        msg: "Profile picture updated successfully",
        status: "success",
      });
    } else {
      res.status(404).json({ msg: "User not found", status: "error" });
    }
  } catch (error) {
    res.status(403).json({ msg: "Server error", status: "error" });
  }
};

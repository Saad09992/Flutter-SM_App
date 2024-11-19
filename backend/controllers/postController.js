import { Post } from "../models/postModel.js";
import { User } from "../models/userModel.js";

export const uploadPost = async (req, res) => {
  try {
    const { uid, title, description } = req.body;
    const filename = req.file.filename;

    const newPost = new Post({
      title: title,
      description: description,
      image: filename,
      user: uid,
    });

    // Save the post
    const savedPost = await newPost.save();

    if (savedPost) {
      return res.json({
        msg: "Post created successfully",
        status: "success",
      });
    } else {
      return res.json({
        msg: "Post creation failed",
        status: "error",
      });
    }
  } catch (error) {
    return res.json({ msg: error.message, status: "error" });
  }
};

export const getPosts = async (req, res) => {
  try {
    const posts = await Post.find({ isDel: false });
    return res.json({
      data: posts,
      msg: "posts fetched successfully",
      status: "success",
    });
  } catch (error) {
    return res.json({ msg: error.message, status: "error" });
  }
};

export const delPost = async (req, res) => {
  try {
    const { uid, postId } = req.body;

    if (!uid || !postId) {
      return res.json({ msg: "Missing required fields", status: "error" });
    }

    const [user, post] = await Promise.all([
      User.findById(uid),
      Post.findById(postId),
    ]);

    if (!user) {
      return res.json({ msg: "User not found", status: "error" });
    }

    if (!post) {
      return res.json({ msg: "Post not found", status: "error" });
    }

    post.isDel = true;

    await post.save();

    return res.json({
      status: "success",
      msg: "Post deleted successfully",
    });
  } catch (error) {
    return res.json({ msg: "Internal server error", status: "error" });
  }
};

export const likePost = async (req, res) => {
  try {
    const { uid, postId } = req.body;
    console.log(uid);
    console.log(postId);
    if (!uid || !postId) {
      return res.json({ msg: "Missing required fields", status: "error" });
    }

    const [user, post] = await Promise.all([
      User.findById(uid),
      Post.findById(postId),
    ]);

    if (!user) {
      return res.json({ msg: "User not found", status: "error" });
    }

    if (!post) {
      return res.json({ msg: "Post not found", status: "error" });
    }

    const hasLiked = post.likes.includes(uid);

    if (hasLiked) {
      post.likes = post.likes.filter((id) => id.toString() !== uid.toString());
    } else {
      post.likes.push(uid);
    }

    await post.save();

    return res.json({
      status: "success",
      msg: hasLiked ? "Post unliked successfully" : "Post liked successfully",
      likes: post.likes,
    });
  } catch (error) {
    console.error("Like API Error:", error);
    return res.json({ msg: "Internal server error", status: "error" });
  }
};

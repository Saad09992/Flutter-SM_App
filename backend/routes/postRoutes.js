import express from "express";
import {
  delPost,
  getPosts,
  likePost,
  uploadPost,
} from "../controllers/postController.js";
import multer from "multer";
import path from "path";

const postRouter = express.Router();

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "public/post_images/");
  },
  filename: (req, file, cb) => {
    cb(
      null,
      file.fieldname + "_" + Date.now() + path.extname(file.originalname)
    );
  },
});

const upload = multer({ storage: storage });

postRouter.post("/api/upload-post", upload.single("post-image"), uploadPost);
postRouter.get("/api/get-posts", getPosts);
postRouter.post("/api/delete-posts", delPost);
postRouter.post("/api/like-post", likePost);

export default postRouter;

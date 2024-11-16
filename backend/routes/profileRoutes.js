import express from "express";
import {
  getUserData,
  updateUserData,
  updateUserAvatar,
} from "../controllers/profileController.js";
import multer from "multer";
import path from "path";

const profileRouter = express.Router();

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "public/avatar_images/");
  },
  filename: (req, file, cb) => {
    cb(
      null,
      file.fieldname + "_" + Date.now() + path.extname(file.originalname)
    );
  },
});

const upload = multer({ storage: storage });

profileRouter.post("/api/get-user-data", getUserData);
profileRouter.post("/api/update-user-data", updateUserData);
profileRouter.post(
  "/api/update-user-avatar",
  upload.single("avatar"),
  updateUserAvatar
);

export default profileRouter;

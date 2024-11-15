import express from "express";
import {
  login,
  signUp,
  // getUserData,
  // verifyToken,
  // sendResetPasswordMail,
  // resetPassword,
} from "../controllers/authController.js";

const authRouter = express.Router();

authRouter.post("/api/signup", signUp);
authRouter.post("/api/login", login);
// authRouter.get("/api/get-user-data", getUserData);
// authRouter.get("/api/verify/:token", verifyToken);
// authRouter.post("/api/get-reset-password-mail", sendResetPasswordMail);
// authRouter.post("/api/reset-password", resetPassword);

export default authRouter;

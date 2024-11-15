import { User } from "../models/userModel.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import crypto from "crypto";

export const signUp = async (req, res) => {
  const { email, password, username } = req.body;
  try {
    if (!email || !password || !username) {
      throw new Error("All field are required");
    }

    const userAlreadyExists = await User.findOne({ email });
    if (userAlreadyExists) {
      return res
        .status(409)
        .json({ msg: "User already exists", status: "error" });
    }

    const hashPassword = await bcrypt.hash(password, 10);

    const addUser = new User({
      email,
      password: hashPassword,
      username,
    });

    await addUser.save();
    res
      .status(201)
      .json({ msg: "User created successfully", status: "success" });
  } catch (error) {
    return res.status(400).json({ error: error.message, status: "error" });
  }
};

export const login = async (req, res) => {
  const { email, password } = req.body;
  console.log(req.body);
  try {
    const checkUser = await User.findOne({ email });

    if (!checkUser) {
      return res.status(400).json({ msg: "User not found", status: "error" });
    }

    const isMatch = await bcrypt.compare(password, checkUser.password);
    if (!isMatch) {
      return res
        .status(400)
        .json({ msg: "Invalid credentials", status: "error" });
    }
    if (isMatch) {
      const tokenData = {
        id: checkUser._id,
      };
      const token = await jwt.sign(tokenData, process.env.SECRET, {
        expiresIn: "1d",
      });
      await User.updateOne({ _id: checkUser._id }, { token: token });
      return res.status(201).json({
        msg: "Login successful",
        status: "success",
        token,
        uid: checkUser._id,
      });
    }
  } catch (error) {
    return res.status(500).json({ msg: error.message, status: "error" });
  }
};

// export const Logout = async (req, res) => {
//   res.send("Login sucessful");
// };

// export const getUserData = async (req, res) => {
//   const { token } = req.query;
//   try {
//     const getUser = await User.findOne({ token });
//     if (getUser) {
//       res.status(200).json({
//         msg: "User data fetched sucessfully",
//         userData: {
//           username: getUser.username,
//           email: getUser.email,
//           isAdmin: getUser.isAdmin,
//           userId: getUser._id,
//         },
//         success: true,
//       });
//     } else {
//       res.status(404).json({ msg: "User Token invalid", success: false });
//     }
//   } catch (error) {
//     res.status(403).json({ msg: "Server error" });
//   }
// };

// export const verifyToken = async (req, res) => {
//   const { token } = req.params;
//   try {
//     const getUser = await User.findOne({
//       emailVerificationToken: token,
//       emailVerificationExpires: { $gt: Date.now() },
//     });

//     if (!getUser) {
//       return res.status(400).json({ msg: "Invalid or expired token" });
//     }

//     getUser.isVerified = true;
//     getUser.emailVerificationToken = null;
//     getUser.emailVerificationExpires = null;
//     await getUser.save();

//     res.status(200).json({ msg: "Email verified successfully", success: true });
//   } catch (error) {
//     res.status(400).json({ msg: "Invalid or expired token" });
//   }
// };

// export const sendResetPasswordMail = async (req, res) => {
//   const { email } = req.body;
//   try {
//     const getUser = await User.findOne({ email });
//     if (!getUser) {
//       return res.status(400).json({ msg: "User not found", success: false });
//     }

//     const resetToken = crypto.randomBytes(32).toString("hex");
//     getUser.resetPasswordToken = resetToken;
//     getUser.resetPasswordExpires = Date.now() + 3600000;
//     await getUser.save();

//     const resetUrl = `${process.env.BASE_URL}/reset-password/${resetToken}`;

//     await transporter.sendMail({
//       from: "no-reply@yourapp.com",
//       to: email,
//       subject: "Reset Password",
//       html: `<h1>Reset Password</h1>
//          <p>Please reset your password by clicking on the link below:</p>
//          <a href="${resetUrl}">${resetUrl}</a>`,
//     });

//     res.status(201).json({
//       msg: "Password reset email sent successfully",
//       success: true,
//       resetPasswordToken: resetToken,
//     });
//   } catch (error) {
//     res.status(400).json({ msg: "Server error" });
//   }
// };

// export const resetPassword = async (req, res) => {
//   const { resetPasswordToken, newPassword } = req.body;
//   try {
//     const getUser = await User.findOne({
//       resetPasswordToken: resetPasswordToken,
//     });
//     const checkTokenValidity = async () => {
//       const expiry = getUser.resetPasswordExpires;
//       if (expiry && new Date().getTime() < expiry) {
//         return true;
//       } else {
//         return false;
//       }
//     };

//     if (!checkTokenValidity) {
//       return res.status(400).json({ msg: "Token expired", success: false });
//     }

//     const hashPassword = await bcrypt.hash(newPassword, 10);

//     getUser.password = hashPassword;
//     getUser.resetPasswordToken = null;
//     getUser.resetPasswordExpires = null;
//     await getUser.save();

//     res.status(201).json({
//       msg: "Password reset successfully",
//       success: true,
//     });
//   } catch (error) {
//     res.status(400).json({ msg: "Server error" });
//   }
// };

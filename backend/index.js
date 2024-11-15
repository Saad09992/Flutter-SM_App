import express from "express";
import { db } from "./config/db.js";
import dotenv from "dotenv";
import cors from "cors";
import authRoutes from "./routes/authRoutes.js";
import profileRoutes from "./routes/profileRoutes.js";

dotenv.config();
const app = express();
const PORT = process.env.PORT || 7001;
app.use(cors());
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

app.use("/", authRoutes);
app.use("/", profileRoutes);

app.listen(PORT, () => {
  db();
  console.log(`Server started at PORT:${PORT}`);
});

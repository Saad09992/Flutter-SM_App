import mongoose from "mongoose";

export const db = async () => {
  try {
    const connection = await mongoose.connect(process.env.MONGOOSE_URI);
    console.log(`MongoDb connected ${connection.connection.host}`);
  } catch (error) {
    console.log(`Error: ${error.message}`);
    process.exit(1);
  }
};

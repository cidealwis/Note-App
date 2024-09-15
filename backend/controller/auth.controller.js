import User from "../models/user.model.js"
import { errorHandler } from "../utils/error.js"
import bcryptjs from "bcryptjs"
import jwt from "jsonwebtoken"
import dotenv from "dotenv"
import { mailOptions,sendEmail } from "../lib/emailService.js"
dotenv.config();
export const signup = async (req, res, next) => {
  const { username, email, password } = req.body

  const isValidUser = await User.findOne({ email })

  if (isValidUser) {
    return next(errorHandler(400, "User already Exist"))
  }
console.log(email)
// Send email to the user with their username and password
const options = mailOptions({
  to: email, // User's email
  subject: 'Welcome to Our Note App',
  html: `
      <h3>Welcome, ${username}!</h3>
      <p>Thank you for registering. Here are your account details:</p>
      <p><strong>Username:</strong> ${email}</p>
      <p><strong>Password:</strong> ${password}</p>
      <p>Please keep this information safe.</p>
  `
});

sendEmail(options);

  const hashedPassword = bcryptjs.hashSync(password, 10)
  
  const newUser = new User({
    username,
    email,
    password: hashedPassword,
  })

  try {
    await newUser.save()

    res.status(201).json({
      success: true,
      message: "User Created Successfully",
    })
  } catch (error) {
    next(error)
  }
}

export const signin = async (req, res, next) => {
  const { email, password } = req.body

  try {
    const validUser = await User.findOne({ email })

    if (!validUser) {
      return next(errorHandler(404, "User not found"))
    }

    const validPassword = bcryptjs.compareSync(password, validUser.password)

    if (!validPassword) {
      return next(errorHandler(401, "Wrong Credentials"))
    }

    const token = jwt.sign({ id: validUser._id }, process.env.JWT_SECRET)

    const { password: pass, ...rest } = validUser._doc

    res.cookie("access_token", token, { httpOnly: true }).status(200).json({
      success: true,
      message: "Login Successful!",
      rest,
    })
  } catch (error) {
    next(error)
  }
}

export const signout = async (req, res, next) => {
  try {
    res.clearCookie("access_token")

    res.status(200).json({
      success: true,
      message: "User logged out successfully",
    })
  } catch (error) {
    next(error)
  }
}
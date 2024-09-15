import nodemailer from "nodemailer";
import dotenv from "dotenv";

dotenv.config();

const email = process.env.EMAIL;
const emailPassword = process.env.EMAIL_PASSWORD;

var transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: email,
        pass: emailPassword
    }
});

export const mailOptions = ({ to, subject, html }) => {
    return {
        from: email,
        to: to,
        subject: subject,
        html: html,
    };
};

export const sendEmail = (options) => {
    transporter.sendMail(options, function(error, info) {
        if (error) {
            console.log("Error sending email:", error);
        } else {
            console.log('Email sent: ' + info.response);
        }
    });
};

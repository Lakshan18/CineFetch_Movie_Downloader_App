// const {onDocumentCreated} = require("firebase-functions/v2/firestore");
// const {initializeApp} = require("firebase-admin/app");
// const nodemailer = require("nodemailer");

// initializeApp();

// // Set these in Firebase config (see next step)
// const gmailEmail = process.env.GMAIL_EMAIL; 
// const gmailPassword = process.env.GMAIL_PASSWORD;

// const transporter = nodemailer.createTransport({
//   service: "gmail",
//   auth: {
//     user: gmailEmail,
//     pass: gmailPassword,
//   },
// });

// exports.sendVerificationCode = onDocumentCreated({
//   document: "user/{userId}",
//   region: "us-central1", // Set your preferred region
// }, async (event) => {
//   try {
//     const snapshot = event.data;
//     const user = snapshot.data();
//     const code = user.verificationCode;
//     const email = user.email;

//     if (!code || !email) {
//       console.error("Missing verification code or email");
//       return;
//     }

//     const mailOptions = {
//       from: `CineFetch <${gmailEmail}>`,
//       to: email,
//       subject: 'Your CineFetch Verification Code',
//       text: `Your verification code is: ${code}`,
//       html: `
//         <h2>Welcome to CineFetch!</h2>
//         <p>Your verification code is: <strong>${code}</strong></p>
//         <p>Enter this code in the app to verify your email address.</p>
//       `,
//     };

//     await transporter.sendMail(mailOptions);
//     console.log("Verification email sent to:", email);
//   } catch (error) {
//     console.error("Error sending email:", error);
//   }
// });



// const {onDocumentCreated} = require("firebase-functions/v2/firestore");
// const {initializeApp} = require("firebase-admin/app");
// const {getFirestore} = require("firebase-admin/firestore");
// const nodemailer = require("nodemailer");

// initializeApp();

// const gmailEmail = process.env.GMAIL_EMAIL;
// const gmailPassword = process.env.GMAIL_PASSWORD;

// const transporter = nodemailer.createTransport({
//   service: "gmail",
//   auth: {
//     user: gmailEmail,
//     pass: gmailPassword,
//   },
// });

// exports.sendVerificationCode = onDocumentCreated("user/{userId}", async (event) => {
//   try {
//     const user = event.data.data();
//     const code = user.verificationCode;
//     const email = user.email;

//     if (!code || !email) {
//       console.error("Missing verification code or email");
//       return;
//     }

//     const mailOptions = {
//       from: `Your App <${gmailEmail}>`,
//       to: email,
//       subject: "Your Verification Code",
//       text: `Your verification code is: ${code}`,
//       html: `<p>Your verification code is: <strong>${code}</strong></p>`,
//     };

//     await transporter.sendMail(mailOptions);
//     console.log("Verification email sent to:", email);
//   } catch (error) {
//     console.error("Error sending email:", error);
//   }
// });



// const {onDocumentCreated} = require("firebase-functions/v2/firestore");
// const {initializeApp} = require("firebase-admin/app");
// const nodemailer = require("nodemailer");

// initializeApp();

// // Set these using: firebase functions:config:set gmail.email="..." gmail.password="..."
// const gmailEmail = process.env.GMAIL_EMAIL;
// const gmailPassword = process.env.GMAIL_PASSWORD;

// const transporter = nodemailer.createTransport({
//   service: "gmail",
//   auth: {
//     user: gmailEmail,
//     pass: gmailPassword,
//   },
// });

// exports.sendVerificationCode = onDocumentCreated({
//   document: "users/{userId}",
//   region: "us-central1",
// }, async (event) => {
//   try {
//     const snapshot = event.data;
//     const userData = snapshot.data();
    
//     const email = userData.email;
//     const verificationCode = userData.verificationCode;
//     const firstName = userData.firstName || "User";

//     if (!email || !verificationCode) {
//       console.error("Missing email or verification code");
//       return;
//     }

//     const mailOptions = {
//       from: `CineFetch <${gmailEmail}>`,
//       to: email,
//       subject: 'Your CineFetch Verification Code',
//       html: `
//         <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
//           <h2 style="color: #1A73E8;">Welcome to CineFetch, ${firstName}!</h2>
//           <p>Please use the following verification code to complete your registration:</p>
//           <div style="background: #f5f5f5; padding: 20px; text-align: center; margin: 20px 0; font-size: 24px; font-weight: bold;">
//             ${verificationCode}
//           </div>
//           <p>This code will expire in 30 minutes.</p>
//           <p>If you didn't request this, please ignore this email.</p>
//           <hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
//           <p style="font-size: 12px; color: #777;">
//             © ${new Date().getFullYear()} CineFetch. All rights reserved.
//           </p>
//         </div>
//       `,
//       text: `Your CineFetch verification code is: ${verificationCode}`,
//     };

//     await transporter.sendMail(mailOptions);
//     console.log(`Verification email sent to ${email}`);
//   } catch (error) {
//     console.error("Error sending verification email:", error);
//   }
// });

const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { defineString } = require("firebase-functions/params");
const { initializeApp } = require("firebase-admin/app");
const nodemailer = require("nodemailer");

// Initialize Firebase
initializeApp();

// Define configuration parameters
const gmailEmail = defineString("GMAIL_EMAIL");
const gmailPassword = defineString("GMAIL_PASSWORD");

// Create email transporter
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: gmailEmail.value(),
    pass: gmailPassword.value(),
  },
});

exports.sendVerificationCode = onDocumentCreated({
  document: "users/{userId}",
  region: "us-central1",
}, async (event) => {
  try {
    const snapshot = event.data;
    const userData = snapshot.data();

    const mailOptions = {
      from: `"CineFetch" <${gmailEmail.value()}>`,
      to: userData.email,
      subject: "Your 6-Digit Verification Code",
      text: `Your verification code is: ${userData.verificationCode}`,
      html: `
        <div style="font-family: Arial, sans-serif;">
          <h2 style="color: #1a73e8;">CineFetch Verification</h2>
          <p>Your verification code is:</p>
          <div style="font-size: 24px; font-weight: bold; margin: 20px 0;">
            ${userData.verificationCode}
          </div>
          <p>This code will expire in 30 minutes.</p>
        </div>
      `,
    };

    await transporter.sendMail(mailOptions);
    console.log(`Verification email sent to ${userData.email}`);
  } catch (error) {
    console.error("Failed to send verification email:", error);
    throw error;
  }
});
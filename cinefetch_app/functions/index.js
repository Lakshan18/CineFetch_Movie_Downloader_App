// const { onDocumentCreated } = require("firebase-functions/v2/firestore");
// const { defineString } = require("firebase-functions/params");
// const { initializeApp } = require("firebase-admin/app");
// const nodemailer = require("nodemailer");

// // Initialize Firebase
// initializeApp();

// // Define configuration parameters
// const gmailEmail = defineString("GMAIL_EMAIL");
// const gmailPassword = defineString("GMAIL_PASSWORD");

// // Create email transporter
// const transporter = nodemailer.createTransport({
//   service: "gmail",
//   auth: {
//     user: gmailEmail.value(),
//     pass: gmailPassword.value(),
//   },
// });

// exports.sendVerificationCode = onDocumentCreated({
//   document: "users/{userId}",
//   region: "us-central1",
// }, async (event) => {
//   try {
//     const snapshot = event.data;
//     const userData = snapshot.data();

//     const mailOptions = {
//       from: `"CineFetch" <${gmailEmail.value()}>`,
//       to: userData.email,
//       subject: "Your 6-Digit Verification Code",
//       text: `Your verification code is: ${userData.verificationCode}`,
//       html: `
//         <div style="font-family: Arial, sans-serif;">
//           <h2 style="color: #1a73e8;">CineFetch Verification</h2>
//           <p>Your verification code is:</p>
//           <div style="font-size: 24px; font-weight: bold; margin: 20px 0;">
//             ${userData.verificationCode}
//           </div>
//           <p>This code will expire in 30 minutes.</p>
//         </div>
//       `,
//     };

//     await transporter.sendMail(mailOptions);
//     console.log(`Verification email sent to ${userData.email}`);
//   } catch (error) {
//     console.error("Failed to send verification email:", error);
//     throw error;
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

exports.sendVerificationEmail = onDocumentCreated(
  {
    document: "user/{userId}",
    region: "us-central1",
  }, 
  async (event) => {
    try {
      const snapshot = event.data;
      const userData = snapshot.data();

      if (!userData.email || !userData.verificationCode) {
        console.log("No email or verification code found");
        return;
      }

      const mailOptions = {
        from: `CineFetch <${gmailEmail.value()}>`,
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
    }
  }
);
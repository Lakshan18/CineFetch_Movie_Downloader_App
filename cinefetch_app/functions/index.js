// const { onDocumentUpdated , onDocumentCreated } = require("firebase-functions/v2/firestore");
// const { defineString } = require("firebase-functions/params");
// const { initializeApp } = require("firebase-admin/app");
// const nodemailer = require("nodemailer");

// // Initialize Firebase
// initializeApp();

// // Reuse your existing email configuration
// const gmailEmail = defineString("GMAIL_EMAIL");
// const gmailPassword = defineString("GMAIL_PASSWORD");

// const transporter = nodemailer.createTransport({
//   service: "gmail",
//   auth: {
//     user: gmailEmail.value(),
//     pass: gmailPassword.value(),
//   },
// });

// exports.sendVerificationEmail = onDocumentCreated(
//   {
//     document: "user/{userId}",
//     region: "us-central1",
//   },
//   async (event) => {
//     await handleEmailSending(event, "registration");
//   }
// );

// exports.sendPasswordResetEmail = onDocumentUpdated(
//   {
//     document: "user/{userId}",
//     region: "us-central1",
//   },
//   async (event) => {
//     await handleEmailSending(event, "passwordReset");
//   }
// );

// async function handleEmailSending(event, type) {
//   try {
//     const snapshot = type === "registration" ? event.data : event.data.after;
//     const userData = snapshot.data();

//     // For password reset, check if this is actually a reset request
//     if (type === "passwordReset" && !userData.isPasswordReset) {
//       return;
//     }

//     if (!userData.email || !userData.verificationCode) {
//       console.log("No email or verification code found");
//       return;
//     }

//     const subject = type === "registration"
//       ? "Your 6-Digit Verification Code"
//       : "Password Reset Verification Code";

//     const header = type === "registration"
//       ? "CineFetch Verification"
//       : "CineFetch Password Reset";

//     const additionalText = type === "passwordReset"
//       ? "<p>If you didn't request this, please ignore this email.</p>"
//       : "";

//     const mailOptions = {
//       from: `CineFetch <${gmailEmail.value()}>`,
//       to: userData.email,
//       subject: subject,
//       text: `Your verification code is: ${userData.verificationCode}`,
//       html: `
//         <div style="font-family: Arial, sans-serif;">
//           <h2 style="color: #1a73e8;">${header}</h2>
//           <p>Your verification code is:</p>
//           <div style="font-size: 24px; font-weight: bold; margin: 20px 0;">
//             ${userData.verificationCode}
//           </div>
//           <p>This code will expire in 30 minutes.</p>
//           ${additionalText}
//         </div>
//       `,
//     };

//     await transporter.sendMail(mailOptions);
//     console.log(`Email (${type}) sent to ${userData.email}`);
//   } catch (error) {
//     console.error(`Failed to send ${type} email:`, error);
//   }
// }



// const { onDocumentCreated, onDocumentUpdated } = require("firebase-functions/v2/firestore");
// const { defineString } = require("firebase-functions/params");
// const { initializeApp } = require("firebase-admin/app");
// const nodemailer = require("nodemailer");

// // Initialize Firebase
// initializeApp();

// // Email configuration
// const gmailEmail = defineString("GMAIL_EMAIL");
// const gmailPassword = defineString("GMAIL_PASSWORD");

// // Create reusable transporter object
// const transporter = nodemailer.createTransport({
//   service: "gmail",
//   auth: {
//     user: gmailEmail.value(),
//     pass: gmailPassword.value(),
//   },
// });

// exports.sendVerificationEmail = onDocumentCreated(
//   {
//     document: "user/{userId}",  // Make sure this matches your actual collection name
//     region: "us-central1",
//   },
//   async (event) => {
//     await handleEmailSending(event, "registration");
//   }
// );

// exports.sendPasswordResetEmail = onDocumentUpdated(
//   {
//     document: "user/{userId}",  // Make sure this matches your actual collection name
//     region: "us-central1",
//   },
//   async (event) => {
//     await handleEmailSending(event, "passwordReset");
//   }
// );

// async function handleEmailSending(event, type) {
//   try {
//     // Validate event data
//     if (!event.data) {
//       console.error("No data found in event");
//       return;
//     }

//     const snapshot = type === "registration" ? event.data : event.data.after;
//     if (!snapshot.exists) {
//       console.log("Document does not exist");
//       return;
//     }

//     const userData = snapshot.data();

//     // Additional check for password reset
//     if (type === "passwordReset" && !userData.isPasswordReset) {
//       console.log("Not a password reset request");
//       return;
//     }

//     // Validate required fields
//     if (!userData.email || !userData.verificationCode) {
//       console.log("Missing required fields: email or verificationCode");
//       return;
//     }



//     // Email content configuration
//     const emailConfig = {
//       registration: {
//         subject: "Your 6-Digit Verification Code",
//         header: "CineFetch Verification",
//         action: "complete your registration",
//       },
//       passwordReset: {
//         subject: "Password Reset Verification Code",
//         header: "CineFetch Password Reset",
//         action: "reset your password",
//       }
//     };

//     const config = emailConfig[type];
//     const additionalText = type === "passwordReset" 
//       ? "<p style='margin-top: 20px; color: #666;'>If you didn't request this, please ignore this email.</p>" 
//       : "";

//     // Create email HTML
//     const emailHtml = `
//     <!DOCTYPE html>
//     <html>
//     <head>
//         <meta charset="UTF-8">
//         <style>
//             body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
//             .container { max-width: 600px; margin: 0 auto; padding: 20px; }
//             .header { color: #1a73e8; font-size: 24px; margin-bottom: 20px; }
//             .code { 
//                 font-size: 28px; 
//                 font-weight: bold; 
//                 letter-spacing: 3px; 
//                 margin: 20px 0;
//                 padding: 10px;
//                 background: #f5f5f5;
//                 display: inline-block;
//             }
//             .footer { margin-top: 30px; font-size: 12px; color: #777; }
//         </style>
//     </head>
//     <body>
//         <div class="container">
//             <div class="header">${config.header}</div>
//             <p>Hello,</p>
//             <p>Here is your verification code to ${config.action}:</p>
//             <div class="code">${userData.verificationCode}</div>
//             <p>This code will expire in 30 minutes.</p>
//             ${additionalText}
//             <p>Best regards,<br>The CineFetch Team</p>
//             <div class="footer">
//                 © ${new Date().getFullYear()} CineFetch. All rights reserved.
//             </div>
//         </div>
//     </body>
//     </html>
//     `;

//     // Send mail
//     const mailOptions = {
//       from: `CineFetch <${gmailEmail.value()}>`,
//       to: userData.email,
//       subject: config.subject,
//       html: emailHtml,
//     };

//     const info = await transporter.sendMail(mailOptions);
//     console.log(`Email (${type}) sent to ${userData.email}`, info.messageId);
    
//   } catch (error) {
//     console.error(`Error sending ${type} email:`, error);
//     // Consider adding retry logic or error reporting here
//   }
// }



const { onDocumentCreated, onDocumentUpdated } = require("firebase-functions/v2/firestore");
const { defineString } = require("firebase-functions/params");
const { initializeApp } = require("firebase-admin/app");
const { FieldValue } = require("firebase-admin/firestore");
const nodemailer = require("nodemailer");

initializeApp();

const gmailEmail = defineString("GMAIL_EMAIL");
const gmailPassword = defineString("GMAIL_PASSWORD");

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
    await handleEmailSending(event, "registration");
  }
);

exports.sendPasswordResetEmail = onDocumentUpdated(
  {
    document: "user/{userId}",
    region: "us-central1",
  },
  async (event) => {
    const beforeData = event.data.before.data();
    const afterData = event.data.after.data();

    if (afterData.isPasswordReset) {
      return handleEmailSending(event, "passwordReset");
    }

    if (afterData.verificationCode && 
        afterData.verificationCode !== beforeData?.verificationCode &&
        afterData.email) {
      return handleEmailSending({
        ...event,
        data: { exists: true, data: () => afterData }
      }, "registration");
    }

    return null;
  }
);

async function handleEmailSending(event, type) {
  try {
    if (!event.data) {
      console.error("No data found in event");
      return;
    }

    const snapshot = type === "registration" ? event.data : event.data.after;
    if (!snapshot.exists) {
      console.log("Document does not exist");
      return;
    }

    const userData = snapshot.data();

    if (type === "passwordReset" && !userData.isPasswordReset) {
      console.log("Not a password reset request");
      return;
    }

    if (!userData.email || !userData.verificationCode) {
      console.log("Missing required fields: email or verificationCode");
      return;
    }

    const emailConfig = {
      registration: {
        subject: "Your 6-Digit Verification Code",
        header: "CineFetch Verification",
        action: "complete your registration",
      },
      passwordReset: {
        subject: "Password Reset Verification Code",
        header: "CineFetch Password Reset",
        action: "reset your password",
      }
    };

    const config = emailConfig[type];
    const additionalText = type === "passwordReset" 
      ? "<p style='margin-top: 20px; color: #666;'>If you didn't request this, please ignore this email.</p>" 
      : "";

    const emailHtml = `
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <style>
            body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
            .container { max-width: 600px; margin: 0 auto; padding: 20px; }
            .header { color: #1a73e8; font-size: 24px; margin-bottom: 20px; }
            .code { 
                font-size: 28px; 
                font-weight: bold; 
                letter-spacing: 3px; 
                margin: 20px 0;
                padding: 10px;
                background: #f5f5f5;
                display: inline-block;
            }
            .footer { margin-top: 30px; font-size: 12px; color: #777; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">${config.header}</div>
            <p>Hello,</p>
            <p>Here is your verification code to ${config.action}:</p>
            <div class="code">${userData.verificationCode}</div>
            <p>This code will expire in 30 minutes.</p>
            ${additionalText}
            <p>Best regards,<br>The CineFetch Team</p>
            <div class="footer">
                © ${new Date().getFullYear()} CineFetch. All rights reserved.
            </div>
        </div>
    </body>
    </html>
    `;

    const mailOptions = {
      from: `CineFetch <${gmailEmail.value()}>`,
      to: userData.email,
      subject: config.subject,
      html: emailHtml,
    };

    const info = await transporter.sendMail(mailOptions);
    console.log(`Email (${type}) sent to ${userData.email}`, info.messageId);
    
  } catch (error) {
    console.error(`Error sending ${type} email:`, error);
  }
}



// const { onDocumentCreated, onDocumentUpdated } = require("firebase-functions/v2/firestore");
// const { defineString } = require("firebase-functions/params");
// const { initializeApp } = require("firebase-admin/app");
// const nodemailer = require("nodemailer");
// const { getFirestore } = require("firebase-admin/firestore");

// // Initialize Firebase
// initializeApp();
// const db = getFirestore();

// // Reuse your existing email configuration
// const gmailEmail = defineString("GMAIL_EMAIL");
// const gmailPassword = defineString("GMAIL_PASSWORD");

// const transporter = nodemailer.createTransport({
//   service: "gmail",
//   auth: {
//     user: gmailEmail.value(),
//     pass: gmailPassword.value(),
//   },
// });

// exports.sendVerificationEmail = onDocumentCreated(
//   {
//     document: "user/{userId}",
//     region: "us-central1",
//   },
//   async (event) => handleEmailSending(event, "registration")
// );

// exports.sendPasswordResetEmail = onDocumentUpdated(
//   {
//     document: "user/{userId}",
//     region: "us-central1",
//   },
//   async (event) => handleEmailSending(event, "passwordReset")
// );

// async function handleEmailSending(event, type) {
//   try {
//     const snapshot = type === "registration" ? event.data : event.data.after;
//     const userData = snapshot.data();

//     // For password reset, check if this is actually a reset request
//     if (type === "passwordReset" && !userData.isPasswordReset) {
//       return;
//     }

//     if (!userData.email || !userData.verificationCode) {
//       console.log("No email or verification code found");
//       return;
//     }

//     const subject = type === "registration"
//       ? "Your 6-Digit Verification Code"
//       : "Password Reset Verification Code";

//     const header = type === "registration"
//       ? "CineFetch Verification"
//       : "CineFetch Password Reset";

//     const additionalText = type === "passwordReset"
//       ? "<p style='margin: 16px 0 0; color: #666;'>If you didn't request this, please ignore this email.</p>"
//       : "";

//     const mailOptions = {
//       from: `CineFetch <${gmailEmail.value()}>`,
//       to: userData.email,
//       subject: subject,
//       html: generateEmailTemplate(userData.verificationCode, header, type, additionalText),
//     };

//     await transporter.sendMail(mailOptions);
//     console.log(`Email (${type}) sent to ${userData.email}`);
//   } catch (error) {
//     console.error(`Failed to send ${type} email:`, error);
//   }
// }

// function generateEmailTemplate(code, header, type, additionalText) {
//   return `
//   <!DOCTYPE html>
//   <html>
//   <head>
//       <meta charset="UTF-8">
//       <meta name="viewport" content="width=device-width, initial-scale=1.0">
//       <title>${header}</title>
//       <style>
//         @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap');
        
//         body {
//           font-family: 'Poppins', Arial, sans-serif;
//           background-color: #f5f7fa;
//           margin: 0;
//           padding: 0;
//           color: #333;
//         }
        
//         .email-container {
//           max-width: 600px;
//           margin: 0 auto;
//           background: #ffffff;
//           border-radius: 12px;
//           overflow: hidden;
//           box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
//         }
        
//         .header {
//           background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
//           padding: 30px 20px;
//           text-align: center;
//           color: white;
//         }
        
//         .header h1 {
//           margin: 0;
//           font-size: 24px;
//           font-weight: 600;
//         }
        
//         .content {
//           padding: 30px;
//         }
        
//         .code-container {
//           background: #f8f9fa;
//           border-radius: 8px;
//           padding: 20px;
//           text-align: center;
//           margin: 25px 0;
//           border: 1px dashed #e0e0e0;
//         }
        
//         .verification-code {
//           font-size: 32px;
//           font-weight: 700;
//           letter-spacing: 3px;
//           color: #2d3748;
//           margin: 10px 0;
//           font-family: 'Courier New', monospace;
//         }
        
//         .footer {
//           text-align: center;
//           padding: 20px;
//           font-size: 12px;
//           color: #718096;
//           border-top: 1px solid #edf2f7;
//         }
        
//         .note {
//           font-size: 14px;
//           color: #718096;
//           line-height: 1.5;
//         }
        
//         .highlight {
//           color: #667eea;
//           font-weight: 600;
//         }
//       </style>
//   </head>
//   <body>
//       <div class="email-container">
//           <div class="header">
//               <h1>${header}</h1>
//           </div>
          
//           <div class="content">
//               <p>Hello,</p>
//               <p>Here is your verification code to ${type === 'registration' ? 'complete your registration' : 'reset your password'}:</p>
              
//               <div class="code-container">
//                   <p style="margin: 0 0 10px; font-size: 14px; color: #718096;">Your verification code:</p>
//                   <div class="verification-code">${code}</div>
//                   <p style="margin: 10px 0 0; font-size: 14px; color: #718096;">Expires in <span class="highlight">30 minutes</span></p>
//               </div>
              
//               <p class="note">Please enter this code in the ${type === 'registration' ? 'registration' : 'password reset'} form to verify your account.</p>
              
//               ${additionalText}
              
//               <p>Best regards,<br>The CineFetch Team</p>
//           </div>
          
//           <div class="footer">
//               <p>© ${new Date().getFullYear()} CineFetch. All rights reserved.</p>
//               <p>If you need any help, please contact us at <a href="mailto:${gmailEmail.value()}">${gmailEmail.value()}</a></p>
//           </div>
//       </div>
//   </body>
//   </html>
//   `;
// }
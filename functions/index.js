const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
exports.sendNotificationOnNewTransaction = functions.firestore
  .document("users/{userId}/transactions/{transactionId}")
  .onCreate(async (snap, context) => {
    console.log("Function triggered");

    const transactionData = snap.data();

    // Fetch all admin users
    const adminUsersSnapshot = await admin
      .firestore()
      .collection("users")
      .where("isAdmin", "==", true)
      .get();

    console.log(`Fetched ${adminUsersSnapshot.size} admin users`);

    // Prepare notification
    const notification = {
      title: "New Transaction",
      body: `A new transaction has been added.`,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    };

    // Save notification in 'notifications' subcollection of each admin user's document
    adminUsersSnapshot.forEach((doc) => {
      admin
        .firestore()
        .collection("users")
        .doc(doc.id)
        .collection("notifications")
        .add(notification);
    });

    console.log(
      "Notification saved in 'notifications' subcollection of each admin user's document"
    );

    // Send notification to each admin user
    adminUsersSnapshot.forEach((doc) => {
      const user = doc.data();
      if (user.fcmToken) {
        // assuming each user document has an FCM token
        admin.messaging().sendToDevice(user.fcmToken, { notification });
      }
    });

    console.log("Notification sent to admin users");
  });

const functions = require("firebase-functions");
const admin = require("firebase-admin");
var serviceAccount = require("./service_account.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

exports.sendNotification = functions.https.onCall((data, context) => {
  const payload = {
    notification: {
      title: "The title of the notification",
      body: data["your_param_sent_from_the_client"],
    },
  };
  admin
    .messaging()
    .sendToTopic("AllPushNotifications", payload)
    .then((value) => {
            console.log(value);
                        console.log(context);


      console.info("function executed succesfully");
      return { msg: "function executed succesfully" };
    })
    .catch((error) => {
      console.info("error in execution");
      console.log(error);
      return { msg: "error in execution" };
    });

});

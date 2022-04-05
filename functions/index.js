const functions = require("firebase-functions");
const admin = require("firebase-admin");
var serviceAccount = require("./service_account.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

exports.activateContractNotification = functions.https.onCall((data) => {
  const payload = {
    notification: {
      title: data["title"],
      body: data["body"],
    },
  };
  admin
    .messaging()
    .sendToTopic(data["topic"], payload)
    .then((value) => {
    console.log(value);
      console.info("function executed succesfully");
      return { msg: "function executed succesfully" };
    })
    .catch((error) => {
      console.info("error in execution");
      console.log(error);
      return { msg: "error in execution" };
    });

});

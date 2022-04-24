const functions = require("firebase-functions");
const admin = require("firebase-admin");
var serviceAccount = require("./service_account.json");
const nodemailer = require("nodemailer");
const fs = require("fs");
var path = require("path");
var handlebars = require("handlebars");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

const gmailEmail = "forgetaboutprivacy@gmail.com";
const gmailPassword = "LvB$$95dJ@@!$6||";
const mailTransport = nodemailer.createTransport({
    service: "gmail",
    auth: {
        user: gmailEmail,
        pass: gmailPassword,
    },
});

exports.sendWelcomeEmail = functions.https.onCall((data) => {
    var readHTMLFile = function (path, callback) {
        fs.readFile(path, { encoding: "utf-8" }, function (error, html) {
            if (error) {
                callback(error);
                throw error;
            } else {
                callback(null, html);
            }
        });
    };

    readHTMLFile(path.resolve(__dirname, "./templates/welcome_template.html"), function (error, html) {
        var template = handlebars.compile(html);
        var replacements = {
            username: data["username"],
            body: data["body"],
        };

        var htmlToSend = template(replacements);
        var mailOptions = {
            from: "Commit <forgetaboutprivacy@gmail.com>",
            to: data["email"],
            subject: data["title"],
            html: htmlToSend,
        };

        mailTransport.sendMail(mailOptions, function (error) {
            if (error) {
                console.log(error);
            }
        });
    });
    return null;
});

exports.verifyEmailEmail = functions.https.onCall((data) => {

    var readHTMLFile = function (path, callback) {
        fs.readFile(path, { encoding: "utf-8" }, function (error, html) {
            if (error) {
                callback(error);
                throw error;
            } else {
                callback(null, html);
            }
        });
    };

    readHTMLFile(path.resolve(__dirname, "./templates/verify_email_template.html"), function (error, html) {

        const actionCodeSettings = {
            url: 'https://commit-b9e29.web.app',
            handleCodeInApp: true,
            iOS: {
                bundleId: 'com.j0ost.commit',
            },
            android: {
                packageName: 'com.j0ost.commit',
                installApp: true,
                minimumVersion: '23',
            },
            // FDL custom domain.
            dynamicLinkDomain: 'https://commit-b9e29.web.app',
        };

        admin.auth().generateEmailVerificationLink(data["email"], actionCodeSettings)
            .then((link) => {

                var template = handlebars.compile(html);
                var replacements = {
                    username: data["username"],
                    body: data["body"],
                    link: link
                };


                var htmlToSend = template(replacements);
                var mailOptions = {
                    from: "Commit <forgetaboutprivacy@gmail.com>",
                    to: data["email"],
                    subject: data["title"],
                    html: htmlToSend,
                };

                mailTransport.sendMail(mailOptions, function (error) {
                    if (error) {
                        console.log(error);
                    }
                });
            })
            .catch((error) => {
                console.log(error);
            });


    });

    return null;
});

exports.resetPasswordEmail = functions.https.onCall((data) => {

    var readHTMLFile = function (path, callback) {
        fs.readFile(path, { encoding: "utf-8" }, function (error, html) {
            if (error) {
                callback(error);
                throw error;
            } else {
                callback(null, html);
            }
        });
    };

    readHTMLFile(path.resolve(__dirname, "./templates/reset_password_template.html"), function (error, html) {

        // const actionCodeSettings = {
        //     url: 'http://localhost:3000',
        //     handleCodeInApp: false
        // };

        const actionCodeSettings = {
            url: 'https://commit-b9e29.web.app',
            handleCodeInApp: true,
            iOS: {
                bundleId: 'com.j0ost.commit',
            },
            android: {
                packageName: 'com.j0ost.commit',
                installApp: true,
                minimumVersion: '23',
            },
            // FDL custom domain.
            dynamicLinkDomain: 'https://commit-b9e29.web.app',
        };

        admin.auth().generatePasswordResetLink(data["email"], actionCodeSettings)
            .then((link) => {

                var template = handlebars.compile(html);
                var replacements = {
                    username: data["username"] ?? '',
                    body: data["body"],
                    link: link
                };


                var htmlToSend = template(replacements);
                var mailOptions = {
                    from: "Commit <forgetaboutprivacy@gmail.com>",
                    to: data["email"],
                    subject: data["title"],
                    html: htmlToSend,
                };

                mailTransport.sendMail(mailOptions, function (error) {
                    if (error) {
                        console.log(error);
                    }
                });
            })
            .catch((error) => {
                console.log(error);
            });


    });

    return null;
});

exports.addContractEmail = functions.https.onCall((data) => {
    var readHTMLFile = function (path, callback) {
        fs.readFile(path, { encoding: "utf-8" }, function (error, html) {
            if (error) {
                callback(error);
                throw error;
            } else {
                callback(null, html);
            }
        });
    };

    readHTMLFile(path.resolve(__dirname, "./templates/add_contract_template.html"), function (error, html) {
        var template = handlebars.compile(html);
        var replacements = {
            username: data["username"],
            body: data["body"],
        };
        var htmlToSend = template(replacements);
        var mailOptions = {
            from: "Commit <forgetaboutprivacy@gmail.com>",
            to: data["email"],
            subject: data["title"],
            html: htmlToSend
        };
        mailTransport.sendMail(mailOptions, function (error) {
            if (error) {
                console.log(error);
            }
        });
    });
    return null;
});

exports.addContractEmailNewUser = functions.https.onCall((data) => {
    var readHTMLFile = function (path, callback) {
        fs.readFile(path, { encoding: "utf-8" }, function (error, html) {
            if (error) {
                callback(error);
                throw error;
            } else {
                callback(null, html);
            }
        });
    };

    readHTMLFile(path.resolve(__dirname, "./templates/add_contract_new_user_template.html"), function (error, html) {
        var template = handlebars.compile(html);
        var replacements = {
            username: data["username"],
            body: data["body"],
        };
        var htmlToSend = template(replacements);
        var mailOptions = {
            from: "Commit <forgetaboutprivacy@gmail.com>",
            to: data["email"],
            subject: data["title"],
            html: htmlToSend
        };
        mailTransport.sendMail(mailOptions, function (error) {
            if (error) {
                console.log(error);
            }
        });
    });

    return null;
});

exports.editContractNotification = functions.https.onCall((data) => {
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

exports.addCommitmentNotification = functions.https.onCall((data) => {
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

exports.editCommitmentNotification = functions.https.onCall((data) => {
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

exports.deleteCommitmentNotification = functions.https.onCall((data) => {
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

exports.subscribeTokenToTopicWeb = functions.https.onCall((data) => {
    admin.messaging()
        .subscribeToTopic(data["token"], data["topic"])
        .then(function (response) {
            console.log("Successfully subscribed to topic:", response);
        })
        .catch(function (error) {
            console.log("Error subscribing to topic:", error);
        });
});

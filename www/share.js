const exec = require("cordova/exec");

module.exports = function (textOrOptions, title, mimetype, success, error) {
  let text = textOrOptions;

  if (textOrOptions && typeof textOrOptions === "object") {
    text = textOrOptions.text || textOrOptions.url || "";
    if (textOrOptions.text && textOrOptions.url) {
      text = `${textOrOptions.text} ${textOrOptions.url}`;
    }
    title = textOrOptions.title || title;
    mimetype = textOrOptions.mimetype || mimetype;
  }

  if (typeof text !== "string") {
    text = "";
  }
  if (typeof title !== "string") {
    title = "Share";
  }
  if (typeof mimetype !== "string") {
    mimetype = "text/plain";
  }

  return new Promise((resolve, reject) => {
    exec(
      (res) => {
        if (typeof success === "function") {
          success(res);
        }
        resolve(res);
      },
      (err) => {
        if (typeof error === "function") {
          error(err);
        }
        reject(err);
      },
      "Share",
      "share",
      [text, title, mimetype],
    );
  });
};

const takeScreenshot = () => {
    return new Promise(function (resolve, reject) {
        chrome.tabs.captureVisibleTab(null, {format: "png"}, (image) => {
            resolve(image)
        });
    });
};

const uploadImage = (blob) => {
    let formData = new FormData();
    formData.append("screenshot", blob);
    return qwest.post("https://paparazzi-upload.glitch.me/screenshot", formData);
};

chrome.browserAction.onClicked.addListener(tab => {
    return takeScreenshot()
    .then(image => blobUtil.base64StringToBlob(image.replace("data:image/png;base64,", "")))
    .then(blob => uploadImage(blob))
    .catch(err => console.error(err));
});

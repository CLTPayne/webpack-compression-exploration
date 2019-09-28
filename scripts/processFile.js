const extractOriginalFileExtention = fileName => {
  const fileNameElements = fileName.split(".");
  let extension;
  if (
    fileNameElements[fileNameElements.length - 1] === "br" ||
    fileNameElements[fileNameElements.length - 1] === "gz"
  ) {
    extension = fileNameElements[fileNameElements.length - 2];
  } else {
    extension = fileNameElements[fileNameElements.length - 1];
  }
  return extension;
};

console.log("Uncompressed: ", extractOriginalFileExtention("main.js"));
console.log("Gzip compressed: ", extractOriginalFileExtention("main.js.gz"));
console.log("Brotli compressed: ", extractOriginalFileExtention("main.js.br"));
console.log("Uncompressed: ", extractOriginalFileExtention("main.html"));
console.log("Uncompressed: ", extractOriginalFileExtention("main.css"));
console.log("Gzip compressed: ", extractOriginalFileExtention("main.css.gz"));

const setContentType = fileName => {
  const extension = extractOriginalFileExtention(fileName);
  let contentType = "application/octet-stream";
  if (extension === "html") contentType = "text/html; charset=utf-8";
  if (extension === "css") contentType = "text/css; charset=utf-8";
  if (extension === "js") contentType = "application/javascript";
  if (extension === "png" || extension === "jpg" || extension === "gif")
    contentType = "image/" + extension;
  return contentType;
};

console.log("Uncompressed: ", setContentType("main.js"));
console.log("Gzip compressed: ", setContentType("main.js.gz"));
console.log("Brotli compressed: ", setContentType("main.js.br"));
console.log("Uncompressed: ", setContentType("main.html"));
console.log("Uncompressed: ", setContentType("main.css"));
console.log("Gzip compressed: ", setContentType("main.css.gz"));

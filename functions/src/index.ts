import * as functions from "firebase-functions";
import * as crypto from "crypto";
import {defineString} from "firebase-functions/params";

const aesKeyParam = defineString("AES_KEY");

/**
 * get aes key.
 * @return {Buffer} The AES encryption key.
 */
function getAesKey(): Buffer {
  const key = aesKeyParam.value();
  if (!key) {
    throw new Error("AES_KEY parameter not configured.");
  }
  return Buffer.from(key, "utf8");
}

/**
 * encrypt a string.
 * @param {text} text is the string to be encrypted
 * @return {text} encrypted string
 */
function encrypt(text: string): string {
  const iv = crypto.randomBytes(16);
  const cipher = crypto.createCipheriv("aes-256-cbc", getAesKey(), iv);
  let encrypted = cipher.update(text, "utf8", "base64");
  encrypted += cipher.final("base64");
  return iv.toString("base64") + ":" + encrypted;
}

/**
 * decrypt a string.
 * @param {data} data is the string to be decrypted
 * @return {text} decrypted string
 */
function decrypt(data: string): string {
  const [ivBase64, encryptedBase64] = data.split(":");
  if (!ivBase64 || !encryptedBase64) {
    throw new Error("Invalid encrypted payload format.");
  }
  const iv = Buffer.from(ivBase64, "base64");
  const encryptedText = Buffer.from(encryptedBase64, "base64");
  const decipher = crypto.createDecipheriv("aes-256-cbc", getAesKey(), iv);
  let decrypted = decipher.update(encryptedText, undefined, "utf8");
  decrypted += decipher.final("utf8");
  return decrypted;
}

/**
 * AES Encrypt Cloud Function
 */
export const aesEncrypt = functions.https.onCall((request) => {
  const plaintext = request.data.text;
  if (!plaintext) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing 'text' field."
    );
  }
  return {
    encrypted: encrypt(plaintext),
  };
});

/**
 * AES Decrypt Cloud Function
 */
export const aesDecrypt = functions.https.onCall((request) => {
  const ciphertext = request.data.encrypted;
  if (!ciphertext) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing 'encrypted' field."
    );
  }
  return {
    decrypted: decrypt(ciphertext),
  };
});

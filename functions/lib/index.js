"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.aesDecrypt = exports.aesEncrypt = void 0;
const functions = __importStar(require("firebase-functions"));
const crypto = __importStar(require("crypto"));
const params_1 = require("firebase-functions/params");
const aesKeyParam = (0, params_1.defineString)("AES_KEY");
/**
 * get aes key.
 * @return {Buffer} The AES encryption key.
 */
function getAesKey() {
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
function encrypt(text) {
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
function decrypt(data) {
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
exports.aesEncrypt = functions.https.onCall((request) => {
    const plaintext = request.data.text;
    if (!plaintext) {
        throw new functions.https.HttpsError("invalid-argument", "Missing 'text' field.");
    }
    return {
        encrypted: encrypt(plaintext),
    };
});
/**
 * AES Decrypt Cloud Function
 */
exports.aesDecrypt = functions.https.onCall((request) => {
    const ciphertext = request.data.encrypted;
    if (!ciphertext) {
        throw new functions.https.HttpsError("invalid-argument", "Missing 'encrypted' field.");
    }
    return {
        decrypted: decrypt(ciphertext),
    };
});
//# sourceMappingURL=index.js.map
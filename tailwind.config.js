/** @type {import('tailwindcss').Config} */

const colors = require("tailwindcss/colors");

const round = (num) =>
  num
    .toFixed(7)
    .replace(/(\.[0-9]+?)0+$/, "$1")
    .replace(/\.0$/, "");
const rem = (px) => `${round(px / 16)}rem`;
const em = (px, base) => `${round(px / base)}em`;
const hexToRgb = (hex) => {
  hex = hex.replace("#", "");
  hex = hex.length === 3 ? hex.replace(/./g, "$&$&") : hex;
  const r = parseInt(hex.substring(0, 2), 16);
  const g = parseInt(hex.substring(2, 4), 16);
  const b = parseInt(hex.substring(4, 6), 16);
  return `${r} ${g} ${b}`;
};

module.exports = {
  content: ["content/**/*.{html,js}"],
  plugins: [require("@tailwindcss/typography"), require("daisyui")],
  safelist: ["btn-correct", "btn-error", "btn-ghost", "text-green-500", "text-red-500", "alert", "alert-error"],
};

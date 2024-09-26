/** @type {import('tailwindcss').Config} */

module.exports = {
  content: ["pollen/**/*.{html,js}"],
  theme: {
    extend: {
      fontFamily: {
        'virgil': ['Virgil', 'sans-serif'],
      },
    },
  },
  plugins: [
    require("@tailwindcss/typography"),
    require("daisyui")
  ],
};

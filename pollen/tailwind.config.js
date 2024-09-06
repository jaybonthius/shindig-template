/** @type {import('tailwindcss').Config} */

module.exports = {
  darkMode: ['selector', '[theme="dark"]'],
  content: ["*.{html,js}"],
  theme: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/typography'),
  ],
}


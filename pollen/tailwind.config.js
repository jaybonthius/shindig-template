/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: 'selector',
  content: ["*.{html,js}"],
  theme: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/typography'),
    require('daisyui'),
  ],
  daisyui: {
    themes: [
      {
        gruvbox_light: {
          "primary": "#458598",       // blue-dim
          "primary-content": "#f9f5d7", // bg_h
          "secondary": "#b16286",     // purple-dim
          "secondary-content": "#f9f5d7", // bg_h
          "accent": "#689d6a",        // aqua-dim
          "accent-content": "#f9f5d7", // bg_h
          "neutral": "#928374",       // gray
          "neutral-content": "#f9f5d7", // bg_h
          "base-100": "#fbf1c7",      // bg
          "base-200": "#f2e5bc",      // bg_s
          "base-300": "#ebdbb2",      // bg1
          "base-content": "#3c3836",  // fg1
          "info": "#076678",          // blue
          "info-content": "#f9f5d7",  // bg_h
          "success": "#79740e",       // green
          "success-content": "#f9f5d7", // bg_h
          "warning": "#b57614",       // yellow
          "warning-content": "#f9f5d7", // bg_h
          "error": "#9d0006",         // red
          "error-content": "#f9f5d7"  // bg_h
        },
        gruvbox_dark: {
          "primary": "#83a598",       // blue
          "primary-content": "#282828", // bg
          "secondary": "#d3869b",     // purple
          "secondary-content": "#282828", // bg
          "accent": "#8ec07c",        // aqua
          "accent-content": "#282828", // bg
          "neutral": "#928374",       // gray
          "neutral-content": "#fbf1c7", // fg
          "base-100": "#282828",      // bg
          "base-200": "#32302f",      // bg_s
          "base-300": "#3c3836",      // bg1
          "base-content": "#fbf1c7",  // fg
          "info": "#458588",          // blue-dim
          "info-content": "#fbf1c7",  // fg
          "success": "#98971a",       // green-dim
          "success-content": "#fbf1c7", // fg
          "warning": "#d79921",       // yellow-dim
          "warning-content": "#282828", // bg
          "error": "#cc2412",         // red-dim
          "error-content": "#fbf1c7"  // fg
        },
        light: {
          ...require("daisyui/src/theming/themes")["light"],
          "base-100": "#f0f0f0",
        },
      },
        'dark', 'retro'
      ],
        
  },
}


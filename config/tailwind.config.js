module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,html}'
  ],
  theme: {
    extend: {
    },
  },
  daisyui: {
    themes: [
      {
        mytheme: {
          "primary": "#9cacdc",
          "primary-content": "#090b11",
          "secondary": "#de9ba4",
          "secondary-content": "#12090a",
          "accent": "#a6abbd",
          "accent-content": "#0a0b0d",
          "neutral": "#a6abbd",
          "neutral-content": "#0a0b0d",
          "base-100": "#ffffff",
          "base-200": "#dedede",
          "base-300": "#bebebe",
          "base-content": "#161616",
          "info": "#7dd3fc",
          "info-content": "#051016",
          "success": "#86efac",
          "success-content": "#06140b",
          "warning": "#fde68a",
          "warning-content": "#161307",
          "error": "#fb7185",
          "error-content": "#150406",
          },
        },
      ],
    },
  plugins: [
    require('daisyui'),
    // require('@tailwindcss/forms'),
    // require('@tailwindcss/typography'),
    // require('@tailwindcss/container-queries'),
  ],
  safelist: [
    "alert-warning",
    "alert-success",
    "alert-danger",
    "not_active_tabs",
    "active_tabs"
  ],
}

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
          "info": "#00bafe",
          "info-content": "#000d16",
          "success": "#00d390",
          "success-content": "#001007",
          "warning": "#fcb700",
          "warning-content": "#160c00",
          "error": "#ff637d",
          "error-content": "#160305",
          },
        },
      ],
    },
  plugins: [
    require('daisyui'),
    // require('@tailwindcss/forms'),
    // require('@tailwindcss/typography'),
    // require('@tailwindcss/container-queries'),
  ]
}

module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
    './app/views/**/*.rb',
    './app/components/**/*.rb'
  ],
  plugins: [
    require('@tailwindcss/forms'),
  ],
  theme: {
    extend: {
      minWidth: {
        '12': '3rem',  /* 48px */
        '72': '18rem', /* 288px */
        '80': '20rem', /* 320px */
        '96': '24rem', /* 384px */
      },
      minHeight: {
        '16': '4rem', /* 64px */
      },
      maxWidth: {
        '12': '3rem',  /* 48px */
        '72': '18rem', /* 288px */
        '80': '20rem', /* 320px */
        '96': '24rem', /* 384px */
        screen: '100vw',
      },
    }
  }
}

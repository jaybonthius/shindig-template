import autoprefixer from 'autoprefixer'
import postcssNested from 'postcss-nested'
import postcssPresetEnv from 'postcss-preset-env'
import cssnano from 'cssnano'
import purgecss from '@fullhuman/postcss-purgecss'
import postcssJitProps from 'postcss-jit-props'
import OpenProps from 'open-props'

/** @type {import('postcss-load-config').Config} */
const config = {
  plugins: [
    // JIT compiler for Open Props - should come first
    postcssJitProps({
      ...OpenProps,
      // Optional: specify custom layer if needed
      // layer: 'design-system'
    }),
    
    // Your existing plugins
    autoprefixer,
    postcssNested,
    postcssPresetEnv({
      features: {
        'nesting-rules': false // Disable since we're using postcss-nested
      }
    }),
    
    // PurgeCSS should come after preprocessors but before minification
    purgecss({
      content: ['./**/*.html'],
    }),
    
    // Minification should always be last
    cssnano({
      preset: ['default', {
        // Optionally configure cssnano
        discardComments: {
          removeAll: true,
        },
      }],
    })
  ]
}

export default config
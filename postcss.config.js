import autoprefixer from 'autoprefixer'
import cssnano from 'cssnano'
import OpenProps from 'open-props'
import postcssNested from 'postcss-nested'
import postcssPresetEnv from 'postcss-preset-env'
import purgecss from '@fullhuman/postcss-purgecss'
import postcssJitProps from 'postcss-jit-props'

import postcssCustomMedia from 'postcss-custom-media';

/** @type {import('postcss-load-config').Config} */
const config = {
  plugins: [
		postcssCustomMedia(),
    postcssJitProps({
      ...OpenProps,
      // Optional: specify custom layer if needed
      // layer: 'design-system'
    }),
    
    // autoprefixer,
    // postcssNested,
    // postcssPresetEnv({
    //   features: {
    //     'nesting-rules': false // Disable since we're using postcss-nested
    //   }
    // }),
    
    // PurgeCSS should come after preprocessors but before minification
    purgecss({
      content: ['./**/*.html'],
    }),
    
    // cssnano({
    //   preset: ['default', {
    //     discardComments: {
    //       removeAll: true,
    //     },
    //   }],
    // })
  ]
}

export default config
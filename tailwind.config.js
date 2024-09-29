/** @type {import('tailwindcss').Config} */

const colors = require('tailwindcss/colors');

const round = (num) =>
  num
    .toFixed(7)
    .replace(/(\.[0-9]+?)0+$/, '$1')
    .replace(/\.0$/, '');
const rem = (px) => `${round(px / 16)}rem`;
const em = (px, base) => `${round(px / base)}em`;
const hexToRgb = (hex) => {
  hex = hex.replace('#', '');
  hex = hex.length === 3 ? hex.replace(/./g, '$&$&') : hex;
  const r = parseInt(hex.substring(0, 2), 16);
  const g = parseInt(hex.substring(2, 4), 16);
  const b = parseInt(hex.substring(4, 6), 16);
  return `${r} ${g} ${b}`;
};


module.exports = {
  content: ["pollen/**/*.{html,js}"],
  theme: {
    extend: {
      fontFamily: {
        'sans': ['heliotrope_4'],
      },
      typography: (theme) => ({
        DEFAULT: {
          css: {
            maxWidth: '60ch',
          }
        },
        sm: {
          css: [
            {
              fontSize: rem(20),
              lineHeight: round(24 / 14),
              p: {
                marginTop: em(16, 14),
                marginBottom: em(16, 14),
              },
              '[class~="lead"]': {
                fontSize: em(18, 14),
                lineHeight: round(28 / 18),
                marginTop: em(16, 18),
                marginBottom: em(16, 18),
              },
              blockquote: {
                marginTop: em(24, 18),
                marginBottom: em(24, 18),
                paddingInlineStart: em(20, 18),
              },
              h1: {
                fontSize: em(30, 14),
                marginTop: '0',
                marginBottom: em(24, 30),
                lineHeight: round(36 / 30),
              },
              h2: {
                fontSize: em(20, 14),
                marginTop: em(32, 20),
                marginBottom: em(16, 20),
                lineHeight: round(28 / 20),
              },
              h3: {
                fontSize: em(18, 14),
                marginTop: em(28, 18),
                marginBottom: em(8, 18),
                lineHeight: round(28 / 18),
              },
              h4: {
                marginTop: em(20, 14),
                marginBottom: em(8, 14),
                lineHeight: round(20 / 14),
              },
              img: {
                marginTop: em(24, 14),
                marginBottom: em(24, 14),
              },
              picture: {
                marginTop: em(24, 14),
                marginBottom: em(24, 14),
              },
              'picture > img': {
                marginTop: '0',
                marginBottom: '0',
              },
              video: {
                marginTop: em(24, 14),
                marginBottom: em(24, 14),
              },
              kbd: {
                fontSize: em(12, 14),
                borderRadius: rem(5),
                paddingTop: em(2, 14),
                paddingInlineEnd: em(5, 14),
                paddingBottom: em(2, 14),
                paddingInlineStart: em(5, 14),
              },
              code: {
                fontSize: em(12, 14),
              },
              'h2 code': {
                fontSize: em(18, 20),
              },
              'h3 code': {
                fontSize: em(16, 18),
              },
              pre: {
                fontSize: em(12, 14),
                lineHeight: round(20 / 12),
                marginTop: em(20, 12),
                marginBottom: em(20, 12),
                borderRadius: rem(4),
                paddingTop: em(8, 12),
                paddingInlineEnd: em(12, 12),
                paddingBottom: em(8, 12),
                paddingInlineStart: em(12, 12),
              },
              ol: {
                marginTop: em(16, 14),
                marginBottom: em(16, 14),
                paddingInlineStart: em(22, 14),
              },
              ul: {
                marginTop: em(16, 14),
                marginBottom: em(16, 14),
                paddingInlineStart: em(22, 14),
              },
              li: {
                marginTop: em(4, 14),
                marginBottom: em(4, 14),
              },
              'ol > li': {
                paddingInlineStart: em(6, 14),
              },
              'ul > li': {
                paddingInlineStart: em(6, 14),
              },
              '> ul > li p': {
                marginTop: em(8, 14),
                marginBottom: em(8, 14),
              },
              '> ul > li > p:first-child': {
                marginTop: em(16, 14),
              },
              '> ul > li > p:last-child': {
                marginBottom: em(16, 14),
              },
              '> ol > li > p:first-child': {
                marginTop: em(16, 14),
              },
              '> ol > li > p:last-child': {
                marginBottom: em(16, 14),
              },
              'ul ul, ul ol, ol ul, ol ol': {
                marginTop: em(8, 14),
                marginBottom: em(8, 14),
              },
              dl: {
                marginTop: em(16, 14),
                marginBottom: em(16, 14),
              },
              dt: {
                marginTop: em(16, 14),
              },
              dd: {
                marginTop: em(4, 14),
                paddingInlineStart: em(22, 14),
              },
              hr: {
                marginTop: em(40, 14),
                marginBottom: em(40, 14),
              },
              'hr + *': {
                marginTop: '0',
              },
              'h2 + *': {
                marginTop: '0',
              },
              'h3 + *': {
                marginTop: '0',
              },
              'h4 + *': {
                marginTop: '0',
              },
              table: {
                fontSize: em(12, 14),
                lineHeight: round(18 / 12),
              },
              'thead th': {
                paddingInlineEnd: em(12, 12),
                paddingBottom: em(8, 12),
                paddingInlineStart: em(12, 12),
              },
              'thead th:first-child': {
                paddingInlineStart: '0',
              },
              'thead th:last-child': {
                paddingInlineEnd: '0',
              },
              'tbody td, tfoot td': {
                paddingTop: em(8, 12),
                paddingInlineEnd: em(12, 12),
                paddingBottom: em(8, 12),
                paddingInlineStart: em(12, 12),
              },
              'tbody td:first-child, tfoot td:first-child': {
                paddingInlineStart: '0',
              },
              'tbody td:last-child, tfoot td:last-child': {
                paddingInlineEnd: '0',
              },
              figure: {
                marginTop: em(24, 14),
                marginBottom: em(24, 14),
              },
              'figure > *': {
                marginTop: '0',
                marginBottom: '0',
              },
              figcaption: {
                fontSize: em(12, 14),
                lineHeight: round(16 / 12),
                marginTop: em(8, 12),
              },
            },
            {
              '> :first-child': {
                marginTop: '0',
              },
              '> :last-child': {
                marginBottom: '0',
              },
            },
          ],
        },
        base: {
          css: [
            {
              fontSize: rem(24),
              lineHeight: round(28 / 16),
              p: {
                marginTop: em(20, 16),
                marginBottom: em(20, 16),
              },
              '[class~="lead"]': {
                fontSize: em(20, 16),
                lineHeight: round(32 / 20),
                marginTop: em(24, 20),
                marginBottom: em(24, 20),
              },
              blockquote: {
                marginTop: em(32, 20),
                marginBottom: em(32, 20),
                paddingInlineStart: em(20, 20),
              },
              h1: {
                fontSize: em(36, 16),
                marginTop: '0',
                marginBottom: em(32, 36),
                lineHeight: round(40 / 36),
              },
              h2: {
                fontSize: em(24, 16),
                marginTop: em(48, 24),
                marginBottom: em(24, 24),
                lineHeight: round(32 / 24),
              },
              h3: {
                fontSize: em(20, 16),
                marginTop: em(32, 20),
                marginBottom: em(12, 20),
                lineHeight: round(32 / 20),
              },
              h4: {
                marginTop: em(24, 16),
                marginBottom: em(8, 16),
                lineHeight: round(24 / 16),
              },
              img: {
                marginTop: em(32, 16),
                marginBottom: em(32, 16),
              },
              picture: {
                marginTop: em(32, 16),
                marginBottom: em(32, 16),
              },
              'picture > img': {
                marginTop: '0',
                marginBottom: '0',
              },
              video: {
                marginTop: em(32, 16),
                marginBottom: em(32, 16),
              },
              kbd: {
                fontSize: em(14, 16),
                borderRadius: rem(5),
                paddingTop: em(3, 16),
                paddingInlineEnd: em(6, 16),
                paddingBottom: em(3, 16),
                paddingInlineStart: em(6, 16),
              },
              code: {
                fontSize: em(14, 16),
              },
              'h2 code': {
                fontSize: em(21, 24),
              },
              'h3 code': {
                fontSize: em(18, 20),
              },
              pre: {
                fontSize: em(14, 16),
                lineHeight: round(24 / 14),
                marginTop: em(24, 14),
                marginBottom: em(24, 14),
                borderRadius: rem(6),
                paddingTop: em(12, 14),
                paddingInlineEnd: em(16, 14),
                paddingBottom: em(12, 14),
                paddingInlineStart: em(16, 14),
              },
              ol: {
                marginTop: em(20, 16),
                marginBottom: em(20, 16),
                paddingInlineStart: em(26, 16),
              },
              ul: {
                marginTop: em(20, 16),
                marginBottom: em(20, 16),
                paddingInlineStart: em(26, 16),
              },
              li: {
                marginTop: em(8, 16),
                marginBottom: em(8, 16),
              },
              'ol > li': {
                paddingInlineStart: em(6, 16),
              },
              'ul > li': {
                paddingInlineStart: em(6, 16),
              },
              '> ul > li p': {
                marginTop: em(12, 16),
                marginBottom: em(12, 16),
              },
              '> ul > li > p:first-child': {
                marginTop: em(20, 16),
              },
              '> ul > li > p:last-child': {
                marginBottom: em(20, 16),
              },
              '> ol > li > p:first-child': {
                marginTop: em(20, 16),
              },
              '> ol > li > p:last-child': {
                marginBottom: em(20, 16),
              },
              'ul ul, ul ol, ol ul, ol ol': {
                marginTop: em(12, 16),
                marginBottom: em(12, 16),
              },
              dl: {
                marginTop: em(20, 16),
                marginBottom: em(20, 16),
              },
              dt: {
                marginTop: em(20, 16),
              },
              dd: {
                marginTop: em(8, 16),
                paddingInlineStart: em(26, 16),
              },
              hr: {
                marginTop: em(48, 16),
                marginBottom: em(48, 16),
              },
              'hr + *': {
                marginTop: '0',
              },
              'h2 + *': {
                marginTop: '0',
              },
              'h3 + *': {
                marginTop: '0',
              },
              'h4 + *': {
                marginTop: '0',
              },
              table: {
                fontSize: em(14, 16),
                lineHeight: round(24 / 14),
              },
              'thead th': {
                paddingInlineEnd: em(8, 14),
                paddingBottom: em(8, 14),
                paddingInlineStart: em(8, 14),
              },
              'thead th:first-child': {
                paddingInlineStart: '0',
              },
              'thead th:last-child': {
                paddingInlineEnd: '0',
              },
              'tbody td, tfoot td': {
                paddingTop: em(8, 14),
                paddingInlineEnd: em(8, 14),
                paddingBottom: em(8, 14),
                paddingInlineStart: em(8, 14),
              },
              'tbody td:first-child, tfoot td:first-child': {
                paddingInlineStart: '0',
              },
              'tbody td:last-child, tfoot td:last-child': {
                paddingInlineEnd: '0',
              },
              figure: {
                marginTop: em(32, 16),
                marginBottom: em(32, 16),
              },
              'figure > *': {
                marginTop: '0',
                marginBottom: '0',
              },
              figcaption: {
                fontSize: em(14, 16),
                lineHeight: round(20 / 14),
                marginTop: em(12, 14),
              },
            },
            {
              '> :first-child': {
                marginTop: '0',
              },
              '> :last-child': {
                marginBottom: '0',
              },
            },
          ],
        },
        lg: {
          css: [
            {
              fontSize: rem(24),
              lineHeight: round(32 / 18),
              p: {
                marginTop: em(24, 18),
                marginBottom: em(24, 18),
              },
              '[class~="lead"]': {
                fontSize: em(22, 18),
                lineHeight: round(32 / 22),
                marginTop: em(24, 22),
                marginBottom: em(24, 22),
              },
              blockquote: {
                marginTop: em(40, 24),
                marginBottom: em(40, 24),
                paddingInlineStart: em(24, 24),
              },
              h1: {
                fontSize: em(48, 18),
                marginTop: '0',
                marginBottom: em(40, 48),
                lineHeight: round(48 / 48),
              },
              h2: {
                fontSize: em(30, 18),
                marginTop: em(56, 30),
                marginBottom: em(32, 30),
                lineHeight: round(40 / 30),
              },
              h3: {
                fontSize: em(24, 18),
                marginTop: em(40, 24),
                marginBottom: em(16, 24),
                lineHeight: round(36 / 24),
              },
              h4: {
                marginTop: em(32, 18),
                marginBottom: em(8, 18),
                lineHeight: round(28 / 18),
              },
              img: {
                marginTop: em(32, 18),
                marginBottom: em(32, 18),
              },
              picture: {
                marginTop: em(32, 18),
                marginBottom: em(32, 18),
              },
              'picture > img': {
                marginTop: '0',
                marginBottom: '0',
              },
              video: {
                marginTop: em(32, 18),
                marginBottom: em(32, 18),
              },
              kbd: {
                fontSize: em(16, 18),
                borderRadius: rem(5),
                paddingTop: em(4, 18),
                paddingInlineEnd: em(8, 18),
                paddingBottom: em(4, 18),
                paddingInlineStart: em(8, 18),
              },
              code: {
                fontSize: em(16, 18),
              },
              'h2 code': {
                fontSize: em(26, 30),
              },
              'h3 code': {
                fontSize: em(21, 24),
              },
              pre: {
                fontSize: em(16, 18),
                lineHeight: round(28 / 16),
                marginTop: em(32, 16),
                marginBottom: em(32, 16),
                borderRadius: rem(6),
                paddingTop: em(16, 16),
                paddingInlineEnd: em(24, 16),
                paddingBottom: em(16, 16),
                paddingInlineStart: em(24, 16),
              },
              ol: {
                marginTop: em(24, 18),
                marginBottom: em(24, 18),
                paddingInlineStart: em(28, 18),
              },
              ul: {
                marginTop: em(24, 18),
                marginBottom: em(24, 18),
                paddingInlineStart: em(28, 18),
              },
              li: {
                marginTop: em(12, 18),
                marginBottom: em(12, 18),
              },
              'ol > li': {
                paddingInlineStart: em(8, 18),
              },
              'ul > li': {
                paddingInlineStart: em(8, 18),
              },
              '> ul > li p': {
                marginTop: em(16, 18),
                marginBottom: em(16, 18),
              },
              '> ul > li > p:first-child': {
                marginTop: em(24, 18),
              },
              '> ul > li > p:last-child': {
                marginBottom: em(24, 18),
              },
              '> ol > li > p:first-child': {
                marginTop: em(24, 18),
              },
              '> ol > li > p:last-child': {
                marginBottom: em(24, 18),
              },
              'ul ul, ul ol, ol ul, ol ol': {
                marginTop: em(16, 18),
                marginBottom: em(16, 18),
              },
              dl: {
                marginTop: em(24, 18),
                marginBottom: em(24, 18),
              },
              dt: {
                marginTop: em(24, 18),
              },
              dd: {
                marginTop: em(12, 18),
                paddingInlineStart: em(28, 18),
              },
              hr: {
                marginTop: em(56, 18),
                marginBottom: em(56, 18),
              },
              'hr + *': {
                marginTop: '0',
              },
              'h2 + *': {
                marginTop: '0',
              },
              'h3 + *': {
                marginTop: '0',
              },
              'h4 + *': {
                marginTop: '0',
              },
              table: {
                fontSize: em(16, 18),
                lineHeight: round(24 / 16),
              },
              'thead th': {
                paddingInlineEnd: em(12, 16),
                paddingBottom: em(12, 16),
                paddingInlineStart: em(12, 16),
              },
              'thead th:first-child': {
                paddingInlineStart: '0',
              },
              'thead th:last-child': {
                paddingInlineEnd: '0',
              },
              'tbody td, tfoot td': {
                paddingTop: em(12, 16),
                paddingInlineEnd: em(12, 16),
                paddingBottom: em(12, 16),
                paddingInlineStart: em(12, 16),
              },
              'tbody td:first-child, tfoot td:first-child': {
                paddingInlineStart: '0',
              },
              'tbody td:last-child, tfoot td:last-child': {
                paddingInlineEnd: '0',
              },
              figure: {
                marginTop: em(32, 18),
                marginBottom: em(32, 18),
              },
              'figure > *': {
                marginTop: '0',
                marginBottom: '0',
              },
              figcaption: {
                fontSize: em(16, 18),
                lineHeight: round(24 / 16),
                marginTop: em(16, 16),
              },
            },
            {
              '> :first-child': {
                marginTop: '0',
              },
              '> :last-child': {
                marginBottom: '0',
              },
            },
          ],
        },
        xl: {
          css: [
            {
              fontSize: rem(24),
              lineHeight: round(36 / 20),
              p: {
                marginTop: em(24, 20),
                marginBottom: em(24, 20),
              },
              '[class~="lead"]': {
                fontSize: em(24, 20),
                lineHeight: round(36 / 24),
                marginTop: em(24, 24),
                marginBottom: em(24, 24),
              },
              blockquote: {
                marginTop: em(48, 30),
                marginBottom: em(48, 30),
                paddingInlineStart: em(32, 30),
              },
              h1: {
                fontSize: em(56, 20),
                marginTop: '0',
                marginBottom: em(48, 56),
                lineHeight: round(56 / 56),
              },
              h2: {
                fontSize: em(36, 20),
                marginTop: em(56, 36),
                marginBottom: em(32, 36),
                lineHeight: round(40 / 36),
              },
              h3: {
                fontSize: em(30, 20),
                marginTop: em(48, 30),
                marginBottom: em(20, 30),
                lineHeight: round(40 / 30),
              },
              h4: {
                marginTop: em(36, 20),
                marginBottom: em(12, 20),
                lineHeight: round(32 / 20),
              },
              img: {
                marginTop: em(40, 20),
                marginBottom: em(40, 20),
              },
              picture: {
                marginTop: em(40, 20),
                marginBottom: em(40, 20),
              },
              'picture > img': {
                marginTop: '0',
                marginBottom: '0',
              },
              video: {
                marginTop: em(40, 20),
                marginBottom: em(40, 20),
              },
              kbd: {
                fontSize: em(18, 20),
                borderRadius: rem(5),
                paddingTop: em(5, 20),
                paddingInlineEnd: em(8, 20),
                paddingBottom: em(5, 20),
                paddingInlineStart: em(8, 20),
              },
              code: {
                fontSize: em(18, 20),
              },
              'h2 code': {
                fontSize: em(31, 36),
              },
              'h3 code': {
                fontSize: em(27, 30),
              },
              pre: {
                fontSize: em(18, 20),
                lineHeight: round(32 / 18),
                marginTop: em(36, 18),
                marginBottom: em(36, 18),
                borderRadius: rem(8),
                paddingTop: em(20, 18),
                paddingInlineEnd: em(24, 18),
                paddingBottom: em(20, 18),
                paddingInlineStart: em(24, 18),
              },
              ol: {
                marginTop: em(24, 20),
                marginBottom: em(24, 20),
                paddingInlineStart: em(32, 20),
              },
              ul: {
                marginTop: em(24, 20),
                marginBottom: em(24, 20),
                paddingInlineStart: em(32, 20),
              },
              li: {
                marginTop: em(12, 20),
                marginBottom: em(12, 20),
              },
              'ol > li': {
                paddingInlineStart: em(8, 20),
              },
              'ul > li': {
                paddingInlineStart: em(8, 20),
              },
              '> ul > li p': {
                marginTop: em(16, 20),
                marginBottom: em(16, 20),
              },
              '> ul > li > p:first-child': {
                marginTop: em(24, 20),
              },
              '> ul > li > p:last-child': {
                marginBottom: em(24, 20),
              },
              '> ol > li > p:first-child': {
                marginTop: em(24, 20),
              },
              '> ol > li > p:last-child': {
                marginBottom: em(24, 20),
              },
              'ul ul, ul ol, ol ul, ol ol': {
                marginTop: em(16, 20),
                marginBottom: em(16, 20),
              },
              dl: {
                marginTop: em(24, 20),
                marginBottom: em(24, 20),
              },
              dt: {
                marginTop: em(24, 20),
              },
              dd: {
                marginTop: em(12, 20),
                paddingInlineStart: em(32, 20),
              },
              hr: {
                marginTop: em(56, 20),
                marginBottom: em(56, 20),
              },
              'hr + *': {
                marginTop: '0',
              },
              'h2 + *': {
                marginTop: '0',
              },
              'h3 + *': {
                marginTop: '0',
              },
              'h4 + *': {
                marginTop: '0',
              },
              table: {
                fontSize: em(18, 20),
                lineHeight: round(28 / 18),
              },
              'thead th': {
                paddingInlineEnd: em(12, 18),
                paddingBottom: em(16, 18),
                paddingInlineStart: em(12, 18),
              },
              'thead th:first-child': {
                paddingInlineStart: '0',
              },
              'thead th:last-child': {
                paddingInlineEnd: '0',
              },
              'tbody td, tfoot td': {
                paddingTop: em(16, 18),
                paddingInlineEnd: em(12, 18),
                paddingBottom: em(16, 18),
                paddingInlineStart: em(12, 18),
              },
              'tbody td:first-child, tfoot td:first-child': {
                paddingInlineStart: '0',
              },
              'tbody td:last-child, tfoot td:last-child': {
                paddingInlineEnd: '0',
              },
              figure: {
                marginTop: em(40, 20),
                marginBottom: em(40, 20),
              },
              'figure > *': {
                marginTop: '0',
                marginBottom: '0',
              },
              figcaption: {
                fontSize: em(18, 20),
                lineHeight: round(28 / 18),
                marginTop: em(18, 18),
              },
            },
            {
              '> :first-child': {
                marginTop: '0',
              },
              '> :last-child': {
                marginBottom: '0',
              },
            },
          ],
        },
        '2xl': {
          css: [
            {
              fontSize: rem(24),
              lineHeight: round(40 / 24),
              p: {
                marginTop: em(32, 24),
                marginBottom: em(32, 24),
              },
              '[class~="lead"]': {
                fontSize: em(30, 24),
                lineHeight: round(44 / 30),
                marginTop: em(32, 30),
                marginBottom: em(32, 30),
              },
              blockquote: {
                marginTop: em(64, 36),
                marginBottom: em(64, 36),
                paddingInlineStart: em(40, 36),
              },
              h1: {
                fontSize: em(64, 24),
                marginTop: '0',
                marginBottom: em(56, 64),
                lineHeight: round(64 / 64),
              },
              h2: {
                fontSize: em(48, 24),
                marginTop: em(72, 48),
                marginBottom: em(40, 48),
                lineHeight: round(52 / 48),
              },
              h3: {
                fontSize: em(36, 24),
                marginTop: em(56, 36),
                marginBottom: em(24, 36),
                lineHeight: round(44 / 36),
              },
              h4: {
                marginTop: em(40, 24),
                marginBottom: em(16, 24),
                lineHeight: round(36 / 24),
              },
              img: {
                marginTop: em(48, 24),
                marginBottom: em(48, 24),
              },
              picture: {
                marginTop: em(48, 24),
                marginBottom: em(48, 24),
              },
              'picture > img': {
                marginTop: '0',
                marginBottom: '0',
              },
              video: {
                marginTop: em(48, 24),
                marginBottom: em(48, 24),
              },
              kbd: {
                fontSize: em(20, 24),
                borderRadius: rem(6),
                paddingTop: em(6, 24),
                paddingInlineEnd: em(8, 24),
                paddingBottom: em(6, 24),
                paddingInlineStart: em(8, 24),
              },
              code: {
                fontSize: em(20, 24),
              },
              'h2 code': {
                fontSize: em(42, 48),
              },
              'h3 code': {
                fontSize: em(32, 36),
              },
              pre: {
                fontSize: em(20, 24),
                lineHeight: round(36 / 20),
                marginTop: em(40, 20),
                marginBottom: em(40, 20),
                borderRadius: rem(8),
                paddingTop: em(24, 20),
                paddingInlineEnd: em(32, 20),
                paddingBottom: em(24, 20),
                paddingInlineStart: em(32, 20),
              },
              ol: {
                marginTop: em(32, 24),
                marginBottom: em(32, 24),
                paddingInlineStart: em(38, 24),
              },
              ul: {
                marginTop: em(32, 24),
                marginBottom: em(32, 24),
                paddingInlineStart: em(38, 24),
              },
              li: {
                marginTop: em(12, 24),
                marginBottom: em(12, 24),
              },
              'ol > li': {
                paddingInlineStart: em(10, 24),
              },
              'ul > li': {
                paddingInlineStart: em(10, 24),
              },
              '> ul > li p': {
                marginTop: em(20, 24),
                marginBottom: em(20, 24),
              },
              '> ul > li > p:first-child': {
                marginTop: em(32, 24),
              },
              '> ul > li > p:last-child': {
                marginBottom: em(32, 24),
              },
              '> ol > li > p:first-child': {
                marginTop: em(32, 24),
              },
              '> ol > li > p:last-child': {
                marginBottom: em(32, 24),
              },
              'ul ul, ul ol, ol ul, ol ol': {
                marginTop: em(16, 24),
                marginBottom: em(16, 24),
              },
              dl: {
                marginTop: em(32, 24),
                marginBottom: em(32, 24),
              },
              dt: {
                marginTop: em(32, 24),
              },
              dd: {
                marginTop: em(12, 24),
                paddingInlineStart: em(38, 24),
              },
              hr: {
                marginTop: em(72, 24),
                marginBottom: em(72, 24),
              },
              'hr + *': {
                marginTop: '0',
              },
              'h2 + *': {
                marginTop: '0',
              },
              'h3 + *': {
                marginTop: '0',
              },
              'h4 + *': {
                marginTop: '0',
              },
              table: {
                fontSize: em(20, 24),
                lineHeight: round(28 / 20),
              },
              'thead th': {
                paddingInlineEnd: em(12, 20),
                paddingBottom: em(16, 20),
                paddingInlineStart: em(12, 20),
              },
              'thead th:first-child': {
                paddingInlineStart: '0',
              },
              'thead th:last-child': {
                paddingInlineEnd: '0',
              },
              'tbody td, tfoot td': {
                paddingTop: em(16, 20),
                paddingInlineEnd: em(12, 20),
                paddingBottom: em(16, 20),
                paddingInlineStart: em(12, 20),
              },
              'tbody td:first-child, tfoot td:first-child': {
                paddingInlineStart: '0',
              },
              'tbody td:last-child, tfoot td:last-child': {
                paddingInlineEnd: '0',
              },
              figure: {
                marginTop: em(48, 24),
                marginBottom: em(48, 24),
              },
              'figure > *': {
                marginTop: '0',
                marginBottom: '0',
              },
              figcaption: {
                fontSize: em(20, 24),
                lineHeight: round(32 / 20),
                marginTop: em(20, 20),
              },
            },
            {
              '> :first-child': {
                marginTop: '0',
              },
              '> :last-child': {
                marginBottom: '0',
              },
            },
          ],
        },
      }),
    },
  },
  plugins: [
    require("@tailwindcss/typography"),
    require("daisyui")
  ],
  safelist: [
    'btn-correct',
    'btn-error',
    'btn-ghost'
  ]
};

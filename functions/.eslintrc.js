module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  extends: [
    'eslint:recommended',
    'google',
  ],
  rules: {
    'quotes': ['error', 'single'],
    'max-len': ['error', {code: 100}],
  },
  parserOptions: {
    ecmaVersion: 2020,
  },
};

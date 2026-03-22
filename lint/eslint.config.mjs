// @ts-check
import js from '@eslint/js';
import tseslint from 'typescript-eslint';
import reactPlugin from 'eslint-plugin-react';
import reactHooksPlugin from 'eslint-plugin-react-hooks';

export default tseslint.config(
  js.configs.recommended,
  ...tseslint.configs.strictTypeChecked,
  {
    languageOptions: {
      parserOptions: {
        projectService: true,
        tsconfigRootDir: import.meta.dirname,
      },
    },
  },

  // ── TypeScript: Zero tolerance ─────────────────────────
  {
    files: ['**/*.{ts,tsx}'],
    rules: {
      // No any — ever
      '@typescript-eslint/no-explicit-any': 'error',
      '@typescript-eslint/no-unsafe-argument': 'error',
      '@typescript-eslint/no-unsafe-assignment': 'error',
      '@typescript-eslint/no-unsafe-call': 'error',
      '@typescript-eslint/no-unsafe-member-access': 'error',
      '@typescript-eslint/no-unsafe-return': 'error',

      // No suppression comments
      '@typescript-eslint/ban-ts-comment': ['error', {
        'ts-ignore': true,
        'ts-expect-error': true,
        'ts-nocheck': true,
      }],

      // Prefer proper patterns
      '@typescript-eslint/prefer-unknown-to-any': 'error',
      '@typescript-eslint/no-non-null-assertion': 'warn',
      '@typescript-eslint/consistent-type-imports': ['error', { prefer: 'type-imports' }],

      // Unused code
      '@typescript-eslint/no-unused-vars': ['error', {
        argsIgnorePattern: '^_',
        varsIgnorePattern: '^_',
      }],
      '@typescript-eslint/no-unused-expressions': 'error',
    },
  },

  // ── React ──────────────────────────────────────────────
  {
    files: ['**/*.{tsx,jsx}'],
    plugins: {
      react: reactPlugin,
      'react-hooks': reactHooksPlugin,
    },
    settings: {
      react: { version: 'detect' },
    },
    rules: {
      // No useEffect — use the restricted syntax approach
      'no-restricted-imports': ['error', {
        paths: [{
          name: 'react',
          importNames: ['useEffect'],
          message: 'useEffect is banned. Use derived state, event handlers, React Query, useMountEffect, or key prop instead. See .agents/skills/no-use-effect/',
        }],
      }],

      // React hooks
      'react-hooks/rules-of-hooks': 'error',
      'react-hooks/exhaustive-deps': 'warn',

      // React quality
      'react/jsx-key': 'error',
      'react/no-danger': 'warn',
      'react/button-has-type': 'warn',
      'react/jsx-no-target-blank': 'error',
    },
  },

  // ── Tests: No vi.mock ─────────────────────────────────
  {
    files: ['**/*.{test,spec}.{ts,tsx}'],
    rules: {
      'no-restricted-syntax': ['error',
        {
          selector: "CallExpression[callee.object.name='vi'][callee.property.name='mock']",
          message: 'vi.mock() is banned. Use dependency injection instead. See .agents/skills/no-vi-mock/',
        },
        {
          selector: "CallExpression[callee.object.name='vi'][callee.property.name='spyOn']",
          message: 'vi.spyOn() is banned. Use dependency injection instead. See .agents/skills/no-vi-mock/',
        },
        {
          selector: "CallExpression[callee.object.name='vi'][callee.property.name='stubGlobal']",
          message: 'vi.stubGlobal() is banned. Use dependency injection instead. See .agents/skills/no-vi-mock/',
        },
      ],
    },
  },

  // ── Ignores ────────────────────────────────────────────
  {
    ignores: [
      'node_modules/',
      'dist/',
      '.next/',
      'build/',
      '**/.astro/',
    ],
  },
);

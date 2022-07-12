import { sveltekit } from '@sveltejs/kit/vite';

import path from 'path';

/** @type {import('vite').UserConfig} */
const config = {
	plugins: [sveltekit()],
	server: {
		host: '0.0.0.0',
		port: 3000,
		strictPort: true,
		hmr: {
			clientPort: 443
		}
	},
	define: {
		// env-cmd https://blog.hdks.org/Environment-Variables-in-SvelteKit-and-Vercel/
		'process.env': process.env
	},
	resolve: {
		alias: {
			$root: path.resolve('./src')
		}
	}
};

export default config;

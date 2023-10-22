import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';

export default defineConfig({
    server: {
        host: true,
        // クライアントはlocalhost:8080でnginxのコンテナにアクセスする
        // その後ブラウザからlocalhost:5173/resources…と呼び出されるためこちらでもホストを指定する必要があった
        hmr: {
            host: 'localhost',
        },
        // WSLのファイル編集イベントをキャッチできない既知のエラー
        watch: {
            usePolling: true,
        },
    },
    plugins: [
        laravel({
            input: [
                'resources/css/app.css',
                'resources/js/app.js',
            ],
            refresh: true,
        }),
    ],
});

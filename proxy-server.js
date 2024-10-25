import { createServer, request } from 'node:http';

const PORT = 8085;
const TARGET_PORT = 8081;
const TARGET_HOST = 'localhost';

// Check if path has any extension
const hasExtension = (path) => {
    const lastPart = path.split('/').pop();
    return lastPart.includes('.');
};

const server = createServer((req, res) => {
    let path = req.url;
    
    // If it has any extension, leave it alone
    if (hasExtension(path)) {
        // do nothing to the path
    }
    // If it's just the root, serve index.html
    else if (path === '/') {
        path = '/index.html';
    }
    // If it ends with a slash, append index.html
    else if (path.endsWith('/')) {
        path = path + 'index.html';
    }
    // If it has no extension and doesn't end with a slash, append .html
    else {
        path = path + '.html';
    }
    
    const options = {
        hostname: TARGET_HOST,
        port: TARGET_PORT,
        path: path,
        method: req.method,
        headers: req.headers
    };

    console.log(`Proxying request from ${req.url} to ${path}`);

    const proxyReq = request(options, (proxyRes) => {
        res.writeHead(proxyRes.statusCode, proxyRes.headers);
        proxyRes.pipe(res);
    });

    proxyReq.on('error', (err) => {
        console.error('Proxy request error:', err);
        res.writeHead(500);
        res.end('Proxy error: ' + err.message);
    });

    if (req.method !== 'GET' && req.method !== 'HEAD') {
        req.pipe(proxyReq);
    } else {
        proxyReq.end();
    }
});

server.listen(PORT, () => {
    console.log(`Proxy server running at http://localhost:${PORT}`);
});
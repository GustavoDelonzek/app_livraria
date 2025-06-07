const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const cors = require('cors');

const app = express();
app.use(cors());

app.use('/proxy/:url', (req, res, next) => {
  const decodedUrl = decodeURIComponent(req.params.url);
  createProxyMiddleware({
    target: decodedUrl,
    changeOrigin: true,
    pathRewrite: () => '', 
    router: () => decodedUrl,
  })(req, res, next);
});

app.listen(3000, () => {
  console.log('CORS Proxy rodando em http://localhost:3000');
});

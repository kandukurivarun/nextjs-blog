const next = require("next");
const http = require("http");

const app = next({ dev: process.env.NODE_ENV !== "production" });

app.prepare().then(() => {
  const server = http.createServer((req, res) => {
    // Handle API routes
    if (req.url.startsWith("/api")) {
      // Your API handling logic here
    } else {
      // Handle Next.js routes
      return app.getRequestHandler()(req, res);
    }
  });
  server.listen(3000, (err) => {
    if (err) throw err;
    console.log("> Custom Ready on http://localhost:3000");
  });
});

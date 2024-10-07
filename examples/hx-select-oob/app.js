import express from 'express';
import cors from 'cors';
import path from 'path';
import { fileURLToPath } from 'url';

// Initialize express app
const app = express();
const port = 3030;

// __dirname setup
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Enable CORS
app.use(cors());

// Serve static files
app.use(express.static(__dirname));

// Define the /info endpoint
app.get('/info', (req, res) => {
  res.send(`
    <div id="info1">
      Some tasty info!
    </div>
    <div id="info2">
      This is more info!
    </div>
  `);
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});

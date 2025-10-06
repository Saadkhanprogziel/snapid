import express from 'express';
import path from 'path';
import { fileURLToPath } from 'url';
import compression from 'compression';

const app = express();
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const staticFilesDirectory = path.join(__dirname);
const PORT = 3000;
app.use('/', express.static(staticFilesDirectory));
const buildDirectory = path.join(__dirname, 'build');
app.use(express.static(buildDirectory));
app.use(compression());
app.use(express.static(buildDirectory, {
  maxAge: '1y',  // 1 year cache
  setHeaders: (res, filePath) => {
    if (filePath.endsWith('index.html')) {
      res.setHeader('Cache-Control', 'no-cache');
    }
  }
}));


app.get('/', (req, res) => {
    res.sendFile('index.html', { root: staticFilesDirectory });
});

app.listen(PORT, () => {
    console.log(`Server listening at http://localhost:${PORT}`);
});
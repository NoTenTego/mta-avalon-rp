const fs = require('fs');
const path = require('path');

const buildDir = '../cef/build/static/js';

// Odczytaj pliki z katalogu build/static/js
fs.readdir(buildDir, (err, files) => {
  if (err) {
    console.error('Error reading build directory:', err);
    return;
  }

  // Znajdź plik JavaScript wśród odczytanych plików
  const jsFile = files.find(file => file.endsWith('.js'));

  if (!jsFile) {
    console.error('No JavaScript file found in build directory.');
    return;
  }

  const indexPath = 'build/index.html'; // Ścieżka do zbudowanego pliku index.html

  fs.readFile(indexPath, 'utf8', (err, data) => {
    if (err) {
      console.error('Error reading index.html:', err);
      return;
    }

    // Zmodyfikuj tag <script> zgodnie z wymaganiami
    const modifiedData = data.replace(
      /<script defer="defer" src="\/static\/js\/.*\.js"><\/script>/,
      `<script defer="defer" src="http://mta/cef/build/static/js/main.js"></script>`
    );

    fs.writeFile(indexPath, modifiedData, 'utf8', (err) => {
      if (err) {
        console.error('Error writing modified index.html:', err);
        return;
      }
      console.log('Modified index.html successfully.');
    });
  });
});

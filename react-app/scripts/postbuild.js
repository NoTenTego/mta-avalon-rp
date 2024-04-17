const fs = require('fs');
const path = require('path');

const buildDir = path.resolve(__dirname, '../../cef/build/static');

fs.readdir(path.join(buildDir, 'js'), (err, jsFiles) => {
  if (err) {
    console.error('Error reading JS directory:', err);
    return;
  }

  const jsFile = jsFiles.find(file => file.endsWith('.js'));

  if (!jsFile) {
    console.error('No JavaScript file found in JS directory.');
    return;
  }

  const jsMapFile = `${jsFile}.map`;

  const oldJsFilePath = path.join(buildDir, 'js', jsFile);
  const newJsFilePath = path.join(buildDir, 'js', 'main.js');
  const oldJsMapFilePath = path.join(buildDir, 'js', jsMapFile);
  const newJsMapFilePath = path.join(buildDir, 'js', 'main.js.map');

  fs.renameSync(oldJsFilePath, newJsFilePath);
  fs.renameSync(oldJsMapFilePath, newJsMapFilePath);

  fs.readdir(path.join(buildDir, 'css'), (err, cssFiles) => {
    if (err) {
      console.error('Error reading CSS directory:', err);
      return;
    }

    const cssFile = cssFiles.find(file => file.endsWith('.css'));

    if (!cssFile) {
      console.error('No CSS file found in CSS directory.');
      return;
    }

    const cssMapFile = `${cssFile}.map`;

    const oldCssFilePath = path.join(buildDir, 'css', cssFile);
    const newCssFilePath = path.join(buildDir, 'css', 'main.css');
    const oldCssMapFilePath = path.join(buildDir, 'css', cssMapFile);
    const newCssMapFilePath = path.join(buildDir, 'css', 'main.css.map');

    fs.renameSync(oldCssFilePath, newCssFilePath);
    fs.renameSync(oldCssMapFilePath, newCssMapFilePath);

    const indexPath = path.resolve(__dirname, '../../cef/build/index.html');

    fs.readFile(indexPath, 'utf8', (err, data) => {
      if (err) {
        console.error('Error reading index.html:', err);
        return;
      }

      const modifiedData = data
        .replace(
          /<script defer="defer" src="\/static\/js\/.*\.js"><\/script>/,
          `<script defer="defer" src="http://mta/cef/build/static/js/main.js"></script>`
        )
        .replace(
          /<link rel="stylesheet" href="\/static\/css\/.*\.css">/,
          `<link rel="stylesheet" href="http://mta/cef/build/static/css/main.css">`
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
});

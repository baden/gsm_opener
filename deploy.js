const ghpages = require('gh-pages');
const path = require('path');

const basePath = path.join(__dirname, '../dist')

ghpages.publish( basePath, {
    add: true,
    message: 'Update' + ' ' + new Date().toISOString()
  },
  function(err) {console.log(err);}
);

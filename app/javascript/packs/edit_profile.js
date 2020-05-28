require('./default');

import select2 from 'select2';
import 'select2/dist/css/select2.css';

document.addEventListener("turbolinks:load", () => {
  $('.select2-target').select2({
    tags: true
  });
});

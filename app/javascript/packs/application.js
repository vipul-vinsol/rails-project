// FIXME_AB: extract these in default.js and require here
require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

import "bootstrap";
import "../stylesheets/application";
import $ from 'jquery';
import select2 from 'select2';
import 'select2/dist/css/select2.css';

document.addEventListener("turbolinks:load", () => {
  $('[data-toggle="tooltip"]').tooltip()
  $('[data-toggle="popover"]').popover()


  // FIXME_AB: make this selector specific, move it to edit_profile.js and include it in layout had using yield and content_for :js
  // FIXME_AB: https://github.com/rails/webpacker and use chunks
  $('select').select2({
    tags: true
  });


});


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
});

$(document).ready(function() {
  $('select').select2({
    tags: true
  });
});
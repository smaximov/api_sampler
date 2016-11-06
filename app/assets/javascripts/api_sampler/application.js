// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require semantic_ui/semantic_ui
//= require_tree .

$(document).ready(function() {
  var tags = $('.search.dropdown')
    .dropdown({
      match: 'text',
      forceSelection: false,
      onLabelCreate: function(value, text) {
        var color = $('.search.dropdown').find('option[value="' + value + '"]').attr('class')
        return this.addClass(color)
      }
    })

  var deleteSamples = $('#delete-samples')

  if (deleteSamples.length > 0) {
    var checked = new Set()

    $('.ui.delete.checkbox').checkbox({
      onChecked: function() {
        checked.add(this.value)
        deleteSamples.removeClass('disabled')
      },
      onUnchecked: function() {
        checked.delete(this.value)

        if (checked.size == 0) {
          deleteSamples.addClass('disabled')
        }
      }
    })
  }
})

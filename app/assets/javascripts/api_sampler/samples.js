$(document).ready(function() {
  function removePathParam() {
    $(this).closest('.fields').remove()
  }

  function addPathParam() {
    var paramI18n = $(this).data('paramI18n')
    var container = $('<div>', {
      'class': 'three fields'
    })

    $('<div>', { 'class': 'field' })
      .append($('<input>', {
        type: 'text',
        name: 'samples_filter[path_params][][param]',
        placeholder: paramI18n.name
      }))
      .appendTo(container)

    $('<div>', { 'class': 'field' })
      .append($('<input>', {
        type: 'text',
        name: 'samples_filter[path_params][][value]',
        placeholder: paramI18n.value
      }))
      .appendTo(container)

    $('<div>', { 'class': 'field' })
      .append($('<button>', {
        'class': 'ui right labeled icon button remove-path-param',
        html: '<i class="ui remove icon"></i>' + paramI18n.remove,
        on: {
          click: removePathParam
        }
      }))
      .appendTo(container)

    container.insertBefore($(this))
  }

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

  $('.remove-path-param').on('click', removePathParam)
  $('.add-path-param').on('click', addPathParam)
})

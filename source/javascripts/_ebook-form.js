$(function () {
  // These values should be identical to the ones in _popup.js
  var cookieExpiresOnSubmit = 30;
  var cookiePath = '/';
  var cookiePrefix = 'defacto_';
  var cookieValue = 'hidden';

  // Hide hightlight
  function hidePopup () {
    var $popup = $('#popup-ebook');

    if ($popup.length == 0) {
      return;
    }

    $popup.addClass('popup-hide');

    setTimeout(function () {
      $popup.remove();
    }, 400);

    var id = $popup[0].id;
    if (cookieExpiresOnSubmit && id) {
      Cookies.set(cookiePrefix + id, cookieValue, { expires: cookieExpiresOnSubmit, path: cookiePath });
    }
  }

  // Ebook form submit
  $('#ebook-download form').on('submit', function (event) {
    event.preventDefault();

    var ebookUrl = downloads.ebook[I18n.locale];
    var $form = $(this);
    var $submit = $form.find('button[type=submit]');

    // Submit form
    $.ajax({
      type: 'POST',
      url: $form.prop('action'),
      accept: {
        javascript: 'application/javascript'
      },
      data: $form.serialize(),
      beforeSend: function () {
        $submit.prop('disabled', 'disabled');
      }
    }).always(function () {
      $submit.prop('disabled', false);
    });

    // Download ebook
    window.open(ebookUrl, '_blank');

    // hide hightlight
    hidePopup();
  });
});

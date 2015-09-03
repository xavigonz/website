var Defacto = Defacto || {};

Defacto.ebookForm = {
  submit: function (event) {
    var ebookUrl = Defacto.downloads.ebook[Defacto.I18n.locale];
    var $form = $(this);
    var $submit = $form.find('button[type=submit]');
    var $formField = $form.find('input[name=form]');
    var $emailField = $form.find('input[name=email]');

    event.preventDefault();
    $submit.prop('disabled', 'disabled');

    // Validate
    if ($emailField.val().indexOf("@") < 1) {
      $submit.prop('disabled', false);
      $emailField.addClass('invalid').focus();
      return;
    }

    // Submit form
    $.ajax({
      type: 'POST',
      url: $form.prop('action'),
      accept: {
        javascript: 'application/javascript'
      },
      data: $form.serialize()
    }).always(function () {
      $submit.prop('disabled', false);
    });

    // Download ebook
    window.open(ebookUrl, '_blank');

    // Track conversion
    if (ga) {
      ga('send', 'pageview', '/bedankt/' + $formField.val());
    }

    // Hide hightlight
    var $popup = $(Defacto.popup.ebookPopupId);
    Defacto.popup.hide($popup, Defacto.popup.cookieExpiresOnSubmit);
  },

  init: function () {
    $('#ebook-download form').on('submit', Defacto.ebookForm.submit);
  }
};

Defacto.ebookForm.init();

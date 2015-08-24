// Make sure Popup elements (.popup) have an ID.

$(function () {
  var showScrollTop = 100; // pixels scrolled before showing popups
  var showDelay = 400; // ms before showing
  var cookieExpiresOnClose = 1 / 24 / 60 * 10; // 10 MINUTES till the cookie expires after closing
  var cookieExpiresOnSubmit = 30; // DAYS the cookie expires after submitting
  var cookiePath = '/';
  var cookiePrefix = 'defacto_';
  var cookieValue = 'hidden';
  var cookies = Cookies.get();
  var $window = $(window);
  var $body = $('body');
  var popupsShown;

  // console.log(Cookies.get()); // show all coockies
  // Cookies.remove('defacto_popup-ebook', { path: '/' }); // remove ebook cookie

  // Hide hightlight
  function hide ($popup, cookieExpires) {
    $popup.addClass('popup-hide');

    setTimeout(function () {
      $popup.remove();
    }, 400);

    var id = $popup[0].id;
    if (cookieExpires && id) {
      Cookies.set(cookiePrefix + id, cookieValue, { expires: cookieExpires, path: cookiePath });
    }
  }

  // Remove popups the user has closed
  $('.popup').each(function () {
    if (this.id && cookies[cookiePrefix + this.id] === cookieValue) {
      $(this).remove();
    }
  });

  // Show popup after scroll
  $window.on('scroll', function () {
    if (!popupsShown && $window.scrollTop() > showScrollTop) {
      setTimeout(function () {
        $('.popup').addClass('popup-show');
        popupsShown = true;
      }, showDelay);
    }
  });

  // Close popup button
  $body.on('click', '.popup .close', function (event) {
    event.preventDefault();

    var $popup = $(this).closest('.popup');
    hide($popup, cookieExpiresOnClose);
  });

  // Ebook form submit
  $body.on('submit', '#popup-ebook form', function (event) {
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
    var $popup = $form.closest('.popup');
    hide($popup, cookieExpiresOnSubmit);
  });
});

// Make sure Popup elements (.popup) have an ID.
window.Defacto = window.Defacto || {};

Defacto.popup = {
  showScrollTop: 100, // pixels scrolled before showing popups
  showDelay: 400, // ms before showing
  cookieExpiresOnClose: 1 / 24 / 60 * 30, // 30 MINUTES till the cookie expires after closing
  cookieExpiresOnSubmit: 30, // DAYS the cookie expires after closing
  cookiePath: '/',
  cookiePrefix: 'defacto_',
  cookieValue: 'hidden',
  cookies: Cookies.get(),
  $window: $(window),
  popupsShown: false,

  // console.log(Cookies.get()); // show all coockies
  // Cookies.remove('defacto_popup-ebook', { path: '/' }); // remove ebook cookie

  // Hide highlight
  hide: function ($popup, cookieExpires) {
    if ($popup.length === 0) {
      return false;
    }

    var id = $popup[0].id;
    if (cookieExpires && id) {
      Cookies.set(this.cookiePrefix + id, this.cookieValue,
        { expires: this.cookieExpires, path: this.cookiePath });
    }

    $popup.addClass('popup-hide');
    $(document).off('click.popup');

    setTimeout(function () {
      $popup.remove();
    }, 400);
  },

  init: function () {
    var $popups = $('.popup');

    // Check if a popup is present
    if ($popups.length === 0) {
      return false;
    }

    // Remove popups the user has closed
    var popupCookie = Defacto.popup.cookies[Defacto.popup.cookiePrefix + this.id];
    $popups.each(function () {
      if (this.id && popupCookie === Defacto.popup.cookieValue) {
        $(this).remove();
      }
    });

    // Show popup after scroll
    this.$window.on('scroll', function () {
      if (!Defacto.popup.popupsShown &&
        Defacto.popup.$window.scrollTop() > Defacto.popup.showScrollTop) {
        Defacto.popup.popupsShown = true;

        setTimeout(function () {
          $('.popup').addClass('popup-show');
          ga('send', 'event', 'popup', 'show', window.location.pathname);

          // Close popup on clicking anywhere else
          $(document).on('click.popup', function (event) {
            console.log(1);
            if (!$(event.target).parents().addBack().is('#js-popup-ebook') &&
                !$(event.target).parents().addBack().is('a')) {
              var $popup = $('#js-popup-ebook');
              Defacto.popup.hide($popup, Defacto.popup.cookieExpiresOnClose);
              ga('send', 'event', 'popup', 'close', window.location.pathname);
            }
          });
        }, Defacto.popup.showDelay);
      }
    });

    // Close popup on clicking on close button
    $(document).on('click', '.popup .close', function (event) {
      event.preventDefault();
      var $popup = $(this).closest('.popup');
      Defacto.popup.hide($popup, Defacto.popup.cookieExpiresOnClose);
      ga('send', 'event', 'popup', 'close', window.location.pathname);
    });
  },
};

Defacto.popup.init();

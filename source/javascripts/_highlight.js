// Make sure Highlight elements (.highlight) have an ID.

$(function () {
  var showScrollTop = 100; // pixels scrolled before showing highlights
  var showDelay = 400; // ms before showing
  var cookieExpires = 14; // days the cookie expires after closing highlight
  var cookiePrefix = 'highlight_';
  var cookieValue = 'hidden';
  var cookies = Cookies.get();
  var $window = $(window);
  var $body = $('body');
  var highlightShown;

  // console.log(cookies); // show all coockies
  // Cookies.remove('highlight_ebook'); // remove cookie

  // Hide hightlight
  function hide ($highlight, stayHidden) {
    $highlight.addClass('highlight-hide');

    setTimeout(function () {
      $highlight.remove();
    }, 400);

    var id = $highlight[0].id;
    if (stayHidden && id) {
      Cookies.set(cookiePrefix + id, cookieValue, { expires: cookieExpires });
    }
  }

  // Remove highlights the user has closed
  $('.highlight').each(function () {
    if (this.id && cookies[cookiePrefix + this.id] === cookieValue) {
      $(this).remove();
    }
  });

  // Show highlight after scroll
  $window.on('scroll', function () {
    if (!highlightShown && $window.scrollTop() > showScrollTop) {
      setTimeout(function () {
        $('.highlight').addClass('highlight-show');
        highlightShown = true;
      }, showDelay);
    }
  });

  // Close highlight button
  $body.on('click', '.highlight .close', function (event) {
    event.preventDefault();

    var $highlight = $(this).closest('.highlight');
    hide($highlight, true);
  });

  // Ebook form submit
  $body.on('submit', '#ebook.highlight form', function (event) {
    event.preventDefault();

    var ebookUrl = '/pdf/Handboek Leren en laten Leren.pdf';
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
    var $highlight = $form.closest('.highlight');
    hide($highlight, true);
  });
});

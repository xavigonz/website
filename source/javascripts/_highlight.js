// Make sure Highlight elements (.highlight) have an ID.

$(function () {
  var cookiePrefix = 'highlight_';
  var cookieValue = 'hidden';
  var cookies = Cookies.get();

  // console.log(cookies)
  // Cookies.remove('highlight_ebook');

  // Remove highlights the user has closed
  $('.highlight').each(function () {
    if (this.id && cookies[cookiePrefix + this.id] === cookieValue) {
      $(this).remove();
    }
  });

  // Close highlight button
  $('body').on('click', '.highlight .close', function () {
    var $highlight = $(this).closest('.highlight');
    $highlight.addClass('closing');

    setTimeout(function () {
      $highlight.remove();
    }, 400);

    var id = $highlight[0].id;
    if (id) {
      Cookies.set(cookiePrefix + id, cookieValue, { expires: 30 });
    }

    return false;
  });
});

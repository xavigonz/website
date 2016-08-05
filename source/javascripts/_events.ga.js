$(function () {
  $('[data-event]').on('click', function () {
    ga('send', 'event', 'button', 'click', $(this).data('event'));
  });
});

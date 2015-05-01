$(function () {
  $('.modal-state').on('change', function () {
    $('body').toggleClass('modal-open', $(this).is(':checked'));
  });

  $('.modal-window').on('click', function () {
    $(this).closest('.modal').find('.modal-state').prop('checked', false).change();
  });

  $('.modal-inner').on('click', function (event) {
    event.stopPropagation();
  });
});

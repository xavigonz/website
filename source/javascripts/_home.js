$(function () {
  $('.appointment-button').on('click', function (event) {
    event.preventDefault();
    var $this = $(this);
    var $form = $this.closest('.cta-appointment').find('form');
    var label = $this.text();

    // slide in form
    $form.slideDown(200);

    // focus first input
    $form.find('input[name="name"]').focus();

    // replace button with text
    label = label.charAt(0).toLowerCase() + label.slice(1) + ':';
    $this.replaceWith(label);
  });
});

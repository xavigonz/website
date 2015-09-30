$(function () {
  var popupDefaults = {
    width: 550,
    height: 250,
    menubar: 'no',
    toolbar: 'no',
    resizable: 'yes',
    scrollbars: 'yes'
  };

  $('.social-share a').on('click', function (event) {
    event.preventDefault();

    var $this = $(this);
    var popupData = $this.data('popup');

    if (popupData !== false) {
      popupData = $.extend({}, popupDefaults, $this.data('popup'));
      popupData.top = (screen.height / 2) - (popupData.height / 2);
      popupData.left = (screen.width / 2) - (popupData.width / 2);
      popupWindow(this.href, 'Share', popupData);
    } else {
      window.open(this.href, 'Share');
    }
  });

  var popupWindow = function (url, title, params) {
    var popupData = [];

    $.each(params, function (key, value) {
      popupData.push(key + '=' + value);
    });

    window.open(url, title, popupData.join(','));
  };
});

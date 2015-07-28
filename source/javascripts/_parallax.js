$(function () {
  var $window = $(window);
  $('[data-parallax="background"]').each(function () {
    var $this = $(this);
    var speed = $this.data('parallax-speed');
    var offset = $this.data('parallax-offset') || 0;

    $window.on('scroll', function () {
      var yPos = -($window.scrollTop() / speed);
      var coords = '50% ' + (yPos + offset) + 'px';
      $this.css('backgroundPosition', coords);
    });

    $window.scroll()
  });
});


var map;

function mapInit() {
  var defactoHQ = new google.maps.LatLng(53.212124, 6.57214);

  var mapOptions = {
    zoom: 16,
    center: defactoHQ,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    scrollwheel: false,
    draggable: true
  };

  map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

  var image = 'images/defacto-icon.png';
  var defactoMarker = new google.maps.Marker({
    position: defactoHQ,
    map: map,
    icon: image
  });
}

google.maps.event.addDomListener(window, 'load', mapInit);



/*
$(function() {
  var pull = $('#pull');
  var menu = $('nav ul');
  var menuHeight = menu.height();

  $(pull).on('click', function(e) {
    e.preventDefault();
    menu.slideToggle();
  });

  $(window).resize(function() {
    var w = $(window).width();
    if (w > 320 && menu.is(':hidden')) {
      menu.removeAttr('style');
    }
  });
});
*/
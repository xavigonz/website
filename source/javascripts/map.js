//= require jquery
var map;
function initialize() {
  var defactoHQ = new google.maps.LatLng(53.212124,6.57214);

  var mapOptions = {
    zoom: 16,
    center: defactoHQ,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    scrollwheel: false,
    draggable: true
  };
  map = new google.maps.Map(document.getElementById('map-canvas'),
                            mapOptions);

                            var image = 'images/defacto-icon.png';
                            var defactoMarker = new google.maps.Marker({
                              position: defactoHQ,
                              map: map,
                              icon: image
                            });
}

google.maps.event.addDomListener(window, 'load', initialize);

$(function() {
  var pull    = $('#pull');
  menu    = $('nav ul');
  menuHeight  = menu.height();

  $(pull).on('click', function(e) {
    e.preventDefault();
    menu.slideToggle();
  });

  $(window).resize(function(){
    var w = $(window).width();
    if(w > 320 && menu.is(':hidden')) {
      menu.removeAttr('style');
    }
  });
});

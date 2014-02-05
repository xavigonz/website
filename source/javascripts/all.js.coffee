
//= require jquery
//= require_tree .

$ ->
  $window = $(window)
  $("[data-paralax=\"background\"]").each ->
    $el = $(this)
    speed = $el.data("speed")
    $window.scroll ->
      yPos = -($window.scrollTop() / speed)
      coords = "50% " + (yPos - 30) + "px"
      $el.css backgroundPosition: coords
      return

    return

  return

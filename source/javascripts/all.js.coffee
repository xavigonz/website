
//= require jquery
//= require_tree .

$ ->
  $window = $(window)

  $("[data-parallax=\"background\"]").each ->
    $el = $(this)
    speed = $el.data("parallax-speed")
    offset = $el.data("parallax-offset") || 0

    $window.scroll ->
      yPos = -($window.scrollTop() / speed)
      coords = "" + (yPos + offset)
      $el.css backgroundPosition: coords
      return

    # Trigger scroll
    $window.scroll()

    return

  return

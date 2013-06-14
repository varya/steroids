steroids.view.navigationBar.show("AGDM-3000");

window.addEventListener("DOMContentLoaded", function() {

  // Disable user scrolling
  document.addEventListener("touchmove", function(e) { e.preventDefault(); });

  // Prime audio system for instant playback
  steroids.audio.prime();

  // Make drum pads change color and play a sound when tapped
  pads = document.querySelectorAll("div.drumpad-container > div");

  for (var i = 0; i < pads.length; i++) {

    pads[i].addEventListener("touchstart", function() {
      var soundPath = "sounds/drumMachineExample/" + this.getAttribute('data-sound');
      steroids.audio.play(soundPath);
      this.classList.add("active");
    });

    pads[i].addEventListener("touchend", function() {
      this.classList.remove("active");
    });
  }

});

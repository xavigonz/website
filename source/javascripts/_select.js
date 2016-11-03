var select = document.getElementById('select');
select.onchange = function () {
    select.className = this.options[this.selectedIndex].className;
  };

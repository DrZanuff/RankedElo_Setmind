$(document).ready(function(){

  $("#spinnerLoad").hide()

  $(".btn").click( function(){
    $("#spinnerLoad").show()
    $("#rank").css("opacity" , 0.2)
    // $("rank").src = 'images/Wolf.png'
  });

  //Image Loaded
  $("#rank").on("load" , function(){
    $("#spinnerLoad").hide();
    $("#rank").css("opacity" , 1.0);
    })
    .each( function(){
        if (this.complete){ $(this).load(); }
    });

});

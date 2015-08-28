//Place all the behaviors and hooks related to the matching controller here.
//All this logic will automatically be available in application.js.
//You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready(function(){
	bind();
});

function bind(){
	$(document).on('click', '.nav-drop-img', function(e){
		e.stopPropagation();
		$(this).parent().find('.navbar-nav').toggleClass('show');
	});
};
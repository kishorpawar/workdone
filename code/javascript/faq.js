$(document).ready(function(){
	$(function() {
		var fade = $('.question-container, .answer');
//		console.log(fade)
		fade.slideUp();
		$('.headings').click(function() {
			if ($(this).attr("class").indexOf("down") == -1 )
			{
				$(this).addClass('down')
				$(this).removeClass('up')
				$(this).next().slideUp('fast');
			}
			else if ($(this).attr("class").indexOf("up") == -1 )
			{	
				$('.question-container:not(.down)').slideUp('slow')
				$(this).addClass('up')
				$(this).removeClass('down')
				$(this).next().slideDown('fast');
			}
		});
	 });

//	$(".question, .answer").css('text-align',"left");
	
	$(function() {
		$('.question').click(function() {
			if ($(this).attr("class").indexOf("down") == -1 )
			{
				$(this).addClass('down')
				$(this).removeClass('up')
				$(this).next().slideUp('slow');
			}
			else if ($(this).attr("class").indexOf("up") == -1 )
			{	
				$('.answer:not(.down)').slideUp('slow')
				$(this).addClass('up')
				$(this).removeClass('down')
				$(this).next().slideDown('slow');
			}
		});
	 });
	 
	$(function() {
		$('.subheading').click(function() {
			if ($(this).attr("class").indexOf("down") == -1 )
			{
				$(this).addClass('down')
				$(this).removeClass('up')
				$(this).next().slideUp('slow');
			}
			else if ($(this).attr("class").indexOf("up") == -1 )
			{	
				$('.answer:not(.down)').slideUp('slow')
				$(this).addClass('up')
				$(this).removeClass('down')
				$(this).next().slideDown('slow');
			}
		});
	 });
	 

// end of documents reday
});
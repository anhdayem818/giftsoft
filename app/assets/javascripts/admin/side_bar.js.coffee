$(document).ready ->
	$('#btn-close').click ->
		if($(this).attr('state') == 'expand')
			$('#btn-close').siblings().hide()
			$('img', '#btn-close').rotate(180)
			$(this).attr('state', 'collapse')
			$('#content').css('padding-right', '32px')
			$('#content').attr('bg', $('#content').css('background'))
			$('#content').css('background', 'white')
			$('#sidebar').css('width', '32px')
			$('.index').css('width', '99.99%')
		else
			$('#btn-close').siblings().show()
			$('img', '#btn-close').rotate(0)
			$(this).attr('state', 'expand')
			$('#content').css('padding-right', '340px')
			$('#content').css('background', $('#content').attr('bg'))
			$('#sidebar').css('width', '305px')
			$('.index').css('width', '100%')
		
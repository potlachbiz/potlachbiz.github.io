---
---

current = (JSON.parse localStorage.getItem 'carello') ? []
cart = document.getElementById 'cart'
separator = ' / '

###
	Add to cart event handler
###

addcart = document.getElementById 'addcart'
if addcart then addcart.addEventListener 'click', (e) =>
	e.target.setAttribute 'disabled', true
	item = {
		id: e.target.getAttribute 'data-item'
		item: document.querySelector('.title').textContent
		price: document.querySelector('.price').textContent
		shipping: if document.querySelector('.shipping') then document.querySelector('.shipping').textContent else 0
	}
	current.push(item)
	localStorage.setItem 'carello', JSON.stringify current
	setInterval ->
		window.location = "/cart"
		return
	, 500

###
	Remove element from Cart
###

@remove = (i) ->
	current.splice i, 1
	localStorage.setItem 'carello', JSON.stringify current
	setInterval ->
		window.location = ""
		window.location.reload(true)
	, 500
	return

###
	Show cart
###

fillCart = ->
	if current.length == 0
		cart.innerHTML += '<p>Vuoto</p>'
	else
		subtotal = 0
		for ordine, index in current
			article = document.createElement 'article'
			ordine.shipping = (ordine.shipping) ? 0
			spedizione = if ordine.shipping > 0 then "#{separator} SPEDIZIONE € #{ordine.shipping}" else ''
			article.innerHTML = "<h2><a href='/article/##{ordine.id}'>#{ordine.item}</a></h2>" +
				"<p class='meta'>PREZZO € #{ordine.price}#{spedizione}<br>" +
				"<a href='javascript:remove(#{index});'>Rimuovi dal Carrello</a></p>"
			subtotal += (parseFloat ordine.price) + (parseFloat ordine.shipping)
			cart.appendChild article
		cart.innerHTML += "<h3>TOTALE € <span id='total'>#{subtotal.toFixed 2 }</span></h3>"
		buy = document.createElement 'div'
		buy.innerHTML = buttonCode()
		cart.appendChild buy
		paypal.button.process buy
	return

###
	Paypal button
###

buttonCode = ->
	# ADD PAYPAL BUTTON
	paypalButton = "<script async src='/javascripts/paypal-button.min.js?merchant=raveup@tiscali.it'
		data-button='paynow'
		data-upload='1'
		data-type='form'
		data-currency='EUR'"
	for order, i in current by -1
		paypalButton += " data-item_name_#{i+1}='#{order.item}'
		data-amount_#{i+1}='#{order.price}'
		data-quantity_#{i+1}='1'
		data-handling_#{i+1}='#{order.shipping}'
		data-item_number_#{i+1}='#{order.id}'"
	paypalButton += '></script>'
	paypalButton

###
	Check page
###

if document.getElementById 'cart' then fillCart()

---
---

main = document.querySelector 'main'
loader = main.querySelector 'h2:first-of-type'
apiUrl = 'https://public-api.wordpress.com/rest/v1.1/sites/potlachsite.wordpress.com/posts/'
separator = ' / '
hash = window.location.hash.substring 1
current = (JSON.parse localStorage.getItem 'carello') ? []

###
	@function {fill}: Fill div with products list
###

fill = (src) ->
	fetch src
		.then (response) ->
			if response.status >= 200 and response.status < 300
				return response.json()
			else
				error = new Error response.statusText
				error.response = response
				throw error
		.then (j) ->
			if j.posts
				loader.innerHTML = if hash then "CATEGORIA <span class='black'>#{hash}</span>" else "SHOP"
				posts = j.posts.map (p) -> render p
			else
				loader.innerHTML = "ARTICOLO"
				renderSingle j
		.catch (e) ->
			console.log e

###
	Render posts
###

render = (p) ->
	article = document.createElement 'article'
	categories = Object.keys(p.terms.category).map (c) ->
		"<a href='/category##{c}'>#{c}</a>"
	catList = categories.join ', '
	if Object.keys(p.tags)[0]
		price = "#{separator}PREZZO € " + Object.keys(p.tags)[0]
	else price = ''
	if Object.keys(p.tags)[1]
		shipping = "#{separator}SPEDIZIONE € " + Object.keys(p.tags)[0]
		price = "#{separator}PREZZO € " + Object.keys(p.tags)[1]
	else shipping = ''
	if p.post_thumbnail.URL
		article.innerHTML += "<img class='thumb' src='#{p.post_thumbnail.URL}' alt='#{p.title}'>"
	article.innerHTML += "<h2><a href='/article/##{p.ID}'>#{p.title}</a></h2>" +
	"<p class='meta'>CATEGORIA #{catList}#{price}#{shipping}</p>" +
	"#{p.excerpt}"
	main.appendChild(article)

###
	Render single post
###

renderSingle = (p) ->
	article = document.querySelector 'article'
	find = (i for i in current when i.id is p.ID.toString())
	if find.length > 0
		article.querySelector('p.incart').removeAttribute 'hidden'
	else if Object.keys(p.tags)[0]
		article.querySelector('button').removeAttribute 'hidden'
	else
		article.querySelector('p.contacts').removeAttribute 'hidden'
	categories = Object.keys(p.terms.category).map (c) ->
		"<a href='/category##{c}'>#{c}</a>"
	catList = categories.join ', '
	if Object.keys(p.tags)[0]
		price = "#{separator}PREZZO € <span class='price'>" + Object.keys(p.tags)[0] + "</span>"
	else price = ''
	if Object.keys(p.tags)[1]
		shipping = "#{separator}SPEDIZIONE € <span class='shipping'>" + Object.keys(p.tags)[0] + "</span>"
		price = "#{separator}PREZZO € <span class='price'>" + Object.keys(p.tags)[1] + "</span>"
	else shipping = ''
	article.querySelector('.title').innerHTML = p.title
	article.querySelector('.meta').innerHTML = "CATEGORIA #{catList}#{price}#{shipping}"
	article.querySelector('.content').innerHTML = p.content
	article.querySelector('button').setAttribute 'data-item', p.ID

###
	Check page
###

switch document.body.classList[0]
  when "shop-md" then fill "#{apiUrl}"
  when "article-md" then fill "#{apiUrl}#{hash}"
  when "category-md" then fill "#{apiUrl}?category=#{hash}"

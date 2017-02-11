---
---

###
	Header link to home
###

header = document.querySelector 'body:not(.index-md) > header > h1'
if header
	header.addEventListener 'click', (e) => window.location = "/"

###
	@function {fill}: Fill div with products list
###

fill = ->
  console.log 'ok'

###
	Check page
###

switch document.body.classList[0]
  when "products-md" then fill()

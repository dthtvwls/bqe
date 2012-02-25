This project is called BQE because I like [TLAs](http://en.wikipedia.org/wiki/Three-letter_acronym) and NYC (also a TLA).
It could stand for "Backbone Q. Express" (look, it's hard to backronym "Q", ok?),
but it also uses Socket.IO, Mongo, and some other stuff I'm sure you already like.
It is not a framework (yet), just an example CRUD MVC (hey, another TLA!) app.

Why? Harry Brundage has already [put it so well](http://harry.me/2011/01/27/today-web-development-sucks/).
Basically, I want both code and data to go between client and server as seamlessly as possible.

There are a number of strategies being used or planned for use which I will write about later.

I use [foreman](https://github.com/ddollar/foreman) to run:

`foreman start`

but you can always just

`coffee server/app.coffee`

and visit [http://localhost:5000/widgets](http://localhost:5000/widgets)
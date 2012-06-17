(function(g,b,d){var c=b.head||b.getElementsByTagName("head"),D="readyState",E="onreadystatechange",F="DOMContentLoaded",G="addEventListener",H=setTimeout;function f(){$LAB

.script('//cdnjs.cloudflare.com/ajax/libs/coffee-script/1.2.0/coffee-script.min.js')
.script('//cdnjs.cloudflare.com/ajax/libs/json2/20110223/json2.js')
.script('//cdnjs.cloudflare.com/ajax/libs/socket.io/0.8.4/socket.io.min.js')
.script('//cdnjs.cloudflare.com/ajax/libs/modernizr/2.5.3/modernizr.min.js')
.script('//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.3.1/underscore-min.js')
.script('//cdnjs.cloudflare.com/ajax/libs/handlebars.js/1.0.0.beta2/handlebars.min.js')
.script('//ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js').wait()
.script('//ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js')
.script('//cdnjs.cloudflare.com/ajax/libs/backbone.js/0.9.1/backbone-min.js')
.wait(function(){CoffeeScript.load('/script.coffee');});

}H(function(){if("item"in c){if(!c[0]){H(arguments.callee,25);return}c=c[0]}var a=b.createElement("script"),e=false;a.onload=a[E]=function(){if((a[D]&&a[D]!=="complete"&&a[D]!=="loaded")||e){return false}a.onload=a[E]=null;e=true;f()};
a.src="//cdnjs.cloudflare.com/ajax/libs/labjs/2.0.3/LAB.min.js";c.insertBefore(a,c.firstChild)},0);if(b[D]==null&&b[G]){b[D]="loading";b[G](F,d=function(){b.removeEventListener(F,d,false);b[D]="complete"},false)}})(this,document);

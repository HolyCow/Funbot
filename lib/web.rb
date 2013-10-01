require 'sinatra'
require 'sinatra/json'
require './lib/database'

set :bind, '0.0.0.0'
set :static, true
set :public_folder, "#{File.dirname(__FILE__)}/public"
set :logging, true

get '/count' do 
	"#{Title.all.count}"
end

get '/titles' do 
	content_type :json
	Title.all(:order => [:vote_count.desc, :id.desc]).to_json
end

get '/titles/:id/vote' do
	title = Title.get(params[:id]);
	puts title
	if title
		voted = title.votes(:voter_ip => request.ip).count
		puts voted
		if voted == 0
			title.votes.create(:voter_ip => request.ip)
			title.update(:vote_count => title.votes.count)
			title.save
			puts title
		end
		"#{title.votes.count}"
	end
end

get '/' do 
'
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8" />
		<title>Shewbot</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css">
		<!--<link rel="stylesheet" href="css/shewbot.css">-->
	</head>
	<body>
		<div class="container">
			<div class="navbar navbar-default" role="navigation">
				<div class="navbar-header">
					<a class="navbar-brand" href="/">Shewbot</a>
				</div>
				<p class="navbar-text pull-right">
					Don''t refresh, jerks!
				</p>
			</div>
			<h2>' + Show.current.title + '</h2>
			<div id="titles" class="row">Loading...</div>
		</div>
		<script id="headerTemplate" type="text/template">
		<tr>
			<th>Vote</th>
			<th>Title</th>
			<th>Submitter</th>
			<th>Votes</th>
		</tr>
		</script>
		<script id="titleTemplate" type="text/template">
			<td><span class="vote glyphicon glyphicon-arrow-up" id="<%= id %>"></span></td>
			<td><%= title %></td>
			<td><%= user %></td>
			<td><%= vote_count %></td>
		</script>
		<script>var titles = ' + Title.all(:order => [:vote_count.desc, :id.desc]).to_json + '</script>
		<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.0.3/jquery.min.js"></script>
		<script src="//netdna.bootstrapcdn.com/bootstrap/3.0.0/js/bootstrap.min.js"></script>
		<script src="//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.5.2/underscore-min.js"></script>
		<script src="//cdnjs.cloudflare.com/ajax/libs/backbone.js/1.0.0/backbone-min.js"></script>
		<script src="js/app.js"></script>
		<script>
			$(document).on("click", "span.vote", function(event) {
				console.log("click" + event.target.id, this);
				$.get("/titles/" + event.target.id + "/vote");
				$(this).hide();
			});

			$(function() { 
				var titleTable = Shewbot.boot($("#titles"), titles);
			});</script>
	</body>
</html>
'
end
# Simple Board Game using WebSockets in Rails

This is a board game which uses websockets for two way communication.
We are using websocket-rails gem for facilitating websockets in rails.
MySql is being used as the database for storing game related data.
In the client side local storage is being used for persistence.

# System Specifications

	* Ruby version          : ruby 2.3.0p0

	* Rails version         : Rails 4.2.0

	* System dependencies   : Linux, 1GB RAM, (Firefox, Google Chrome)

# Instruction for running the app in local box
	
	1. Install system dependencies
	2. Migrate the db using 'rake db:migrate'
	3. Run the server using 'rails s -p port_number'

# How to Play?

	1. Go to the url(for local 'localhost:port_number')
	2. Check if any game is already there by clicking on 'Join Game' and then 'Refresh list!'
	3. For joining any game click 'Join'
	4. Click on any of the boxes to aquire it.
	5. Once acquire the game will be unavailable for 'x' sec (x set by the user while creating the game)
	6. The player having maximum box acquired will win!

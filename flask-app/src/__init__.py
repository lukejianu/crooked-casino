from flask import Flask
from flaskext.mysql import MySQL

# Create a MySQL object that we will use in other parts of the API.
db = MySQL()

def create_app():
    app = Flask(__name__)

    # Secret key that will be used for securely signing the session
    # cookie and can be used for any other security related needs by
    # extensions or your application.
    app.config['SECRET_KEY'] = 'someCrazyS3cR3T!Key.!'

    # These are for the DB object to be able to connect to MySQL.
    app.config['MYSQL_DATABASE_USER'] = 'webapp'
    app.config['MYSQL_DATABASE_PASSWORD'] = open('/secrets/db_password.txt').readline()
    app.config['MYSQL_DATABASE_HOST'] = 'db'
    app.config['MYSQL_DATABASE_PORT'] = 3306 # Access using 3200. 
    app.config['MYSQL_DATABASE_DB'] = 'casino_db'

    # Initialize the database object with the settings above.
    db.init_app(app)

    # Import the various routes
    from src.admin.admin import admin
    from src.dealer.dealer import dealer
    from src.player.player import player

    # Register the routes that we just imported so they can be properly handled
    app.register_blueprint(admin,    url_prefix='/app')
    app.register_blueprint(dealer,    url_prefix='/app')
    app.register_blueprint(player,    url_prefix='/app')

    return app
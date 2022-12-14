from flask import Blueprint, request
from src import db
from utils import executeQuery

# Blueprint for route on the player page.
player = Blueprint('player', __name__)

# Getting players to populate a dropdown.
@player.route('/players', methods=['GET'])
def get_players():
    response = executeQuery('SELECT firstName label, playerId value FROM Player')
    return response

# Get the portfolio of the player that corresponds to the given playerId.
@player.route('/portfolio/<playerId>', methods=['GET'])
def get_portfolio(playerId):
    response = executeQuery(f'''SELECT 
    total_chips_value, num_1, num_5, num_10, num_25, num_100 
    FROM Player NATURAL JOIN Portfolio WHERE playerId = {playerId}''')
    return response

# Updates the portfolio of the specified player (passes the data in the header). 
@player.route('/portfolio/<playerId>', methods=['POST'])
def update_portfolio(playerId):
    cursor = db.get_db().cursor()

    num1_to_add = request.headers["num_1"]
    num5_to_add = request.headers["num_5"]
    num10_to_add = request.headers["num_10"]
    num25_to_add = request.headers["num_25"]
    num100_to_add = request.headers["num_100"]
    
    cursor.execute(f'''UPDATE Portfolio SET 
                    num_1 = num_1 + {num1_to_add}, 
                    num_5 = num_5 + {num5_to_add}, 
                    num_10 = num_10 + {num10_to_add}, 
                    num_25 = num_25 + {num25_to_add}, 
                    num_100 = num_100 + {num100_to_add}, 
                    total_chips_value = num_1 + num_5 * 5 + num_10 * 10 + num_25 * 25 + num_100 * 100 
                    WHERE playerId = {playerId};''')
    db.get_db().commit()
    return "SUCCESS"
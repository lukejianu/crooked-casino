from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


player = Blueprint('player', __name__)

# Player Page: Adding chips

# Getting players to populate a dropdown.
@player.route('/players', methods=['GET'])
def get_players():
    cursor = db.get_db().cursor()
    cursor.execute('select firstName as label, playerId as value from Player')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get the portfolio of the player that corresponds to the given playerId.
@player.route('/portfolio/<playerId>', methods=['GET'])
def get_portfolio(playerId):
    cursor = db.get_db().cursor()
    # playerId = request.headers["playerId"]
    cursor.execute(
        f'select total_chips_value, num_1, num_5, num_10, num_25, num_100 from Player NATURAL JOIN Portfolio WHERE playerId = {playerId}')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Add a post 
@player.route('/portfolio/<playerId>', methods=['POST'])
def update_portfolio(playerId):
    cursor = db.get_db().cursor()
    # playerId = request.headers["playerId"]
    num1_to_add = request.headers["num_1"]
    num5_to_add = request.headers["num_5"]
    num10_to_add = request.headers["num_10"]
    num25_to_add = request.headers["num_25"]
    num100_to_add = request.headers["num_100"]
    
    cursor.execute(
        f'''UPDATE Portfolio SET num_1 = num_1 + {num1_to_add}, num_5 = num_5 + {num5_to_add}, num_10 = num_10 + {num10_to_add}, num_25 = num_25 + {num25_to_add}, 
        num_100 = num_100 + {num100_to_add}, total_chips_value = num_1 + num_5 * 5 + num_10 * 10 + num_25 * 25 + num_100 * 100 WHERE playerId = {playerId};''')
    db.get_db().commit()
    return "success"
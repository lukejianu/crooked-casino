from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


dealer = Blueprint('dealer', __name__)

# Dealer page: 
# Get all dealers 
@dealer.route('/dealers', methods=['GET'])
def get_dealers(): 
    cursor = db.get_db().cursor()
    cursor.execute('select firstName as label, dealerId as value from Dealer')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@dealer.route('/players/<dealerId>', methods=['GET'])
def get_players_at_table(dealerId):
    cursor = db.get_db().cursor()
    cursor.execute(f'''SELECT P.playerId, P.firstName, P.lastName, P.netWorth, P.numDependents, P.frustrationLevel FROM (SELECT * FROM PokerTable NATURAL JOIN Dealer) N 
    INNER JOIN Player P ON N.tableId=P.tableId WHERE dealerId={dealerId};''')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@dealer.route('/player/<playerId>', methods=['GET'])
def get_player(playerId):
    cursor = db.get_db().cursor()
    cursor.execute(f'SELECT * FROM Player WHERE playerId={playerId}')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response
from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


admin = Blueprint('admin', __name__)

# Admin page
@admin.route('/profits', methods=['GET'])
def get_profits():
    cursor = db.get_db().cursor()
    cursor.execute(f'SELECT tableId, SUM(winLossAmt) as profit FROM PokerTable NATURAL JOIN TableHistory GROUP BY tableId ORDER BY tableId;')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@admin.route('/chart', methods=['GET'])
def get_chart():
    cursor = db.get_db().cursor()
    cursor.execute(f'SELECT tableId as x, SUM(winLossAmt) as y FROM PokerTable NATURAL JOIN TableHistory GROUP BY tableId ORDER BY tableId;')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response
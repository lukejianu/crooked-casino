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

@admin.route('/employees', methods=['GET'])
def get_employees():
    """
    Employee management view, where admins can see who each employee reports and their
    dealer stats, namely, friendliness, corruptness and scumminess.
    """
    QUERY = """
        SELECT d.firstName, d.lastName, d.friendliness, d.corruptness, d.scumminess, A.role, A.firstName as Reports_To from Dealer d
        JOIN PokerTable PT ON d.tableId = PT.tableId
        JOIN AdminTableBridge ATB ON PT.tableId = ATB.tableId
        JOIN Admin A ON ATB.adminId = A.adminId;
    """
    cursor = db.get_db().cursor()
    cursor.execute(QUERY)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@admin.route('/dealer-friendliness', methods=['GET'])
def get_avg_friendliness():
    """
    Get the average friendliness across all dealers.
    """
    QUERY = """
        SELECT AVG(friendliness) as Avg_Friendliness FROM Dealer;
    """
    cursor = db.get_db().cursor()
    cursor.execute(QUERY)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


@admin.route('/dealer-corruptness', methods=['GET'])
def get_avg_corruptness():
    """
    Get the average corruptness across all dealers.
    """
    QUERY = """
        SELECT AVG(corruptness) as Avg_Corruptness FROM Dealer;
    """
    cursor = db.get_db().cursor()
    cursor.execute(QUERY)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@admin.route('/dealer-scumminess', methods=['GET'])
def get_avg_scumminess():
    """
    Get the average scumminess across all dealers.
    """
    QUERY = """
        SELECT AVG(scumminess) as Avg_Scumminess FROM Dealer;
    """
    cursor = db.get_db().cursor()
    cursor.execute(QUERY)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


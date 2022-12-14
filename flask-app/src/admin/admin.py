from flask import Blueprint
from src import db
from utils import executeQuery

# Blueprint for the admin pages.
admin = Blueprint('admin', __name__)

# Returns the profits at every table in the casino.
@admin.route('/profits', methods=['GET'])
def get_profits():
    response = executeQuery(f'''SELECT tableId, SUM(winLossAmt) as profit 
                            FROM PokerTable NATURAL JOIN TableHistory 
                            GROUP BY tableId ORDER BY tableId;''')
    return response

# Returns data used to populate a chart of tables and their respective profits.
@admin.route('/chart', methods=['GET'])
def get_chart():
    response = executeQuery(f'''SELECT tableId as x, SUM(winLossAmt) as y FROM PokerTable 
                            NATURAL JOIN TableHistory GROUP BY tableId ORDER BY tableId;''')
    return response

# Returns information about all employees (dealers).
@admin.route('/employees', methods=['GET'])
def get_employees():
    response = executeQuery("""SELECT A.firstName Supervisor, A.role Role, d.firstName, d.lastName, 
                            d.friendliness, d.corruptness, d.scumminess, dealerId from Dealer d
                            JOIN PokerTable PT ON d.tableId = PT.tableId
                            JOIN AdminTableBridge ATB ON PT.tableId = ATB.tableId
                            JOIN Admin A ON ATB.adminId = A.adminId;""")
    return response

# Returns average data about all the dealers in the database.
@admin.route('/dealer-data', methods=['GET'])
def get_dealer_data():
    response = executeQuery("""SELECT 
                            AVG(scumminess) scum, AVG(corruptness) corr, AVG(friendliness) friend 
                            FROM Dealer;""")
    return response

# Removes the dealer with the given dealerID.
@admin.route('/fire-dealer/<dealerId>', methods=['POST'])
def remove_dealer(dealerId):
    cursor = db.get_db().cursor()
    query = f'DELETE FROM Dealer WHERE dealerId = {dealerId}'
    cursor.execute(query)
    db.get_db().commit()
    return "SUCCESS"
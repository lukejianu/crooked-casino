from flask import Blueprint
from utils import executeQuery

# Blueprint for routes on the dealer pages.
dealer = Blueprint('dealer', __name__)

# Get all dealers 
@dealer.route('/dealers', methods=['GET'])
def get_dealers(): 
    response = executeQuery('select firstName as label, dealerId as value from Dealer')
    return response

@dealer.route('/players/<dealerId>', methods=['GET'])
def get_players_at_table(dealerId):
    response = executeQuery(f'''SELECT 
                            P.playerId, P.firstName, P.lastName, P.netWorth, P.numDependents, P.frustrationLevel 
                            FROM (SELECT * FROM PokerTable NATURAL JOIN Dealer) N 
                            INNER JOIN Player P ON N.tableId=P.tableId WHERE dealerId={dealerId};''')
    return response

@dealer.route('/player/<playerId>', methods=['GET'])
def get_player(playerId):
    response = executeQuery(f'SELECT * FROM Player WHERE playerId={playerId}')
    return response
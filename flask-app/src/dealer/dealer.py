from flask import Blueprint
from utils import executeQuery

# Blueprint for routes on the dealer pages.
dealer = Blueprint('dealer', __name__)

# Getting all dealers to populate a dropdown.
@dealer.route('/dealers', methods=['GET'])
def get_dealers(): 
    response = executeQuery('SELECT firstName label, dealerId value FROM Dealer')
    return response

# Getting the players at a certain dealers table.
@dealer.route('/players/<dealerId>', methods=['GET'])
def get_players_at_table(dealerId):
    response = executeQuery(f'''SELECT 
                            P.playerId, P.firstName, P.lastName, P.netWorth, P.numDependents, P.frustrationLevel 
                            FROM (SELECT * FROM PokerTable NATURAL JOIN Dealer) N 
                            INNER JOIN Player P ON N.tableId=P.tableId WHERE dealerId={dealerId};''')
    return response

# Getting a certain player. 
@dealer.route('/player/<playerId>', methods=['GET'])
def get_player(playerId):
    response = executeQuery(f'SELECT * FROM Player WHERE playerId={playerId}')
    return response
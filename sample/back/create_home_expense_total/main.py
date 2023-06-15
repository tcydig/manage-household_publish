from flask import escape
import json
import functions_framework
from google.cloud import firestore
from datetime import datetime, timedelta, date, timezone
from dateutil.relativedelta import relativedelta
from enum import Enum

class Expense(Enum):
    Rent = 1
    Gas = 2
    Water = 3
    Electric = 4
    Internet = 5
    Food = 6
    Others = 7


@functions_framework.http
def create_home_expense_total(request):
    # get updateDateTime, expenseId, userId, status, balanceEntered from request body
    request_json = request.get_json(silent=True)

    # get updateDateTime
    JST = timezone(timedelta(hours=+9), 'JST')
    updateDateTime_datetime = datetime.now(JST)

    # get month edited
    yearMonth_string = ''
    if request_json and 'yearMonth' in request_json:
        yearMonth_string = request_json['yearMonth']
    else:
        raise ValueError("JSON is invalid, or missing a 'yearMonth' property")
    yearMonth_datetime = trunc_datetime(datetime.strptime(yearMonth_string, '%Y-%m-%d %H:%M:%S'))
    yearMonth_string = yearMonth_datetime.strftime('%Y%m')

    # initialize firestore library 
    db = firestore.Client()

    # get documnet where is month edited
    doc = db.collection('expense-month-summary').document(yearMonth_string).get()

    if doc.exists:
        # if there is document that named to yearMonth_string 
        # update totalBalance. updateDatetime, specific expense, 

        doc_dict = doc.to_dict()
        final_totalBalance = doc_dict['totalBalance']
        final_expense_totalBalance = doc_dict['expenses'][request_json['expenseId'] - 1]['totalBalance']

        # caculate totalBalance
        if request_json['status'] == 'D':
            final_totalBalance -= request_json['balanceEntered']
            final_expense_totalBalance -= request_json['balanceEntered']
        else:
            final_totalBalance += request_json['balanceEntered']
            final_expense_totalBalance += request_json['balanceEntered']
        
        # Check if final_totalBalance is less that 0
        if final_totalBalance < 0 or final_expense_totalBalance < 0:
            raise ValueError("totalBalanc is less than 0 So you can't decrease any more")

        # update specific expense balance
        update_expenseMonthSummary = {}
        update_expenseMonthSummary['totalBalance'] = final_totalBalance
        update_expenseMonthSummary['updateDateTime'] = updateDateTime_datetime
        expense_list = doc_dict['expenses']
        expense_list[request_json['expenseId'] - 1]['totalBalance'] = final_expense_totalBalance
        update_expenseMonthSummary['expenses'] = expense_list
        db.collection('expense-month-summary').document(yearMonth_string).update(update_expenseMonthSummary)
    else:
        # if there is not document that named to yearMonth_string

        # Check status, if nagative was choiced, return error
        if request_json['status'] == 'D':
            raise ValueError("now is 0 So you can't decrease any more")

        # create new document
        create_expenseMonthSummary = {}
        create_expenseMonthSummary['totalBalance'] = request_json['balanceEntered']
        create_expenseMonthSummary['updateDateTime'] = updateDateTime_datetime
        create_expenseMonthSummary['yearMonth'] = yearMonth_datetime
        create_expenseMonthSummary_expeses = []
        for expense in Expense:
            expense_map = {}
            expense_map["expenseId"] = expense.value
            balanceOfExpense = ''
            if expense.value == request_json['expenseId']:
                balanceOfExpense = request_json['balanceEntered']
            else:
                balanceOfExpense = 0
            expense_map["totalBalance"] = balanceOfExpense
            create_expenseMonthSummary_expeses.append(expense_map)
        create_expenseMonthSummary['expenses'] = create_expenseMonthSummary_expeses
        db.collection(u'expense-month-summary').document(yearMonth_string).set(create_expenseMonthSummary)

    # create new active history
    activeHistory_firestore = {}
    activeHistory_firestore['balance'] = request_json['balanceEntered']
    activeHistory_firestore['expenseId'] = request_json['expenseId']
    activeHistory_firestore['status'] = request_json['status']
    activeHistory_firestore['updateDateTime'] = updateDateTime_datetime
    activeHistory_firestore['userId'] = request_json['userId']
    activeHistory_firestore['toUserId'] = request_json['userId']
    activeHistory_firestore['category'] = 'h'
    db.collection(u'expense-month-summary').document(yearMonth_string).collection(u'active-history').add(activeHistory_firestore)

    return 'success'

def trunc_datetime(someDate):
    return someDate.replace(day=1, hour=0, minute=0, second=0, microsecond=0,tzinfo=None)
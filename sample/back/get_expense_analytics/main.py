from flask import escape,Response
import json
import functions_framework
from google.cloud import firestore
from datetime import datetime, timedelta, date
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

default_monthExpnese = {
    'totalBalance':0,
    'expenses':[
        {
            'expenseId':1,
            'totalBalance':0,
        },
        {
            'expenseId':2,
            'totalBalance':0,
        },
        {
            'expenseId':3,
            'totalBalance':0,
        },
        {
            'expenseId':4,
            'totalBalance':0,
        },
        {
            'expenseId':5,
            'totalBalance':0,
        },
        {
            'expenseId':6,
            'totalBalance':0,
        },
        {
            'expenseId':7,
            'totalBalance':0,
        }
    ],
}

@functions_framework.http
def get_expense_analytics(request):

    # obtain range from min month to max month (seven months)
    today = datetime.now()
    res = today.replace(day=1)
    min_month = trunc_datetime(res + relativedelta(months=-7))
    max_month = trunc_datetime(res + relativedelta(months=0))
    min_month_string = min_month.strftime('%Y%m')

    # initialize firestore library 
    db = firestore.Client()

    # get ducs from user collection
    if request.args.get('pageCategory') == 'u':
        docs = db.collection('user-month-summary').where(u'yearMonth', u'>=', min_month).where(u'yearMonth', u'<=', max_month).where(u'userId', u'==', int(request.args.get('userId'))).get()
    else:
        docs = db.collection('expense-month-summary').where(u'yearMonth', u'>=', min_month).where(u'yearMonth', u'<=', max_month).get()
    response_list = []
    lastMonth_map = docs[0].to_dict()
    if lastMonth_map['yearMonth'].strftime('%Y%m') != min_month_string:
        lastMonth_map = default_monthExpnese

    for i in range(7):
        month = min_month + relativedelta(months=i + 1)
        response_map = {}
        totalBalance = 0
        totalBalanceDifference = lastMonth_map['expenses'][int(request.args.get('expenseId')) - 1]['totalBalance']
        exitFlg = False
        for doc in docs:
            expenseAnalytics = doc.to_dict()
            if trunc_datetime(expenseAnalytics['yearMonth']) == month:
                expense_firesstore = expenseAnalytics['expenses'][int(request.args.get('expenseId')) - 1]
                totalBalance = expense_firesstore["totalBalance"]
                lastMonth_map = expenseAnalytics
                exitFlg = True
                break
        if not exitFlg:
            # if expense_list is empty, store initial object to expense_list
            lastMonth_map = default_monthExpnese

        response_map['id'] = i
        response_map['totalBalance'] = totalBalance
        response_map['totalBalanceDifference'] = totalBalance - totalBalanceDifference
        response_map['yearMonth'] = trunc_datetime(month)
        response_map['animate'] = False
        response_list.append(response_map)
    
    # ensure_ascii=False -> if there is japanese, you can escape japanese
    response = Response(json.dumps(response_list, ensure_ascii=False,default=json_serial))
    response.headers['Content-Type'] = "application/json"
    return response


def json_serial(obj):

    if isinstance(obj, (datetime, date)):
        return obj.isoformat()
    raise TypeError (f'Type {obj} not serializable')

def trunc_datetime(someDate):
    return someDate.replace(day=1, hour=0, minute=0, second=0, microsecond=0,tzinfo=None)
    
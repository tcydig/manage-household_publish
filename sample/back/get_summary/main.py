from flask import escape,Response
import json
import functions_framework
from google.cloud import firestore
from datetime import datetime, timedelta, date
from dateutil.relativedelta import relativedelta
from enum import Enum

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
def get_summary(request):
    # initialize firestore library 
    db = firestore.Client()

    # get expenseCategoryInfo from firestore
    expensecategories_fireStore = db.collection('expense').get()
    expensecategories_dic = {}
    for expensecategory in expensecategories_fireStore:
        expensecategories_dic[expensecategory.to_dict()['expenseId']] = expensecategory.to_dict()['name']

    # obtain range from min month to max month (seven months)
    today = datetime.now()
    res = today.replace(day=1)
    min_month = trunc_datetime(res + relativedelta(months=-4))
    max_month = trunc_datetime(res + relativedelta(months=3))
    min_month_string = min_month.strftime('%Y%m')

    # get ducs from user collection
    if request.args.get('toCategory') == 'u':
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
        expense_list = []
        yourExpenseList = []
        othereExpenseList = []
        totalBalance = 0
        totalBalanceDifference = lastMonth_map['totalBalance']

        for doc in docs:
            expenseMonthSummary = doc.to_dict()
            if trunc_datetime(expenseMonthSummary['yearMonth']) == month:
                
                for i,expnese in enumerate(expenseMonthSummary['expenses']):
                    expense_map = {}
                    expense_map["id"] = i
                    expense_map["expenseId"] = expnese["expenseId"]
                    expense_map["name"] = expensecategories_dic[expnese["expenseId"]]
                    expense_map["balance"] = expnese["totalBalance"]
                    expense_map["totalBalanceDifference"] = expnese["totalBalance"] - lastMonth_map['expenses'][i]['totalBalance']
                    expense_list.append(expense_map)
                totalBalance = expenseMonthSummary["totalBalance"]
                lastMonth_map = expenseMonthSummary
                break

        if not expense_list:
            # if expense_list is empty, store initial object to expense_list
            for key,value in expensecategories_dic.items():
                expense_map = {}
                expense_map["id"] = key - 1
                expense_map["expenseId"] = key
                expense_map["name"] = value
                expense_map["balance"] = 0
                expense_map["totalBalanceDifference"] = 0 - lastMonth_map['expenses'][key - 1]['totalBalance']
                expense_list.append(expense_map)
            lastMonth_map = default_monthExpnese

        response_map['totalBalance'] = totalBalance
        response_map['totalBalanceDifference'] = totalBalance - totalBalanceDifference
        response_map['expenses'] = expense_list
        response_map['yearMonth'] = trunc_datetime(month)
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
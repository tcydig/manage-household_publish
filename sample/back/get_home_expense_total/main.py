from flask import escape,Response
import json
import functions_framework
from google.cloud import firestore
from datetime import datetime, timedelta, date
from dateutil.relativedelta import relativedelta
from enum import Enum

@functions_framework.http
def get_home_expense_total(request):
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
    min_manth = trunc_datetime(res + relativedelta(months=-3))
    max_manth = trunc_datetime(res + relativedelta(months=3))

    # get ducs from user collection
    docs = db.collection('expense-month-summary').where(u'yearMonth', u'>=', min_manth).where(u'yearMonth', u'<=', max_manth).get()

    response_list = []

    for i in range(7):
        month = min_manth + relativedelta(months=i)
        response_map = {}
        expense_list = []
        yourExpenseList = []
        othereExpenseList = []

        # fix to get document with yearMonth of string
        for doc in docs:
            expenseMonthSummary = doc.to_dict()

            if trunc_datetime(expenseMonthSummary['yearMonth']) == month:
                
                for i,expnese in enumerate(expenseMonthSummary['expenses']):
                    expense_map = {}
                    expense_map["id"] = i
                    expense_map["expenseId"] = expnese["expenseId"]
                    expense_map["name"] = expensecategories_dic[expense_map["expenseId"]]
                    expense_map["balance"] = expnese["totalBalance"]
                    expense_list.append(expense_map)

        if not expense_list:
            # if expense_list is empty, store initial object to expense_list
            for key,value in expensecategories_dic.items():
                expense_map = {}
                expense_map["id"] = key - 1
                expense_map["expenseId"] = key
                expense_map["name"] = value
                expense_map["totalBalance"] = 0
                expense_list.append(expense_map)

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
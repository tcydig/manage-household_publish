from flask import escape,Response
import json
import functions_framework
from google.cloud import firestore
from datetime import datetime, timedelta, date
from dateutil.relativedelta import relativedelta
from enum import Enum
from itertools import zip_longest

@functions_framework.http
def get_user_expense(request):
    # initialize firestore library 
    db = firestore.Client()

    # get expenseCategoryInfo from firestore
    expensecategories_fireStore = db.collection('expense').get()
    expensecategories_dic = {}
    for expensecategory in expensecategories_fireStore:
        expensecategories_dic[expensecategory.to_dict()['expenseId']] = expensecategory.to_dict()['name']

    # get userId from request
    userId = int(request.args.get("userId"))

    # obtain range from min month to max month (seven months)
    today = datetime.now()
    res = today.replace(day=1)
    min_manth = trunc_datetime(res + relativedelta(months=-3))
    max_manth = trunc_datetime(res + relativedelta(months=3))

    # get ducs from user collection
    docs = db.collection('user-month-summary').where(u'yearMonth', u'>=', min_manth).where(u'yearMonth', u'<=', max_manth).get()  

    response_list = []

    for i in range(7):
        month = min_manth + relativedelta(months=i)
        response_map = {}
        expense_list = []
        yourExpenseList = []
        otherExpenseList = []
        # user_index = 0
        for doc in docs:
            user = doc.to_dict()

            if trunc_datetime(user['yearMonth']) == month:
                # if this is same month
                if userId == user['userId']:
                    yourExpenseList = user['expenses']
                else:
                    otherExpenseList = user['expenses']

        if yourExpenseList or otherExpenseList:
            for yourExpense, otherExpense in zip_longest(yourExpenseList,otherExpenseList):
                expense_map = {}
                expense_map["expenseId"] = yourExpense["expenseId"] if yourExpense else otherExpense["expenseId"]
                expense_map['id'] = expense_map["expenseId"] - 1
                expense_map["yourBalance"] = yourExpense["totalBalance"] if yourExpense else 0
                expense_map["name"] = expensecategories_dic[expense_map["expenseId"]]
                expense_map["otherBalance"] = otherExpense["totalBalance"] if otherExpense else 0
                expense_list.append(expense_map)

        if not expense_list:
            # if expense_list is empty, store initial object to expense_list
            for key,value in expensecategories_dic.items():
                expense_map = {}
                expense_map["id"] = key - 1
                expense_map["expenseId"] = key
                expense_map["yourBalance"] = 0
                expense_map["name"] = value
                expense_map["otherBalance"] = 0
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
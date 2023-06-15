from flask import escape,Response
import json
import functions_framework
from google.cloud import firestore
from datetime import datetime, timedelta, date
from dateutil.relativedelta import relativedelta
from enum import Enum

DATE_FORMAT = '%Y-%m-%dT%H:%M:%S'

@functions_framework.http
def get_activity_history_oneMonth(request):

    # initialize firestore library 
    db = firestore.Client()

    # get userInfo from firestore
    users_fireStore = db.collection('user').get()
    users_dic = {}
    for user in users_fireStore:
        users_dic[user.to_dict()['userId']] = user.to_dict()['name']        

    # get expenseCategoryInfo from firestore
    expensecategories_fireStore = db.collection('expense').get()
    expensecategories_dic = {}
    for expensecategory in expensecategories_fireStore:
        expensecategories_dic[expensecategory.to_dict()['expenseId']] = expensecategory.to_dict()['name']

    # obtain range from min month to max month (seven months)
    today = datetime.now()
    res = today.replace(day=1)

    yearMonth_string = request.args.get('yearMonth')
    yearMonth_datetime = trunc_datetime(datetime.strptime(yearMonth_string, '%Y-%m-%d %H:%M:%S'))
    yearMonth_string = yearMonth_datetime.strftime('%Y%m')

    response_list = []
    # get ducs from user collection   
    doc = db.collection('expense-month-summary').document(yearMonth_string).get()
    if request.args.get('toCategory') == 'e':
        response_list = get_eachExpense_history(doc,int(request.args.get('limit')),int(request.args.get('expenseId')),users_dic,expensecategories_dic,request.args.get('pageCategory'))
    else:
        response_list = get_userHome_history(doc,int(request.args.get('limit')), request.args.get('toCategory'),users_dic,expensecategories_dic)

    response = Response(json.dumps(response_list, ensure_ascii=False,default=json_serial))
    response.headers['Content-Type'] = "application/json"
    return response

def get_userHome_history(doc,limit,toCategory,users_dic,expensecategories_dic):

    response_list = []

    if doc.exists:
        for i,history in enumerate(doc.reference.collection('active-history').where(u'category', u'==', toCategory).get()):
            map = history.to_dict()
            map['id'] = i
            map['userName'] = users_dic[map['userId']]
            map['toUserName'] = users_dic[map['toUserId']]
            map['expenseName'] = expensecategories_dic[map['expenseId']]
            response_list.append(map)
            if i == (limit - 1):
                break
        response_list = sort_yearMonth_insertion(response_list)
    return response_list

def get_eachExpense_history(doc,limit,expenseId,users_dic,expensecategories_dic,pageCategory):

    response_list = []

    if doc.exists:
        for i,history in enumerate(doc.reference.collection('active-history').where(u'expenseId', u'==', expenseId).where(u'category', u'==', pageCategory).get()):
            map = history.to_dict()
            map['id'] = i
            map['userName'] = users_dic[map['userId']]
            map['toUserName'] = users_dic[map['toUserId']]
            map['expenseName'] = expensecategories_dic[map['expenseId']]
            response_list.append(map)
            if i == (limit - 1):
                break
        response_list = sort_yearMonth_insertion(response_list)
    return response_list

def json_serial(obj):

    if isinstance(obj, (datetime, date)):
        return obj.strftime(DATE_FORMAT)
    raise TypeError (f'Type {obj} not serializable')

def trunc_datetime(someDate):
    return someDate.replace(day=1, hour=0, minute=0, second=0, microsecond=0,tzinfo=None)

def sort_yearMonth_insertion(response_month_list):
    for i in range(len(response_month_list) - 1):
        next_index = i + 1
        while i >= 0:
            if response_month_list[next_index]['updateDateTime'] > response_month_list[i]['updateDateTime']:
                response_month_list[i]['id'], response_month_list[next_index]['id'] = response_month_list[next_index]['id'], response_month_list[i]['id']                
                response_month_list[i], response_month_list[next_index] = response_month_list[next_index], response_month_list[i]
                i -= 1
                next_index -= 1
            else:
                break
    return response_month_list